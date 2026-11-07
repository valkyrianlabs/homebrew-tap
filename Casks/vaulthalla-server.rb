# Homebrew cask for the Vaulthalla server (rendered per release by tools/macos/pkg/render-cask.sh into the
# valkyrianlabs/homebrew-tap repository as Casks/vaulthalla-server.rb). `brew install --cask
# valkyrianlabs/tap/vaulthalla-server` runs the same package as `sudo installer -pkg`, so both paths provision
# identically. The `vaulthalla` meta cask depends on it.
cask "vaulthalla-server" do
  version "1.22.2"
  sha256 "17d81d809bf74b762636e9684d35b309e0d03faae3f508723c4ddad68ea54250"

  url "https://github.com/valkyrianlabs/vaulthalla-server/releases/download/v#{version}/vaulthalla-#{version}-arm64.pkg"
  name "Vaulthalla Server"
  desc "Self-hosted encrypted cloud: server, web console and vh CLI"
  homepage "https://vaulthalla.io/"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  pkg "vaulthalla-#{version}-arm64.pkg"

  # Keeps vault data, the database and the _vaulthalla account; `brew uninstall --zap` deletes them too.
  uninstall script:  {
              executable: "/Library/Application Support/Vaulthalla/uninstall.sh",
              sudo:       true,
            },
            pkgutil: "sh.vaulthalla.server"

  zap script: {
    executable: "/Library/Application Support/Vaulthalla/uninstall.sh",
    args:       ["--purge"],
    sudo:       true,
  }

  caveats <<~EOS
    Vaulthalla runs as a system service (LaunchDaemons sh.vaulthalla.*) and starts at boot.
    Web console: http://127.0.0.1:36968 (user 'admin'; first password:
      sudo cat "/Library/Application Support/Vaulthalla/state/super_admin_initial_password")
    Vaulthalla Desktop: brew install --cask valkyrianlabs/tap/vaulthalla-desktop
  EOS
end
