require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.21.0.tgz"
  sha256 "193c8788bfe2ce79fe55c7d4b0af7e7192517a7e8049df2cf2b88fd4848a9226"
  license "MIT"
  head "https://github.com/webpack/webpack.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1fc3c17089233d76928e6ab58e471b5f6920a60b74b7e3a57080415f3872d7c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "bfff589bd30fcd91dbdcf467ca316709325497dbecd10924a6aed36e4fe4b6cf"
    sha256 cellar: :any_skip_relocation, catalina:      "7a4815b1fc0c0b8721b3bc9b9f5a9a48ca8ddde59729deb8994b95b471edb3b9"
    sha256 cellar: :any_skip_relocation, mojave:        "a30ceb2bb4c954cb95a1f6eb7a2b6c4504bb35e07cbf7c20a5cea231b97ded28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b81ba49647fe8b708464c8767191220bf6fabe00368b759cd07708c2e1bea3f"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-4.5.0.tgz"
    sha256 "6db23ada5a0ef82f6fd8f7c4b247589af6b6eaec36ef5e54f39660923a001679"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production", "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(IO.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    IO.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document\.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end
