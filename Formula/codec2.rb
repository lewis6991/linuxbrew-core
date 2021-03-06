class Codec2 < Formula
  desc "Open source speech codec"
  homepage "https://www.rowetel.com/?page_id=452"
  # Linked from https://freedv.org/
  url "https://github.com/drowe67/codec2/archive/v0.9.2.tar.gz"
  sha256 "19181a446f4df3e6d616b50cabdac4485abb9cd3242cf312a0785f892ed4c76c"
  license "LGPL-2.1"

  bottle do
    sha256 cellar: :any, big_sur:      "c28da7a7d230e8505859eafa28d9238ccadd97c4847f5ee5c269ffa24245ba49"
    sha256 cellar: :any, catalina:     "d41040646585e5b91438818ff4dfdccc94b3a2567d31d6960710f8f2455bab04"
    sha256 cellar: :any, mojave:       "460c2febeb64e913796ee3f161b8fa50bbc00904c99228d5122324ebadd91fe9"
    sha256 cellar: :any, high_sierra:  "5f4530a54adbc38253b993bdbb21da86b4d11725b2edcbec79e43ed739875208"
    sha256 cellar: :any, x86_64_linux: "1abf3196c1426021346c7d023af9ea7c1540e20f25977080ee22f5e78e47909f"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build_osx" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # 8 bytes of raw audio data (silence).
    (testpath/"test.raw").write([0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00].pack("C*"))
    system "#{bin}/c2enc", "2400", "test.raw", "test.c2"
  end
end
