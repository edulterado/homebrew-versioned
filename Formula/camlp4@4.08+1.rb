class Camlp4AT408x1 < Formula
  desc "Tool to write extensible parsers in OCaml"
  homepage "https://github.com/ocaml/camlp4"
  url "https://github.com/ocaml/camlp4/archive/4.08+1.tar.gz"
  version "4.08+1"
  sha256 "655cd3bdcafbf8435877f60f4b47dd2eb69feef5afd8881291ef01ba12bd9d88"
  head "https://github.com/ocaml/camlp4.git", :branch => "trunk"

  depends_on "ocaml"
  # since OCaml 4.03.0, ocamlbuild is no longer part of ocaml
  depends_on "ocamlbuild"

  def install
    # this build fails if jobs are parallelized
    ENV.deparallelize
    system "./configure", "--bindir=#{bin}",
                          "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                          "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
    system "make", "all"
    system "make", "install", "LIBDIR=#{lib}/ocaml",
                              "PKGDIR=#{lib}/lib/ocaml/camlp4"
  end

  test do
    (testpath/"foo.ml").write "type t = Homebrew | Rocks"
    system "#{bin}/camlp4", "-parser", "OCaml", "-printer", "OCamlr",
                            "foo.ml", "-o", testpath/"foo.ml.out"
    assert_equal "type t = [ Homebrew | Rocks ];",
                 (testpath/"foo.ml.out").read.strip

    (testpath/"try_camlp4.ml").write "open Camlp4"
    system "ocamlc", "-c", "-I", "#{HOMEBREW_PREFIX}/lib/ocaml/camlp4", "-o", testpath/"try_camlp4.cmo", testpath/"try_camlp4.ml"
  end
end
