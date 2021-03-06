require "language/go"

class DockerGen < Formula
  desc "Generate files from docker container metadata"
  homepage "https://github.com/jwilder/docker-gen"
  url "https://github.com/jwilder/docker-gen/archive/0.7.4.tar.gz"
  sha256 "7951b63684e4ace9eab4f87f0c5625648f8add2559fa7779fabdb141a8a83908"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "719613c9b090bdddc48ffebe3ca13347fcaf8ccdadbcddee6bbec4367dbc7795"
    sha256 cellar: :any_skip_relocation, big_sur:       "77385699141202354e27dbfbe1d57c936e4eec4beb1c5f7537f29db4cfc57602"
    sha256 cellar: :any_skip_relocation, catalina:      "d5305ec74f29526e6e7b01632dda0e48b0af397d9a65baf233db4da48f96ee8a"
    sha256 cellar: :any_skip_relocation, mojave:        "00f1f34756eadc57f39945a00bc4e8c9e8ff2beefafbb58052667c2611e29e0f"
    sha256 cellar: :any_skip_relocation, high_sierra:   "42d2757b01271ef6c14de5441b3c65507538388db1e00e69f322272a5ba5b59c"
    sha256 cellar: :any_skip_relocation, sierra:        "222a5586670fec7643e9e7651f0b1fa82ff012048bd29b959ac720743f1a1a4f"
    sha256 cellar: :any_skip_relocation, el_capitan:    "c274701a545e5a4885995718f5f01ca6df2f9c6b9a143d4ffcf46b1771ac4cbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c5b758ab172bccc2ff8c911334e91ba4fcd0fe1eb53eae51cdf19e7cf8908eb"
  end

  depends_on "go" => :build

  go_resource "github.com/agtorre/gocolorize" do
    url "https://github.com/agtorre/gocolorize.git",
        revision: "99fea4bc9517f07eea8194702cb7076f4845b7de"
  end

  go_resource "github.com/robfig/glock" do
    url "https://github.com/robfig/glock.git",
        revision: "428181ba14e0e3722090fe6e63402643a099e8bd"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
        revision: "fbec762f837dc349b73d1eaa820552e2ad177942"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/jwilder/docker-gen").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/robfig/glock" do
      system "go", "install"
    end

    cd "src/github.com/jwilder/docker-gen" do
      system buildpath/"bin/glock", "sync", "github.com/jwilder/docker-gen"
      system "go", "build", "-ldflags", "-X main.buildVersion=#{version}", "-o",
             bin/"docker-gen", "./cmd/docker-gen"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/docker-gen --version")
  end
end
