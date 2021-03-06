class TerraformLs < Formula
  desc "Terraform Language Server"
  homepage "https://github.com/hashicorp/terraform-ls"
  url "https://github.com/hashicorp/terraform-ls/archive/v0.14.0.tar.gz"
  sha256 "f7e4ed1ecc1d2483775f4e681b770705b16b08ae79ba3a897bdb9ebc71380e3e"
  license "MPL-2.0"
  head "https://github.com/hashicorp/terraform-ls.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fca94d3e53e01c9f32dcccb85dbcae43e591a84f419b63bc6d3e96c2569cd70a"
    sha256 cellar: :any_skip_relocation, big_sur:       "e0acfbb46e4ef5ca987d7779d56b588d6f39818fe3afac016240d4c2c42f2575"
    sha256 cellar: :any_skip_relocation, catalina:      "bafabc2d4b3bff39742c7451c7990b07e1f1ee2cdc55d53f779b93e3e3f4777e"
    sha256 cellar: :any_skip_relocation, mojave:        "8fbc471fa5af6a6d440deb1d123aef9f840425ee248bfa2b8cd3f2ad997b6acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3d7b401696de4712da71c58aabe72a334ab28c26a47efcfbb781dc8b8f674f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    port = free_port

    pid = fork do
      exec "#{bin}/terraform-ls serve -port #{port} /dev/null"
    end
    sleep 2

    begin
      tcp_socket = TCPSocket.new("localhost", port)
      tcp_socket.puts <<~EOF
        Content-Length: 59

        {"jsonrpc":"2.0","method":"initialize","params":{},"id":1}
      EOF
      assert_match "Content-Type", tcp_socket.gets("\n")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
