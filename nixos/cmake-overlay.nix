# overlays/cmake-overlay.nix
final: prev: {
  ########################################
  # Fix CMake (< 3.5) em pacotes C/C++
  ########################################

  cld2 = prev.cld2.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
  });

  maim = prev.maim.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
  });

  #########################################################
  # Desativar testes problemáticos do img2pdf (afeta ocrmypdf)
  #########################################################

  # Conjunto padrão (cobre muitos casos)
  python3Packages = prev.python3Packages.overrideScope' (self: super: {
    img2pdf = super.img2pdf.overrideAttrs (old: {
      doCheck = false;
      # Caso queira manter parte dos testes:
      # pytestFlagsArray = (old.pytestFlagsArray or []) ++ [ "-k" "not test_date" ];
    });
  });

  # Conjunto específico do Python 3.13 (observado no seu log)
  python313Packages = if prev ? python313Packages then
    prev.python313Packages.overrideScope' (self: super: {
      img2pdf = super.img2pdf.overrideAttrs (old: {
        doCheck = false;
        # pytestFlagsArray = (old.pytestFlagsArray or []) ++ [ "-k" "not test_date" ];
      });
    })
  else
    prev.python3Packages;
}
# nixos/overlays/build-fixes.nix
final: prev: {
  ########################################
  # Fix CMake (< 3.5) em pacotes C/C++
  ########################################

  cld2 = prev.cld2.overrideAttrs (old: {
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
  });

  maim = prev.maim.overrideAttrs (old: {
    # Força a policy e também sobe cmake_minimum_required via patch
    cmakeFlags = (old.cmakeFlags or []) ++ [
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
    postPatch = (old.postPatch or "") + ''
      if grep -q "cmake_minimum_required" CMakeLists.txt; then
        substituteInPlace CMakeLists.txt \
          --replace "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.5)" \
          --replace "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.5)" \
          --replace "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.5)" || true
      fi
    '';
  });

  #########################################################
  # Desativar testes problemáticos do img2pdf (afeta ocrmypdf)
  #########################################################

  python3Packages = prev.python3Packages.overrideScope' (self: super: {
    img2pdf = super.img2pdf.overrideAttrs (old: {
      doCheck = false;
    });
  });

  # Cobrir Python 3.13 se existir no canal
  python313Packages = if prev ? python313Packages then
    prev.python313Packages.overrideScope' (self: super: {
      img2pdf = super.img2pdf.overrideAttrs (old: {
        doCheck = false;
      });
    })
  else
    prev.python3Packages;
}
