# frozen_string_literal: true

# Formula template. `vlr homebrew formula` renders the release url/sha256 into
# release/homebrew/vl-release.rb, which `vlr homebrew publish` commits to valkyrianlabs/homebrew-tap.
class VlRelease < Formula
  include Language::Python::Shebang

  desc "Deterministic release toolkit for Valkyrian Labs projects"
  homepage "https://github.com/valkyrianlabs/vl-release"
  url "https://github.com/valkyrianlabs/vl-release/releases/download/v0.6.0/vl-release-0.6.0.tar.gz"
  sha256 "92388dfc0e16e5978c333fcdc8e074187ff06b764ba972f82048aadccfec3e18"
  license "MIT"
  head "https://github.com/valkyrianlabs/vl-release.git", branch: "main"

  depends_on "python@3.14"

  def install
    libexec.install "vlrelease", "bin"
    rewrite_shebang detected_python_shebang, libexec/"bin/vl-release"
    bin.install_symlink libexec/"bin/vl-release"
    bin.install_symlink libexec/"bin/vl-release" => "vlr"
    doc.install "README.md", "RELEASE_NOTES.md"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vl-release --version")
    assert_match version.to_s, shell_output("#{bin}/vlr --version")
    assert_match "status: ok", shell_output("#{bin}/vlr doctor")
  end
end
