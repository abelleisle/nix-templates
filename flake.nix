{
  description = "A collection of flake templates";

  outputs = { self }:
  {
    defaultTemplate = self.templates.trivial;

    templates = {

      trivial = {
        path = ./trivial;
        description = "A very basic flake";
      };

      linux-cross-arm = {
        path = ./linux-cross-arm;
        description = "Linux kernel cross compilation for arm";
      };

    };
  };
}
