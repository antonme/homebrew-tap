class Mosh < Formula
  desc "Remote terminal application (fork with OSC 10/11 color queries, hyperlinks, SGR dim/strikethrough)"
  homepage "https://github.com/antonme/mosh"
  url "https://github.com/antonme/mosh/archive/refs/tags/fork8-osc11.tar.gz"
  sha256 "e198af5451ecf14137397a29d8a1f65f0500337f499bfbba1cc1b486257ef43d"
  version "1.4.0-fork8"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/antonme/homebrew-tap/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "16c3fd60ee2ff63f9286cb3e790487fdbc35b97769645875fbcfe3b385b54ffa"
  end

  head "https://github.com/antonme/mosh.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"

  on_macos do
    depends_on "tmux" => :build
  end

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  conflicts_with "mosh", because: "both install `mosh` binary"

  def install
    ENV.append_to_cflags "-DNDEBUG"
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"
    inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
