{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:
let
  user = userSettings.name;
  stateDir = "/home/${user}/.local/share/hermes-agent";
  tailscaleAddress = "100.83.180.41";

  hindsightImage = "ghcr.io/vectorize-io/hindsight:0.9.1@sha256:a0e937366261b8a8f20ebcaf13758c689c381dcbbf01684e4375c2787c8c666d";

  hindsightClientConfig = builtins.toJSON {
    mode = "local_external";
    api_url = "http://127.0.0.1:8888";
    api_key = config.sops.placeholder.hindsight_api_key;
    # Todos os perfis compartilham deliberadamente o mesmo banco. A origem do
    # perfil continua registrada nos metadados das memórias migradas.
    bank_id = "hermes-shared";
    bank_mission = "Memória durável compartilhada por todos os perfis do Hermes Agent de André.";
    recall_budget = "mid";
    recall_types = "observation,world,experience";
    memory_mode = "hybrid";
    recall_prefetch_method = "recall";
    auto_recall = true;
    recall_sync = false;
    auto_retain = true;
    retain_every_n_turns = 1;
    retain_async = true;
    prefetch_waits_for_retain = true;
    timeout = 180;
  };

  configureProfiles = pkgs.writeText "configure-hermes-hindsight-profiles.py" ''
    from __future__ import annotations

    from datetime import datetime, timezone
    import os
    from pathlib import Path
    import pwd
    import re
    import shutil
    import tempfile

    state_dir = Path(os.environ["HERMES_STATE_DIR"])
    hindsight_config = Path(os.environ["HINDSIGHT_CLIENT_CONFIG"])
    account = pwd.getpwnam(os.environ["HERMES_USER"])
    uid, gid = account.pw_uid, account.pw_gid

    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ")

    def atomic_write(path: Path, content: str, mode: int) -> None:
        path.parent.mkdir(parents=True, exist_ok=True)
        fd, temporary = tempfile.mkstemp(prefix=f".{path.name}.", dir=path.parent)
        try:
            with os.fdopen(fd, "w", encoding="utf-8") as handle:
                handle.write(content)
                handle.flush()
                os.fsync(handle.fileno())
            os.chmod(temporary, mode)
            os.chown(temporary, uid, gid)
            os.replace(temporary, path)
        finally:
            try:
                os.unlink(temporary)
            except FileNotFoundError:
                pass

    def backup(path: Path) -> None:
        target = path.with_name(f"{path.name}.pre-hindsight-{stamp}.bak")
        shutil.copy2(path, target)
        os.chown(target, uid, gid)

    def configure_named_profile(root: Path) -> bool:
        path = root / "config.yaml"
        if not path.exists():
            return False
        original = path.read_text(encoding="utf-8")
        lines = original.splitlines()
        memory_start = next((i for i, line in enumerate(lines) if re.match(r"^memory:\s*(?:#.*)?$", line)), None)
        if memory_start is None:
            if lines and lines[-1] != "":
                lines.append("")
            lines.extend(["memory:", "  provider: hindsight"])
        else:
            memory_end = len(lines)
            for i in range(memory_start + 1, len(lines)):
                line = lines[i]
                if line and not line[0].isspace() and not line.lstrip().startswith("#"):
                    memory_end = i
                    break
            provider_index = next(
                (
                    i
                    for i in range(memory_start + 1, memory_end)
                    if re.match(r"^\s+provider\s*:", lines[i])
                ),
                None,
            )
            if provider_index is None:
                lines.insert(memory_start + 1, "  provider: hindsight")
            else:
                indent = re.match(r"^(\s*)", lines[provider_index]).group(1)
                lines[provider_index] = f"{indent}provider: hindsight"
        updated = "\n".join(lines).rstrip("\n") + "\n"
        if updated == original:
            return False
        backup(path)
        mode = path.stat().st_mode & 0o777
        atomic_write(path, updated, mode)
        return True

    def link_hindsight_config(root: Path) -> bool:
        path = root / "hindsight" / "config.json"
        path.parent.mkdir(parents=True, exist_ok=True)
        if path.is_symlink() and path.resolve() == hindsight_config.resolve():
            return False
        if path.exists():
            backup(path)
            path.unlink()
        elif path.is_symlink():
            path.unlink()
        temporary = path.with_name(f".{path.name}.{stamp}.tmp")
        try:
            temporary.symlink_to(hindsight_config)
            os.lchown(temporary, uid, gid)
            os.replace(temporary, path)
        finally:
            try:
                temporary.unlink()
            except FileNotFoundError:
                pass
        return True

    profiles_root = state_dir / ".hermes" / "profiles"
    roots = []
    if profiles_root.is_dir():
        roots = [
            entry
            for entry in sorted(profiles_root.iterdir())
            if entry.is_dir() and (entry / "config.yaml").exists()
        ]

    changed_config = sum(int(configure_named_profile(root)) for root in roots)
    changed_links = int(link_hindsight_config(state_dir / ".hermes"))
    changed_links += sum(int(link_hindsight_config(root)) for root in roots)
    print(
        f"Hindsight profile configuration: config={changed_config} "
        f"links={changed_links}"
    )
  '';
in
{
  # O Hindsight usa o PostgreSQL persistente do host. A senha em claro fica
  # somente no SOPS/runtime; o Nix store recebe apenas o verificador SCRAM.
  services.postgresql = {
    ensureDatabases = [ "hindsight" ];
    ensureUsers = [
      {
        name = "hindsight";
        ensureDBOwnership = true;
        ensureClauses = {
          login = true;
          password = "SCRAM-SHA-256$4096:LDh0LTGRjwOFaHyaYIKnfQ==$b1SLdJ2XAa83sJqms8c8yFL67RsHrQ5+1L8IAvmmccM=:o2OHZ09ywNyrQto3Z7iF2ChiNXGrW46lP22Zj3ivR4U=";
        };
      }
    ];
    authentication = lib.mkBefore ''
      host hindsight hindsight 127.0.0.1/32 scram-sha-256
    '';
  };

  services.postgresqlBackup = {
    enable = true;
    databases = [ "hindsight" ];
    startAt = "*-*-* 03:15:00";
    compression = "zstd";
    compressionLevel = 6;
  };

  sops.secrets = {
    hindsight_api_key = {
      owner = user;
      group = user;
      mode = "0400";
    };
    hindsight_db_password = {
      mode = "0400";
    };
    hindsight_ui_key = {
      owner = user;
      group = user;
      mode = "0400";
    };
  };

  sops.templates = {
    "hindsight-server.env" = {
      mode = "0400";
      restartUnits = [ "docker-hindsight.service" ];
      content = ''
        HINDSIGHT_API_LLM_API_KEY=${config.sops.placeholder.ollama_key}
        HINDSIGHT_API_DATABASE_URL=postgresql://hindsight:${config.sops.placeholder.hindsight_db_password}@127.0.0.1:5432/hindsight
        HINDSIGHT_API_TENANT_API_KEY=${config.sops.placeholder.hindsight_api_key}
        HINDSIGHT_CP_DATAPLANE_API_KEY=${config.sops.placeholder.hindsight_api_key}
        HINDSIGHT_CP_ACCESS_KEY=${config.sops.placeholder.hindsight_ui_key}
      '';
    };

    "hindsight-hermes.env" = {
      owner = user;
      group = user;
      mode = "0400";
      restartUnits = [
        "hermes-agent.service"
        "hermes-agent-secretario.service"
        "hermes-dashboard.service"
      ];
      content = ''
        HINDSIGHT_API_KEY=${config.sops.placeholder.hindsight_api_key}
      '';
    };

    "hindsight-client.json" = {
      owner = user;
      group = user;
      mode = "0400";
      # O gateway mantém o provedor em memória. Reinicie os consumidores quando
      # banco, modo de recall ou outra configuração do cliente mudar.
      restartUnits = [
        "hermes-agent.service"
        "hermes-agent-secretario.service"
        "hermes-dashboard.service"
      ];
      content = hindsightClientConfig;
    };

    "hindsight-access.env" = {
      owner = user;
      group = user;
      mode = "0400";
      content = ''
        HINDSIGHT_WEB_URL=http://${tailscaleAddress}:9999
        HINDSIGHT_UI_KEY=${config.sops.placeholder.hindsight_ui_key}
      '';
    };
  };

  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.hindsight = {
      image = hindsightImage;
      autoStart = true;
      environment = {
        HINDSIGHT_API_HOST = "127.0.0.1";
        HINDSIGHT_API_PORT = "8888";
        HINDSIGHT_API_WORKER_ID = "hermes-server-hindsight";
        HINDSIGHT_API_DB_POOL_MIN_SIZE = "2";
        HINDSIGHT_API_DB_POOL_MAX_SIZE = "10";
        HINDSIGHT_API_LLM_PROVIDER = "ollama-cloud";
        HINDSIGHT_API_LLM_MODEL = "glm-5.2";
        HINDSIGHT_API_LLM_MAX_CONCURRENT = "2";
        HINDSIGHT_API_EMBEDDINGS_PROVIDER = "local";
        HINDSIGHT_API_EMBEDDINGS_LOCAL_MODEL = "sentence-transformers/paraphrase-multilingual-MiniLM-L12-v2";
        HINDSIGHT_API_RERANKER_PROVIDER = "local";
        HINDSIGHT_API_RERANKER_LOCAL_MODEL = "cross-encoder/mmarco-mMiniLMv2-L12-H384-v1";
        HINDSIGHT_API_TEXT_SEARCH_EXTENSION = "native";
        HINDSIGHT_API_TEXT_SEARCH_EXTENSION_NATIVE_LANGUAGE = "simple";
        HINDSIGHT_API_TENANT_EXTENSION = "hindsight_api.extensions.builtin.tenant:ApiKeyTenantExtension";
        HINDSIGHT_CP_HOSTNAME = "0.0.0.0";
        HINDSIGHT_CP_PORT = "9999";
        HINDSIGHT_CP_DATAPLANE_API_URL = "http://127.0.0.1:8888";
        HF_HOME = "/home/hindsight/.cache/huggingface";
        PYTHONUNBUFFERED = "1";
      };
      environmentFiles = [ config.sops.templates."hindsight-server.env".path ];
      volumes = [ "hindsight-model-cache:/home/hindsight/.cache" ];
      extraOptions = [
        "--network=host"
        "--stop-timeout=45"
        "--memory=5g"
        "--memory-swap=5g"
        "--cpus=3.0"
        "--pids-limit=2048"
        "--cap-drop=ALL"
        "--security-opt=no-new-privileges"
        "--health-cmd=curl -fsS http://127.0.0.1:8888/health || exit 1"
        "--health-interval=30s"
        "--health-timeout=10s"
        "--health-retries=5"
        "--health-start-period=10m"
        # NixOS usa o driver journald; sua retenção é gerida pelo próprio
        # journal. max-size/max-file são opções inválidas para esse driver.
      ];
    };
  };

  systemd = {
    services = {
      postgresql-hindsight-extensions = {
        description = "Install PostgreSQL extensions required by Hindsight";
        # postgresql-setup cria os bancos e papéis declarados. Ordenar somente
        # após postgresql.service permite uma corrida na primeira ativação.
        after = [
          "postgresql.service"
          "postgresql-setup.service"
        ];
        requires = [
          "postgresql.service"
          "postgresql-setup.service"
        ];
        before = [ "docker-hindsight.service" ];
        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
          Group = "postgres";
        };
        path = [ config.services.postgresql.package ];
        script = ''
          psql --dbname=hindsight --set=ON_ERROR_STOP=1 \
            --command='CREATE EXTENSION IF NOT EXISTS vector;' \
            --command='CREATE EXTENSION IF NOT EXISTS pg_trgm;'
        '';
      };

      "docker-hindsight" = {
        after = [
          "network-online.target"
          "postgresql-hindsight-extensions.service"
        ];
        requires = [ "postgresql-hindsight-extensions.service" ];
        wants = [ "network-online.target" ];
      };

      hindsight-healthcheck = {
        description = "Wait for the Hindsight API";
        after = [ "docker-hindsight.service" ];
        requires = [ "docker-hindsight.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [
          pkgs.coreutils
          pkgs.curl
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          for attempt in $(seq 1 180); do
            if curl --fail --silent --show-error http://127.0.0.1:8888/health >/dev/null; then
              exit 0
            fi
            sleep 5
          done
          echo "Hindsight API did not become healthy within 15 minutes" >&2
          exit 1
        '';
      };
    };

    # O acesso à UI é uma conveniência para shells interativos. A configuração
    # do plugin é ligada pelo script de ativação ao HERMES_HOME de cada perfil.
    tmpfiles.rules = [
      "d /home/${user}/.config/hindsight 0700 ${user} ${user} -"
      "L+ /home/${user}/.config/hindsight/access.env - - - - ${
        config.sops.templates."hindsight-access.env".path
      }"
    ];
  };

  # Em cada ativação, habilita o provedor nos perfis nomeados existentes.
  # A chave permanece no arquivo global renderizado pelo SOPS.
  system.activationScripts.hindsightProfiles = {
    deps = [ "users" ];
    text = ''
      HERMES_STATE_DIR=${lib.escapeShellArg stateDir} \
      HERMES_USER=${lib.escapeShellArg user} \
      HINDSIGHT_CLIENT_CONFIG=${lib.escapeShellArg config.sops.templates."hindsight-client.json".path} \
        ${pkgs.python3}/bin/python3 ${configureProfiles}
    '';
  };

  # A API permanece no loopback. Somente a interface web (9999) escuta no
  # host; o firewall não abre a porta globalmente e tailscale0 já é confiável.
  environment.systemPackages = [ pkgs.docker ];

  assertions = [
    {
      assertion = builtins.elem "tailscale0" config.networking.firewall.trustedInterfaces;
      message = "Hindsight expects tailscale0 to be trusted for Tailnet-only access to port 9999.";
    }
  ];
}
