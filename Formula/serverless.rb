require "language/node"

class Serverless < Formula
  desc "Build applications with serverless architectures"
  homepage "https://www.serverless.com/"
  url "https://github.com/serverless/serverless/archive/v2.28.0.tar.gz"
  sha256 "eff86a56a0482fdf9ffe36ecb6285b856a9d70dc82fb631474784a5ff70ec1ba"
  license "MIT"

  bottle do
    sha256 arm64_big_sur: "848dc157f7ac984e627a095ffdd839d15c9654fe00e4636d270259b241c0b4ba"
    sha256 big_sur:       "694bf18403238674b971bf793a6787bd2e365dab0a563a5f61c5797a9d533180"
    sha256 catalina:      "7ef25bcb45708c317b22e49b47d16de189f552a16393f459dcb763dc187138e6"
    sha256 mojave:        "180a7ca9874b4cf94698fcfb99d2f8997fbad9e1c345319cb22039689a6ed6cd"
  end

  depends_on "node"

  on_linux do
    depends_on "python@3.9"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"serverless.yml").write <<~EOS
      service: homebrew-test
      provider:
        name: aws
        runtime: python3.6
        stage: dev
        region: eu-west-1
    EOS

    system("#{bin}/serverless", "config", "credentials", "--provider", "aws", "--key", "aa", "--secret", "xx")
    output = shell_output("#{bin}/serverless package")
    assert_match "Serverless: Packaging service...", output
  end
end
