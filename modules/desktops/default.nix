[
  ./greetd.nix
]
++ (import ./wayland
  ++ import ./x11)
