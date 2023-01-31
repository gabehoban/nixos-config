{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.gpg;

in {
  options.modules.gpg = { enable = mkEnableOption "gpg"; };
  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      publicKeys = [{
        source =
          (builtins.fetchurl { url = "https://github.com/gabehoban.gpg"; sha256 = "a2e08cf7d11bf12302b6bb3d3bb680def5650f3befa2838feb56e51b6ab63cea"; });
        trust = 5;
      }];
      settings = {
        personal-cipher-preferences = "AES256 AES192 AES";
        personal-digest-preferences = "SHA512 SHA384 SHA256";
        personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
        default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
        cert-digest-algo = "SHA512";
        s2k-digest-algo = "SHA512";
        s2k-cipher-algo = "AES256";
        charset = "utf-8";
        fixed-list-mode = true;
        no-comments = true;
        no-emit-version = true;
        keyid-format = "0xlong";
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
        with-fingerprint = true;
        require-cross-certification = true;
        no-symkey-cache = true;
        throw-keyids = true;
      };
    };

    # Fix pass
    services.gpg-agent = {
      enable = true;
      pinentryFlavor = "qt";
    };
  };
}
