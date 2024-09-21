{
  programs.terminator = {
    enable = true;
    config = {
      profiles.default = {
        use_system_font = false;
        font = "FiraCode Nerd Font Regular 15";
        scrollbar_position = "disabled";
        show_titlebar = false;
      };
    };
  };
}
