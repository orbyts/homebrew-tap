class Apogee < Formula
  desc "Cross-shell config emitter for Orbit (aliases, PATH, env) via a single eval."
  homepage "https://github.com/orbyts/apogee"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.2/apogee-aarch64-apple-darwin.tar.xz"
      sha256 "1478d8dafdb32e44871b80ee086c1d5f9be547eb5bdf0f23ea620174ce22c911"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.2/apogee-x86_64-apple-darwin.tar.xz"
      sha256 "4a1bb8f31b271f4745eafee83177bd0ce8fc048c85bf71969dc4d215b92563d8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.2/apogee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a699f20140bfc01bd222013e5c9c30cae03a212d9da0a00da38db22f987387a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.2/apogee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0ff764d4844b57924c5ac952cf07553c21fde9faa97dcf8910069d27c30fb2b4"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "apogee" if OS.mac? && Hardware::CPU.arm?
    bin.install "apogee" if OS.mac? && Hardware::CPU.intel?
    bin.install "apogee" if OS.linux? && Hardware::CPU.arm?
    bin.install "apogee" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
