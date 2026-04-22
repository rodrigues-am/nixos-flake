final: prev:
let
  version = "0.21.0";
  src = prev.fetchFromGitHub {
    owner = "ollama";
    repo = "ollama";
    tag = "v${version}";
    hash = "sha256-Ic3eLOohLR7MQGkLvDJBNOCiBBKxh6l8X9MgK0b4w+Y=";
  };
in
{
  ollama = prev.ollama.overrideAttrs (old: {
    inherit version src;
    vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
  });

  ollama-cuda = prev.ollama-cuda.overrideAttrs (old: {
    inherit version src;
    vendorHash = "sha256-Lc1Ktdqtv2VhJQssk8K1UOimeEjVNvDWePE9WkamCos=";
  });
}
