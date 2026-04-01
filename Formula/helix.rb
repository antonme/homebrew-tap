class Helix < Formula
  desc "Post-modern modal text editor (fork with persistent undo)"
  homepage "https://github.com/antonme/helix"
  license "MPL-2.0"
  head "https://github.com/antonme/helix.git", branch: "master"

  depends_on "rust" => :build

  conflicts_with "helix", because: "both install `hx` binary"
  conflicts_with "evil-helix", because: "both install `hx` binary"
  conflicts_with "hex", because: "both install `hx` binary"

  def install
    ENV["HELIX_DEFAULT_RUNTIME"] = libexec/"runtime"
    system "cargo", "install", "-vv", *std_cargo_args(path: "helix-term")
    rm_r "runtime/grammars/sources/"
    libexec.install "runtime"

    bash_completion.install "contrib/completion/hx.bash" => "hx"
    fish_completion.install "contrib/completion/hx.fish"
    zsh_completion.install "contrib/completion/hx.zsh" => "_hx"
  end

  test do
    assert_match "post-modern text editor", shell_output("#{bin}/hx --help")
    assert_match "✓", shell_output("#{bin}/hx --health")
  end
end
