{ pkgs, config, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    openFirewall = true; # se quiser acessar remotamente
    host = "0.0.0.0"; # Adicione isso para garantir visibilidade total
    port = 11434;
    loadModels = [
      "qwen3.5:9b"
      "qwen3.5:4b"
      "gemma4:e4b"
      "granite3.3:8b"
      "translategemma:12b"
      "gema4:31b"
      "deepseek-ocr:3b"
      "glm-5.1:cloud"
      "minimax-m2.7:cloud"
      "gemma4:31b-cloud"
      "qwen3.5:cloud"
    ];
    environmentVariables = {
      OLLAMA_API_KEY = "${config.sops.placeholder.ollama_key}";
      # Exemplo: OLLAMA_HOST = "0.0.0.0:11434";
    };
  };

  services.open-webui.enable = true;

}
