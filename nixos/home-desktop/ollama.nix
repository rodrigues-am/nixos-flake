{ ... }: {
  services.ollama = {
    enable = true;
    openFirewall = true; # se quiser acessar remotamente
    loadModels = [
      "llama3-groq-tool-use:8b"
      "deepseek-r1:1.5b"
      "rns96/deepseek-R1-ablated:f16_Q4KM"
      "qwen3.5:9b"
      "qwen3.5:4b"
      "qwen3.5:2b"
      "qwen3.5:0.8b"
      "gemma3:4b"
      "deepseek-r1:8b"
      "granite3.3:8b"
      "translategemma:12b"
    ];
  };
}
