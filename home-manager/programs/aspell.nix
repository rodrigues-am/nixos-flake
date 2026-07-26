{ ... }: {
  home.file = {
    ".aspell.conf".text = ''

      dict-dir /etc/profiles/per-user/andre/lib/aspell
      lang en_US
    '';
  };

}
