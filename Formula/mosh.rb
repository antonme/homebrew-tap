class Mosh < Formula
  desc "Remote terminal application (fork with OSC 10/11 color queries, hyperlinks, SGR dim/strikethrough)"
  homepage "https://github.com/antonme/mosh"
  url "https://github.com/antonme/mosh/archive/refs/tags/fork7.tar.gz"
  sha256 "631807cc81c1ac6a31aba41d4cc5df6a35c1417fe95a43ea1bd8c20d1c26cc1e"
  version "1.4.0-fork7"
  license "GPL-3.0-or-later"

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
