class IamPolicyJsonToTerraform < Formula
  desc "Convert a JSON IAM Policy into terraform"
  homepage "https://github.com/flosell/iam-policy-json-to-terraform"
  url "https://github.com/flosell/iam-policy-json-to-terraform/archive/1.6.0.tar.gz"
  sha256 "714b8aead9bf5a88989a62eb520163565c890f37ee13783a3ae549bb0b8cdead"
  license "Apache-2.0"
  revision 1
  head "https://github.com/flosell/iam-policy-json-to-terraform.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d1114f74f71e918ec5aa63a06ceedc1d190757c6427a8711623b6e428abbdfc8"
    sha256 cellar: :any_skip_relocation, big_sur:       "e4316885451a287ef712e0838c680b55cc1267d04d77609f4f320b1728257ebf"
    sha256 cellar: :any_skip_relocation, catalina:      "86e9ee53bdcda8143b96d78acc61c55f759d098039e1304b38f92293f99d8878"
    sha256 cellar: :any_skip_relocation, mojave:        "cbb79fcd24013f6850f12bf1dc31ffaac3c47cba3386ee1f40dbcc55073a8170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36f02bf8dcc2aa8e849b57332d5e7405497c39b208801546d92ab1150a48e8ab"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-s -w"
  end

  test do
    # test version
    assert_match version.to_s, shell_output("#{bin}/iam-policy-json-to-terraform -version")

    # test functionality
    test_input = '{"Statement":[{"Effect":"Allow","Action":["ec2:Describe*"],"Resource":"*"}]}'
    output = shell_output("echo '#{test_input}' | #{bin}/iam-policy-json-to-terraform")
    assert_match "ec2:Describe*", output
  end
end
