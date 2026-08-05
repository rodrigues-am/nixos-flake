{ ... }:

{
  home.file.".XCompose".text = ''
    include "/%L"


    # Compose key (Multi_key = Right Ctrl) + ' + c
    <Multi_key> <'> <c> : "ç"
    <Multi_key> <Shift> <'> <c> : "Ç"

    # Dead acute (US intl dead key) + c — sobrepõe o ć do en_US.UTF-8
    <dead_acute> <c> : "ç"
    <dead_acute> <C> : "Ç"

  '';
}
