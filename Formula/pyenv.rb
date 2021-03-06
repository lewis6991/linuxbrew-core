class Pyenv < Formula
  desc "Python version management"
  homepage "https://github.com/pyenv/pyenv"
  url "https://github.com/pyenv/pyenv/archive/v1.2.23.tar.gz"
  sha256 "805058aa5ce257157fb4769543e6a43bac45a88c723ff3c4fcf5b4f759056bf5"
  license "MIT"
  version_scheme 1
  head "https://github.com/pyenv/pyenv.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5d6f1dbfd29aa76435b3a5aeb69289472ba6bc54bc3ac2e6659a11bab3b7d441"
    sha256 cellar: :any,                 big_sur:       "bc22faf3875668a018ad240d1752f9523fd138972c113eae115940296d715cfd"
    sha256 cellar: :any,                 catalina:      "55e898fae5d4802e00b2523363f60da2490a09b98e533e17b8e6f4a8b2ff3f00"
    sha256 cellar: :any,                 mojave:        "cf8bb5e03596da23b2fa516d81e60afe8159003ef65957fc5bac17f2de1f0b44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f85645fda47bb6a41312f9e5a75f0e07fa1ffedee9c32fc370adfeb65255ea92"
  end

  depends_on "autoconf"
  depends_on "openssl@1.1"
  depends_on "pkg-config"
  depends_on "readline"
  depends_on "python@3.9" unless OS.mac?

  uses_from_macos "bzip2"
  uses_from_macos "libffi"
  uses_from_macos "ncurses"
  uses_from_macos "xz"
  uses_from_macos "zlib"

  def install
    inreplace "libexec/pyenv", "/usr/local", HOMEBREW_PREFIX
    inreplace "libexec/pyenv-versions", "system pyenv-which python", "system pyenv-which python3"

    system "src/configure"
    system "make", "-C", "src"

    prefix.install Dir["*"]
    %w[pyenv-install pyenv-uninstall python-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/python-build/bin/#{cmd}"
    end

    # Do not manually install shell completions. See:
    #   - https://github.com/pyenv/pyenv/issues/1056#issuecomment-356818337
    #   - https://github.com/Homebrew/homebrew-core/pull/22727
  end

  test do
    shell_output("eval \"$(#{bin}/pyenv init -)\" && pyenv versions")
  end
end
