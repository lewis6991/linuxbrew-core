class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/release-qpdf-10.2.0/qpdf-10.2.0.tar.gz"
  sha256 "43ef260f4e70672660e1882856d59b9319301c6f170673ab465430a71cffe44c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "0f78ce71f607721920f1d556ce92e36ff35677cdf0191e672f33b8961a846027"
    sha256 cellar: :any,                 big_sur:       "22dfc12bbcb9eb5ae529e9765e555b4f0320712f315cce6d00d607d7399ae98e"
    sha256 cellar: :any,                 catalina:      "0782c454782100fbbcc34686d8d1d09506b5ab9ed6188a09ecea4fe9dfa93b00"
    sha256 cellar: :any,                 mojave:        "ee3f9c7170c36b9d3429904f07e873e3f9939b054ba7a8af69a6a9b54814cd2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94bd1ff6ab0d0be84fd35b6dd67fb064fb76fe8b20d4a597b9925621c5c8cf8f"
  end

  depends_on "jpeg"

  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
