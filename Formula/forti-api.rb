# frozen_string_literal: true

# Formula template. `vlr homebrew formula` renders the release url/sha256 into
# release/homebrew/forti-api.rb, which `vlr homebrew publish` commits to valkyrianlabs/homebrew-tap.
class FortiApi < Formula
  desc "Header-only C++23 client for the FortiGate REST API (FortiOS v2)"
  homepage "https://github.com/valkyrianlabs/forti-api"
  url "https://github.com/valkyrianlabs/forti-api/releases/download/v1.1.1/forti-api-1.1.1.tar.gz"
  sha256 "3182d732e52aa66d947b93e8f6372243818d815f1bad9f78cadde95f878f5450"
  license "MIT"
  head "https://github.com/valkyrianlabs/forti-api.git", branch: "main"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  uses_from_macos "curl"

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <forti_api.hpp>
      #include <iostream>

      int main() {
          fortiapi::firewall::Policy policy;
          policy.name = "example";
          policy.action = std::string(fortiapi::firewall::Policy::Action::deny);
          std::cout << fortiapi::to_json(policy, fortiapi::Write::create).dump() << std::endl;
      }
    CPP
    ENV.prepend_path "PKG_CONFIG_PATH", share/"pkgconfig"
    flags = shell_output("pkgconf --cflags --libs forti-api").chomp.split
    system ENV.cxx, "-std=c++23", "test.cpp", "-o", "test", *flags
    assert_equal '{"action":"deny","name":"example"}', shell_output("./test").chomp
  end
end
