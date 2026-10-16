# frozen_string_literal: true

# Formula template. `vlr homebrew formula` renders the release url/sha256 into
# release/homebrew/forti-cli.rb, which `vlr homebrew publish` commits to valkyrianlabs/homebrew-tap.
class FortiCli < Formula
  desc "FortiOS command-line interface: discover, read, plan and apply FortiGate config"
  homepage "https://github.com/valkyrianlabs/forti-cli"
  url "https://github.com/valkyrianlabs/forti-cli/releases/download/v0.4.2/forti-cli-0.4.2.tar.gz"
  sha256 "8876a540bd22cbf0a3b5d02d264425fff4509c1e71a1c0f6f6d4420b1ca89417"
  license "MIT"
  head "https://github.com/valkyrianlabs/forti-cli.git", branch: "main"

  bottle do
    root_url "https://github.com/valkyrianlabs/forti-cli/releases/download/v0.4.2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b5edd7bc86420b1cf9462966ee2f318227095fe40d4d0405425ea2fb7eaa32fe"
    sha256 cellar: :any_skip_relocation, sequoia: "efb26ea3d2f25d934cac18700d7c4b0df36be35fc9ba283f935a819cb0ae2e8b"
  end

  # Header-only SDK: needed to compile, not at run time.
  depends_on "forti-api" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  # The MCP server for AI clients (forti mcp install): installed alongside, still its own formula.
  depends_on "valkyrianlabs/tap/forti-mcp"

  uses_from_macos "curl"

  def install
    # std_meson_args sets --buildtype=release and --wrap-mode=nofallback (stricter than nodownload):
    # forti-api always comes from the forti-api formula, never from subprojects/forti-api.wrap.
    # optimization=3 is meson.build's release profile, repeated so it holds whatever the build type;
    # strip=true installs the binary without its symbol table (24 MB -> 12 MB).
    # The tests need GoogleTest and run in CI; the `test do` block exercises the installed binary.
    system "meson", "setup", "build", "-Dtests=disabled", "-Doptimization=3", "-Dstrip=true", *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "forti #{version}", shell_output("#{bin}/forti --version")

    # Offline: the resource catalog is compiled in, so no profile or device is needed.
    ENV["FORTI_HOME"] = (testpath/"forti").to_s
    output = JSON.parse(shell_output("#{bin}/forti --json discover firewall/address"))
    assert output["ok"]
    assert_includes output["data"]["fields"].map { |field| field["name"] }, "subnet"

    # Shell completion: meson installs it under share/, which Homebrew links into its prefix (bash
    # through bash-completion@2, zsh through site-functions, fish through vendor_completions.d).
    assert_path_exists share/"bash-completion/completions/forti"
    assert_path_exists zsh_completion/"_forti"
    assert_path_exists fish_completion/"forti.fish"
    assert_equal "get\n", shell_output("#{bin}/forti __complete commands ge")
  end
end
