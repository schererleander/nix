{
  flake.modules.homeManager.lsp =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        go
        gopls
        nil
        nixd
        nixfmt
        lua-language-server
        clang-tools
        texlab
        tinymist
        pyright
        rust-analyzer
        typescript-language-server
        tailwindcss-language-server
      ];
    };
}
