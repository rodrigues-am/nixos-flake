{ config, pkgs, ... }:

{
  # Ativa o suporte a impressão
  services.printing.enable = true;

  # Instala os drivers da HP
  services.printing.drivers = [ pkgs.hplip ];

  # Ativa o serviço de sane para digitalização
  hardware.sane.enable = true;

  # Habilita o hplip como um backend para o sane
  hardware.sane.extraBackends = [ pkgs.hplip ];

  # Permite o uso de aplicativos gráficos para digitalização
  environment.systemPackages = with pkgs; [
    # Exemplo de aplicativos de digitalização
    simple-scan
    xsane
  ];
}
