class K6 < Formula
  desc "Modern load testing tool, using Go and JavaScript"
  homepage "https://k6.io"
  url "https://github.com/loadimpact/k6/archive/v0.30.0.tar.gz"
  sha256 "5074b8b7e1a9ca7b96a55512737ad2cac8d92de22964973724c5f5424f98e177"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9188e1dc69294c2f6066e9d81ec3f211fa6388645c1daab9e5a5ff57dc9912e6"
    sha256 cellar: :any_skip_relocation, big_sur:       "2137c88a32ac557df0d8738c18d010772ebde7467bcdc97c55c71cf7b6696b79"
    sha256 cellar: :any_skip_relocation, catalina:      "9417f296cc2f5a7e360f466577ab4a001dc0b8ed5ea99fb998280eeae39a13a1"
    sha256 cellar: :any_skip_relocation, mojave:        "ada361abbd7089c348837364177526524198ccb569468cadb9b01b95ac20a9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc6f42590ddc461ee1d061353f840e8a6d314e1932af465e16eaa8b64f56b555"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"whatever.js").write <<~EOS
      export default function() {
        console.log("whatever");
      }
    EOS

    assert_match "whatever", shell_output("#{bin}/k6 run whatever.js 2>&1")
    assert_match version.to_s, shell_output("#{bin}/k6 version")
  end
end
