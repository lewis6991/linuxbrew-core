class HasuraCli < Formula
  desc "Command-Line Interface for Hasura GraphQL Engine"
  homepage "https://hasura.io"
  url "https://github.com/hasura/graphql-engine/archive/v1.3.3.tar.gz"
  sha256 "2171bd0611719ed2340c783fdb2ac8f98cfafb608ec7898074627ece90f7ad5c"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9920a8bb5b2fe42ab0318159dd67cb05bda89e8dafbf2c236a787a2013c39c2e"
    sha256 cellar: :any_skip_relocation, big_sur:       "617e6833be87ef7d9de055869821906b1bcabc22d016afa918aab43989588839"
    sha256 cellar: :any_skip_relocation, catalina:      "c54ef70ad3df633efd37239dee92a1e36cfe73ea506b01df9c9045202e44f2fd"
    sha256 cellar: :any_skip_relocation, mojave:        "9c911ea10f8ac6e3379746801a71705b1527f65189f3b9728ef3397c0d91fab0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a8d389c2dc9af1eb0e0cde6657678e3b225a477cf39757498cc16800d715cf1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hasura/graphql-engine/cli/version.BuildVersion=#{version}
      -X github.com/hasura/graphql-engine/cli/plugins.IndexBranchRef=master
    ]

    cd "cli" do
      system "go", "build", *std_go_args, "-ldflags", ldflags.join(" "), "-o", bin/"hasura", "./cmd/hasura/"

      system bin/"hasura", "completion", "bash", "--file", "completion_bash"
      bash_completion.install "completion_bash" => "hasura"

      system bin/"hasura", "completion", "zsh", "--file", "completion_zsh"
      zsh_completion.install "completion_zsh" => "_hasura"
    end
  end

  test do
    system bin/"hasura", "init", "testdir"
    assert_predicate testpath/"testdir/config.yaml", :exist?
  end
end
