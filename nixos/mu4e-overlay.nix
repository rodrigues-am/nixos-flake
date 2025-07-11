{ super, ... }:

let
  mu4e-src = super.fetchFromGitHub {
    owner = "djcb";
    repo = "mu";
    rev = "1.12.3"; # Escolha a versão estável do mu que preferir
    sha256 =
      "sha256-6CNih4UVFP0kNIt2R5DrY2wQAVOhsRDqpVQFyLVaNBo="; # Atualize se necessário
  };

in {
  emacsPackagesFor = emacs:
    super.emacsPackagesFor emacs // {
      mu4e = super.stdenv.mkDerivation {
        pname = "mu4e";
        version = "1.12.3";
        src = mu4e-src;

        buildInputs = [ emacs ];

        installPhase = ''
          mkdir -p $out/share/emacs/site-lisp/mu4e
          cp -r mu4e/* $out/share/emacs/site-lisp/mu4e/
        '';

        meta = with super.lib; {
          description = "An email client for Emacs based on mu";
          homepage = "https://github.com/djcb/mu";
          license = licenses.gpl3Plus;
          maintainers = [ maintainers.djc ];
        };
      };
    };
}
