{

  programs.bash = {

    enable = true;
    historyControl = [ "ignoredups" ];
    historySize = 1000000;
    historyFileSize = 1000000;

    initExtra = ''
             eval "$(starship init bash)"
             eval "$(pandoc --bash-completion)"
      #      export PATH="$XDG_CONFIG_HOME/emacs/bin:$PATH"
             export PATH="$HOME/.emacs.d/bin:$PATH"
             export GTK_IM_MODULE="cedilla"
    '';

    shellAliases = {
      la = "exa -la --icons --grid";
      ls = "exa --icons";
      cat = "bat";
      gedit = "gnome-text-editor";
      amr-nixos-home-desktop =
        "sudo nixos-rebuild switch --flake ~/nixos-flake#home-desktop";
      amr-nixos-hp-laptop =
        "sudo nixos-rebuild switch --flake ~/nixos-flake#hp-laptop";
    };

  };

}
