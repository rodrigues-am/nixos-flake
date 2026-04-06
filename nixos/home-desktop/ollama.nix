{ pkgs, ... }:
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
      "deepseek-ocr:3b"
    ];
  };
}
