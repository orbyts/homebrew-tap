class Apogee < Formula
  desc "Cross-shell config emitter for Orbit (aliases, PATH, env) via a single eval."
  homepage "https://github.com/orbyts/apogee"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.1/apogee-aarch64-apple-darwin.tar.xz"
      sha256 "c906794d085fa3661f69b93d3f33a3ced988074e5927ce0cce5f8b2a9a881f1c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.1/apogee-x86_64-apple-darwin.tar.xz"
      sha256 "f09daa3a015e6cb6c15b143a3097917851f3bf052d49abf9e45b07bada6886d5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.1/apogee-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0d0c736f16cc0b9257a0c0aafaba93633fa53b3788e6ddd7317a650527f3ae9e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/orbyts/apogee/releases/download/v0.1.1/apogee-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ba3b86ba00d1852fa9ab9426eb36cc025f9c1aa2ef43ddbf0ab66c7b14db9427"
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
