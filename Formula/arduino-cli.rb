class ArduinoCli < Formula
  desc "Arduino command-line interface"
  homepage "https://github.com/arduino/arduino-cli"
  url "https://github.com/arduino/arduino-cli.git",
     tag:      "0.16.1",
     revision: "76f55490438e6c19226c9e2d9934f7d088152648"
  license "GPL-3.0-only"
  head "https://github.com/arduino/arduino-cli.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "bd5434ba150eb34f4d5d77dfa8430814d33ec9e7ade0c7d3a4ed0b13b56cbbe7"
    sha256 cellar: :any_skip_relocation, catalina:     "dacfe865d4c42047932f5ce48133839cd550b49375f0408e71541ccdbd897dee"
    sha256 cellar: :any_skip_relocation, mojave:       "2d01dc5a03005628970a21f65d73a325197be6d52392a93717d1e7caeea22790"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "08d966edb6fb6cd84081578655d039ee70e76c2e9dc490000ae7df0377d9efcf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/arduino/arduino-cli/version.versionString=#{version}
      -X github.com/arduino/arduino-cli/version.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")

    output = Utils.safe_popen_read({ "SHELL" => "bash" }, "#{bin}/arduino-cli", "completion", "bash")
    (bash_completion/"arduino-cli").write output

    output = Utils.safe_popen_read({ "SHELL" => "zsh" }, "#{bin}/arduino-cli", "completion", "zsh")
    (zsh_completion/"_arduino-cli").write output

    output = Utils.safe_popen_read({ "SHELL" => "fish" }, "#{bin}/arduino-cli", "completion", "fish")
    (fish_completion/"arduino-cli.fish").write output
  end

  test do
    system "#{bin}/arduino-cli", "sketch", "new", "test_sketch"
    assert File.directory?("#{testpath}/test_sketch")

    version_output = shell_output("#{bin}/arduino-cli version 2>&1")
    assert_match "arduino-cli alpha Version: #{version}", version_output
  end
end
