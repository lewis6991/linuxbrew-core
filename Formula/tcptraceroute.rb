class Tcptraceroute < Formula
  desc "Traceroute implementation using TCP packets"
  homepage "https://github.com/mct/tcptraceroute"
  license "GPL-2.0"
  revision 2
  head "https://github.com/mct/tcptraceroute.git"

  stable do
    url "https://github.com/mct/tcptraceroute/archive/tcptraceroute-1.5beta7.tar.gz"
    sha256 "57fd2e444935bc5be8682c302994ba218a7c738c3a6cae00593a866cd85be8e7"

    # Call `pcap_lib_version()` rather than access `pcap_version` directly
    # upstream issue: https://github.com/mct/tcptraceroute/issues/5
    patch do
      url "https://github.com/mct/tcptraceroute/commit/3772409867b3c5591c50d69f0abacf780c3a555f.patch?full_index=1"
      sha256 "c08e013eb01375e5ebf891773648a0893ccba32932a667eed00a6cee2ccf182e"
    end
  end

  # This regex is open-ended because the newest version is a beta version and
  # we need to match these versions until there's a new stable release.
  livecheck do
    url :stable
    regex(/^(?:tcptraceroute[._-])?v?(\d+(?:\.\d+)+.*)/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "cc82e1da8c8ddfcaf62dbf23fdf0aa76817c8f8c57c822577d82282bb51dbcb3"
    sha256 cellar: :any,                 catalina:     "26e71f154250d933387eb00a17f93c7fe500c9d6bc69ddec10b7bfe7f39c38eb"
    sha256 cellar: :any,                 mojave:       "c688457fecc03c5e881448e3f2bc941bc352bb29488383889f71de3f719dee29"
    sha256 cellar: :any,                 high_sierra:  "e71cda023bb22dc514fda3d22af13bf8f0db80c1937add70b67cf7447d40a67f"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1dd38252b1c6431e4f4f819be0f7f2d85b2334ac387968e14a668442bbed42d6"
  end

  depends_on "libnet"

  uses_from_macos "libpcap"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libnet=#{HOMEBREW_PREFIX}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      tcptraceroute requires root privileges so you will need to run
      `sudo tcptraceroute`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = shell_output("#{bin}/tcptraceroute --help 2>&1", 1)
    assert_match "Usage: tcptraceroute", output
  end
end
