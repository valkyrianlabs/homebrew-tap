# Homebrew cask for the Vaulthalla macOS package (rendered per release by tools/macos/pkg/render-cask.sh into the
# valkyrianlabs/homebrew-tap repository as Casks/vaulthalla.rb). `brew install --cask valkyrianlabs/tap/vaulthalla`
# runs the same package as a manual install, so both paths provision identically.
cask "vaulthalla" do
  version "1.18.0"
  sha256 "634cb9fa93fdfa11ee922a76a144de08003866b5d60dd6728e15f497bc2233c2"

  url "https://github.com/valkyrianlabs/vaulthalla-server/releases/download/v#{version}/vaulthalla-#{version}-arm64.pkg"
  name "Vaulthalla"
  desc "Self-hosted encrypted cloud: server, web console and vh CLI"
  homepage "https://vaulthalla.sh/"

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
  EOS
end
