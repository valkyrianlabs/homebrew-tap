# frozen_string_literal: true

# Formula template. `vlr homebrew formula` renders the release url/sha256 into
# release/homebrew/vl-release.rb, which `vlr homebrew publish` commits to valkyrianlabs/homebrew-tap.
class VlRelease < Formula
  include Language::Python::Shebang

  desc "Deterministic release toolkit for Valkyrian Labs projects"
  homepage "https://github.com/valkyrianlabs/vl-release"
  url "https://github.com/valkyrianlabs/vl-release/releases/download/v0.1.1/vl-release-0.1.1.tar.gz"
  sha256 "ccbff161e652003f3ef37ee27eb52ebe3f2bd7646e5736fbf5f2740c8ac9e112"
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
