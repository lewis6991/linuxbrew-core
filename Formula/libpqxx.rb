class Libpqxx < Formula
  desc "C++ connector for PostgreSQL"
  homepage "http://pqxx.org/development/libpqxx/"
  url "https://github.com/jtv/libpqxx/archive/7.4.1.tar.gz"
  sha256 "73b2f0a0af786d6039291b60250bee577bc7ea7c10b7550ec37da448940848b7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "5d7d1131c04dc41a6277ab06f953e180fef6979be60d854e4fa02df7111e59f8"
    sha256 cellar: :any,                 big_sur:       "941aa261f18765bfed6888c94baaf7a0ad495ef8272229537a881e1ac8be5504"
    sha256 cellar: :any,                 catalina:      "f0304c955169cdec57747a49acb59556001944ddd83d6d53601aaa9806f25d4f"
    sha256 cellar: :any,                 mojave:        "e0fa3edf4874999fbf4062c9083c74d1517e974f1bb882b7f842a0d731cd5870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42b2ce5f64659e5382a6eb95b8fc18b5422efe2758e221c4aa8114add8bce50b"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "xmlto" => :build
  depends_on "libpq"
  depends_on "postgresql"

  unless OS.mac?
    depends_on "doxygen" => :build
    depends_on "xmlto" => :build
    depends_on "gcc@9"
    fails_with gcc: "5"
    fails_with gcc: "6"
    fails_with gcc: "7"
    fails_with gcc: "8"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    ENV["PG_CONFIG"] = Formula["libpq"].opt_bin/"pg_config"

    system "./configure", "--prefix=#{prefix}", "--enable-shared"
    system "make", "install"
  end

  test do
    cxx = OS.mac? ? ENV.cxx : Formula["gcc@9"].opt_bin/"g++-9"

    (testpath/"test.cpp").write <<~EOS
      #include <pqxx/pqxx>
      int main(int argc, char** argv) {
        pqxx::connection con;
        return 0;
      }
    EOS
    system cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lpqxx",
           "-I#{include}", "-o", "test"
    # Running ./test will fail because there is no running postgresql server
    # system "./test"
  end
end
