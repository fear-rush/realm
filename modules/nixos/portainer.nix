{ config, pkgs, ... }:

{
  # Enable Docker
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Portainer - Docker management UI
  virtualisation.oci-containers = {
    backend = "docker";

    containers = {
      portainer = {
        image = "portainer/portainer-ce:latest";

        ports = [
          "9000:9000"
          "9443:9443"
        ];

        volumes = [
          "/var/run/docker.sock:/var/run/docker.sock"
          "portainer_data:/data"
        ];

        environment = {
          TZ = "Asia/Jakarta";
        };

        extraOptions = [
          "--name=portainer"
          "--restart=unless-stopped"
        ];

        autoStart = true;
      };
    };
  };
}
