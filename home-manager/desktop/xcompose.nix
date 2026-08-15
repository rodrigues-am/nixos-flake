_:

{
  home.file.".XCompose".text = ''
    # Forma documentada pelo Xlib. O Brave em XWayland depende deste parser.
    include "%L"


    # Compose key (Multi_key = Right Ctrl) + ' + c
    <Multi_key> <apostrophe> <c> : "ç" ccedilla
    <Multi_key> <apostrophe> <C> : "Ç" Ccedilla

    # Dead acute (US intl dead key) + c — sobrepõe o ć do en_US.UTF-8
    <dead_acute> <c> : "ç" ccedilla
    <dead_acute> <C> : "Ç" Ccedilla

  '';
}
