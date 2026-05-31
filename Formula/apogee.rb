class Apogee < Formula
  desc "Cross-shell config emitter for Orbit (aliases, PATH, env) via a single eval."
  homepage "https://github.com/orbyts/apogee"
  version "0.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.3/apogee-aarch64-apple-darwin.tar.xz"
      sha256 "1a4c0096f77ebf49d2425f7a3a90e3440739f82b34f28095d8b395790a7fd8cc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.3/apogee-x86_64-apple-darwin.tar.xz"
      sha256 "d1826093e177077038cb1c2ac04b591cb4e32bd99f59d6e295121772dda5a6a7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.3/apogee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "81c0d52ce5f88e96a06cb5eed72207837aad7eca6896cf726e21bf23eaddfaca"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.3/apogee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "82a64416866e7dccb201cb71ddaa1be0b1ae42b6b3157e25d7626ece8e5a5dc0"
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
