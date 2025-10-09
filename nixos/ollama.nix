{ ... }: {
  services.ollama = {
    enable = true;
    openFirewall = true; # se quiser acessar remotamente
    loadModels = [
      "llama3-groq-tool-use:8b"
      "deepseek-r1:1.5b"
      #      "deepseek-r1-coder-tools:1.5b"
      "rns96/deepseek-R1-ablated:f16_Q4KM"
      "qwen2.5-coder:7b"
    ];
  };
}
