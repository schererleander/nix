{ renderdoc }:
renderdoc.overrideAttrs (old: {
  # Stable RenderDoc builds bindings for Python 3.12, but does not install them.
  postInstall = (old.postInstall or "") + ''
    install -Dm755 lib/renderdoc.so $out/lib/renderdoc.so
  '';
})
