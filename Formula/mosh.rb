class Mosh < Formula
  desc "Remote terminal application (fork with OSC 10/11 color queries, hyperlinks, SGR dim/strikethrough)"
  homepage "https://github.com/antonme/mosh"
  url "https://github.com/antonme/mosh/archive/refs/tags/fork7.tar.gz"
  sha256 "377e4050365274010a52848af82f0380c1959a6d47ae99c42dc564e4ae3fabb3"
  version "1.4.0-fork7"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/antonme/homebrew-tap/releases/download/bottles"
    rebuild 1
    sha256 cellar: :any, arm64_tahoe: "78e8617bb64c9526cfeadbbbd92c8561ecff14f7ed34e2fb6c598e7f999b1043"
  end

  head "https://github.com/antonme/mosh.git", branch: "osc10-11-query-support"

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
