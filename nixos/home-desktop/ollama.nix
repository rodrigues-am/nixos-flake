{ pkgs, config, ... }:
{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    openFirewall = true; # se quiser acessar remotamente
    host = "0.0.0.0"; # Adicione isso para garantir visibilidade total
    port = 11434;
    loadModels = [
      "gemma4:12b"
      "deepseek-ocr:3b"
      "embeddinggemma:300m"
    ];
    environmentVariables = {
      OLLAMA_API_KEY = "${config.sops.placeholder.ollama_key}";
      # Exemplo: OLLAMA_HOST = "0.0.0.0:11434";
    };
  };

  #services.open-webui.enable = true;

}
