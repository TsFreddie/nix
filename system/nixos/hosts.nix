{ ... }:

{
  networking.hosts = {
    "127.0.0.1" = [
      "localhost.local"
      "sub.localhost:local"
    ];
  };
}
