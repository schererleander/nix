{
  flake.modules.homeManager.iterm2 =
    { lib, pkgs, ... }:
    let
      color = r: g: b: {
        "Red Component" = r / 255.0;
        "Green Component" = g / 255.0;
        "Blue Component" = b / 255.0;
        "Alpha Component" = 1.0;
        "Color Space" = "sRGB";
      };
      black = color 0 0 0;
      white = color 255 255 255;
      palette = bright: {
        "Ansi 0 Color" = black;
        "Ansi 1 Color" = color 204 36 29;
        "Ansi 2 Color" = color 152 151 26;
        "Ansi 3 Color" = color 215 153 33;
        "Ansi 4 Color" = color 69 133 136;
        "Ansi 5 Color" = color 177 98 134;
        "Ansi 6 Color" = color 104 157 106;
        "Ansi 7 Color" = color 235 219 178;
        "Ansi 8 Color" = color 124 124 124;
        "Ansi 9 Color" = if bright then color 251 73 52 else color 157 0 6;
        "Ansi 10 Color" = if bright then color 184 187 38 else color 121 116 14;
        "Ansi 11 Color" = if bright then color 250 189 47 else color 181 118 20;
        "Ansi 12 Color" = if bright then color 131 165 152 else color 7 102 120;
        "Ansi 13 Color" = if bright then color 211 134 155 else color 143 63 113;
        "Ansi 14 Color" = if bright then color 142 192 124 else color 66 123 88;
        "Ansi 15 Color" = white;
      };
      dark = palette true // {
        "Background Color" = black;
        "Foreground Color" = color 235 219 178;
        "Bold Color" = color 251 241 199;
        "Cursor Color" = color 235 219 178;
        "Cursor Text Color" = black;
        "Selection Color" = color 48 48 48;
        "Selected Text Color" = white;
      };
      light = palette false // {
        "Background Color" = white;
        "Foreground Color" = color 60 56 54;
        "Bold Color" = color 40 40 40;
        "Cursor Color" = color 60 56 54;
        "Cursor Text Color" = white;
        "Selection Color" = color 224 224 224;
        "Selected Text Color" = black;
      };
      profile =
        dark
        // {
          Name = "Gruvbox";
          Guid = "a906aa72-00b0-4d6d-bbee-b799a99befd8";
          "Dynamic Profile Parent Name" = "Default";
          "Use Separate Colors for Light and Dark Mode" = true;
          Transparency = 0.10;
          Blur = true;
          "Blur Radius" = 20;
          "Background Image Location" = "";
          "Use Tab Color" = false;
          "Normal Font" = "JetBrainsMono-Regular 13";
          "ASCII Ligatures" = true;
          "Cursor Type" = 1;
          "Blinking Cursor" = true;
          "Animate Movement" = true;
        }
        // lib.mapAttrs' (name: value: lib.nameValuePair "${name} (Dark)" value) dark
        // lib.mapAttrs' (name: value: lib.nameValuePair "${name} (Light)" value) light;
    in
    {
      home.packages = [ pkgs.iterm2 ];

      targets.darwin.defaults."com.googlecode.iterm2"."Default Bookmark Guid" = profile.Guid;

      home.file."Library/Application Support/iTerm2/DynamicProfiles/gruvbox.json".text = builtins.toJSON {
        Profiles = [ profile ];
      };
    };
}
