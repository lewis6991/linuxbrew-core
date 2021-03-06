class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.5.0.tar.bz2"
  sha256 "ae4af129216b2d7fdea0b5bf2a788cd458a79c983bb09a43f4d525cc87aba0ba"
  license any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libksba/"
    regex(/href=.*?libksba[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "077fb787593058667da21e25d5beca46ced441193c325c936036d466ad60cd6e"
    sha256 cellar: :any, big_sur:       "688def210a738526e8cebfe8e556c9bfe4b164887c5918463c37d91b3f694945"
    sha256 cellar: :any, catalina:      "9a305a28ce4d1635c142ea8e02ce5e6ef17007901223fbdbe3572f06398490f3"
    sha256 cellar: :any, mojave:        "a309359bb9d744de1065e91feefdd06f520a6e72a8d266bc256d59fbe23b70d5"
    sha256 cellar: :any, x86_64_linux:  "6c186e16a1ab8ff7f1da649a8625087722e689e811e397138a8d5aba4a968071"
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"ksba-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
