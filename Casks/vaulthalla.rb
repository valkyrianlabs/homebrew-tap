# Homebrew meta cask: Vaulthalla on this Mac, the server and the Desktop app (rendered per release by
# tools/macos/pkg/render-cask.sh into the valkyrianlabs/homebrew-tap repository as Casks/vaulthalla.rb). It installs
# nothing itself: it depends on the vaulthalla-server and vaulthalla-desktop casks, so each installs and upgrades to its
# own latest release and neither release carries the other. A cask must download something, so this one fetches the
# server package's .sha256 (a few bytes) and only stages it.
#
# Homebrew loads a dependency cask only from a trusted tap: run `brew trust valkyrianlabs/tap` once first.
cask "vaulthalla" do
  version "1.20.2"
  sha256 "2e16288f3728bc1b19eb2b9706bac0da3c9c2d44af36cedd673aaab4af6c1b91"

  url "https://github.com/valkyrianlabs/vaulthalla-server/releases/download/v#{version}/vaulthalla-#{version}-arm64.pkg.sha256"
  name "Vaulthalla"
  desc "Self-hosted encrypted cloud with the Desktop app, web console and vh CLI"
  homepage "https://vaulthalla.io/"

  depends_on cask: [
    "valkyrianlabs/tap/vaulthalla-server",
    "valkyrianlabs/tap/vaulthalla-desktop",
  ]

  stage_only true

  caveats <<~EOS
    Vaulthalla is installed as two casks, which upgrade on their own:
      valkyrianlabs/tap/vaulthalla-server   the service, web console and vh CLI (`brew upgrade`)
      valkyrianlabs/tap/vaulthalla-desktop  the app (updates itself)
    Uninstalling this cask leaves both; uninstall them by name.
  EOS
end
