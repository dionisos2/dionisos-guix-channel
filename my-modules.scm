(define-module (my-modules))

(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
						 ((guix licenses) #:prefix license:)
						 (guix build-system python)
						 (gnu packages python)
						 (gnu packages python-build)
						 (gnu packages python-crypto)
						 (gnu packages python-xyz)
						 (guix build-system pyproject)
						 (gnu packages libffi)
						 (gnu packages glib)
						 (gnu packages check)
						 (gnu packages python-check)
						 (gnu packages sphinx)
						 (gnu packages bioinformatics)
						 (gnu packages xorg)
						 )

(define-public my-python-xcffib
  (package
    (name "my-python-xcffib")
    (version "0.11.1")
    (source
     (origin
      (method url-fetch)
      (uri (pypi-uri "xcffib" version))
      (sha256
       (base32
        "0nkglsm9nbhv238iagmmsjcz6lf1yfdvp5kmspphdj385vz9r50j"))))
    (build-system python-build-system)
    (inputs
     (list libxcb))
    (propagated-inputs
     (list python-cffi ; used at run time
           python-six))
    (arguments
     `(;; FIXME: Tests need more work. See ".travis.yml" in the repository.
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-libxcb-path
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((libxcb (assoc-ref inputs "libxcb")))
               (substitute* '("xcffib/__init__.py")
                 (("soname = ctypes.util.find_library.*xcb.*")
                  (string-append "soname = \"" libxcb "/lib/libxcb.so\"\n")))
               #t)))
         (add-after 'install 'install-doc
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((doc (string-append (assoc-ref outputs "out") "/share"
                                       "/doc/" ,name "-" ,version)))
               (mkdir-p doc)
               (copy-file "README.md"
                          (string-append doc "/README.md"))
               #t))))))
    (home-page "https://github.com/tych0/xcffib")
    (synopsis "XCB Python bindings")
    (description
     "Xcffib is a replacement for xpyb, an XCB Python bindings.  It adds
support for Python 3 and PyPy.  It is based on cffi.")
    (license license:expat)))
