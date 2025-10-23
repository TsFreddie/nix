{ ... }:

{
  services.ollama = {
    enable = true;
  };

  services.tabby = {
    enable = true;
    model = "Qwen2.5-Coder-3B";
  };
}
