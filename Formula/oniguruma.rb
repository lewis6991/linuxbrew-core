class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.6/onig-6.9.6.tar.gz"
  sha256 "bd0faeb887f748193282848d01ec2dad8943b5dfcb8dc03ed52dcc963549e819"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:mark|rev)\d+)?)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dc2264a1fd09eb555ff2591d212af8e9cb5071ca529104dd17746af6306e79d0"
    sha256 cellar: :any, big_sur:       "505599ad17e21360a58a89db2133115b5aa109cdebd5d284bec2bc25cfee5062"
    sha256 cellar: :any, catalina:      "e40a40789488ed0f0a98e5aec3336bfa04f87b7983e139524fbbc1b192ea71ac"
    sha256 cellar: :any, mojave:        "98d43005ae967cba150b66abfe0c76163f7072ecb80eb573612284a706d6e5c1"
    sha256 cellar: :any, high_sierra:   "737284ca190ac20d86a070bccf720194342f617e60690781eefae867230a2f58"
    sha256 cellar: :any, x86_64_linux:  "436acb2dc16cb7fce1f8504dbda3a65e67bf0f379bc18326c2376d1ecdca3ad1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
