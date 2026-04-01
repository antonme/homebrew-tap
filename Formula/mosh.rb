class Mosh < Formula
  desc "Remote terminal application (fork with SSH agent forwarding + SGR dim/strikethrough)"
  homepage "https://github.com/antonme/mosh"
  license "GPL-3.0-or-later"
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
