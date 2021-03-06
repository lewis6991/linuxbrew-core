class Fsql < Formula
  desc "Search through your filesystem with SQL-esque queries"
  homepage "https://github.com/kashav/fsql"
  url "https://github.com/kashav/fsql/archive/v0.3.1.tar.gz"
  sha256 "b88110426a60aa2c48f7b4e52e117a899d43d1bba2614346b729234cd4bd9184"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9266f63cddbc0ca9c73655ecee949deae745e991ca31727a954958c81cfe4615"
    sha256 cellar: :any_skip_relocation, big_sur:       "fec9ae6f2720a408b0bf11aa6f83d7de2bbd99eb8054a8ede09809b0ca470cfb"
    sha256 cellar: :any_skip_relocation, catalina:      "de9764e9754827795839738de7d4377786b3532b7a2157806ecf3e145f626146"
    sha256 cellar: :any_skip_relocation, mojave:        "7cb63d8939e7af0391938aea8a138daccbaddce50b42802d32e510772e004b9a"
    sha256 cellar: :any_skip_relocation, high_sierra:   "7b4353a346425e4db5d14419c4dbacf6038606778a7ce2b98ddd0fdb7c2ca233"
    sha256 cellar: :any_skip_relocation, sierra:        "f651c7c2dad44ee6b6f32aa699df223bd427421990f2c2c170d0928b1a31ef87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "34c27b72ead6d99a86b1bb575f5b3c239a0c575ba36b8fa3f66e8eaaa4efa444"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kshvmdn/fsql").install buildpath.children
    system "go", "build", "-o", bin/"fsql", "github.com/kshvmdn/fsql/cmd/fsql"
  end

  test do
    (testpath/"bar.txt").write("hello")
    (testpath/"foo/baz.txt").write("world")
    cmd = "#{bin}/fsql SELECT FULLPATH\\(name\\) FROM foo"
    assert_match %r{^foo\s+foo/baz.txt$}, shell_output(cmd)
    cmd = "#{bin}/fsql SELECT name FROM . WHERE name = bar.txt"
    assert_equal "bar.txt", shell_output(cmd).chomp
    cmd = "#{bin}/fsql SELECT name FROM . WHERE FORMAT\\(size\, GB\\) \\> 500"
    assert_equal "", shell_output(cmd)
  end
end
