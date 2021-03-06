class Croc < Formula
  desc "Securely send things from one computer to another"
  homepage "https://github.com/schollz/croc"
  url "https://github.com/schollz/croc/archive/v8.6.8.tar.gz"
  sha256 "71dc45ab9511bc2a8807562632a6393e264ac59c500d6a17e2e1b01269d4d8e3"
  license "MIT"
  head "https://github.com/schollz/croc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93513a6423e7bef7655a0e55e00abe466b38a3bf92d133126af47b4c971135c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "670cba99c12da0f15d4a9d5d79e87518d340008e5aded1e1377924a6b6a64ae4"
    sha256 cellar: :any_skip_relocation, catalina:      "8a0bd42725325468ffb1d4dd3d2d9217957b18e6e052f08ccc5412cff3ab29fd"
    sha256 cellar: :any_skip_relocation, mojave:        "5c08ae3e01edccb9c2c0910704813d7760208be1930b530ccd836d5f01968609"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ab9c516fa9132545b3be28150f69a6054505bba6a6f6c4c784bd3dded6b7d6c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    fork do
      exec bin/"croc", "send", "--code=homebrew-test", "--text=mytext"
    end
    sleep 1

    assert_match shell_output("#{bin}/croc --yes homebrew-test").chomp, "mytext"
  end
end
