{ config, lib, pkgs, ... }: {
  # Enable OpenGL

  hardware.graphics.enable = true;
  #Enable OpenGL

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.

    #open = true;
    open = false;

    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # hardware.opengl.driSupport = true;
  # hardware.opengl.driSupport32Bit = true;
  # hardware.opengl.extraPackages = with pkgs; [
  #   nvidia-vaapi-driver
  #   libvdpau
  #   libvulkan
  #   vulkan-loader
  #   vulkan-validation-layers
  # ];
  # hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [
  #   libvulkan
  #   vulkan-loader
  # ];

}
