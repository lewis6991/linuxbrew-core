class Elixir < Formula
  desc "Functional metaprogramming aware language built on Erlang VM"
  homepage "https://elixir-lang.org/"
  url "https://github.com/elixir-lang/elixir/archive/v1.11.3.tar.gz"
  sha256 "d961305e893f4fe1a177fa00233762c34598bc62ff88b32dcee8af27e36f0564"
  license "Apache-2.0"
  head "https://github.com/elixir-lang/elixir.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc94bf65bccb57f6794c8bb081faa5914cc7184a6ecf71c8ce904cb91331445a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a06541e028cdd23af796aacb0c4217828a4066eb9239f414250937dd7d7775e8"
    sha256 cellar: :any_skip_relocation, catalina:      "e0ff8e34210c0c1bc477b225b2cf3edfcafa82d2a1dcf071d1da49a51758003a"
    sha256 cellar: :any_skip_relocation, mojave:        "dfcaa759c90179c486044fbf04e6300b2c7588e9d5169fa050fafe618415dec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2362281f906be2d85430916c64aba78fc85eaab33c5b72895a6fa71319636c91"
  end

  depends_on "erlang"

  def install
    system "make"
    bin.install Dir["bin/*"] - Dir["bin/*.{bat,ps1}"]

    Dir.glob("lib/*/ebin") do |path|
      app = File.basename(File.dirname(path))
      (lib/app).install path
    end

    system "make", "install_man", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/elixir", "-v"
  end
end
