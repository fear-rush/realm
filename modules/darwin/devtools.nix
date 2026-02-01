{ pkgs, ... }:

{
  # Dev tools available system-wide for GUI apps (Claude Desktop, VSCode, etc.)
  environment.systemPackages = with pkgs; [
    nodejs_22
    python313
    bun
    uv
    nodePackages.pnpm
  ];
}
