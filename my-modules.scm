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
						 (gnu packages gtk)
						 (gnu packages pulseaudio)
						 (gnu packages time)
						 (gnu packages mpd)
						 (gnu packages freedesktop)
						 (gnu packages pkg-config)
						 )

(define-public my-python-xcffib
  (package
    (name "my-python-xcffib")
    (version "1.5.0")
    (source
     (origin
      (method url-fetch)
      (uri (pypi-uri "xcffib" version))
      (sha256
       (base32
        "1k0sd7dpfdp5pxbzsq5p3kvjv8q7hkhd2sv0vv74yyzry9jr8p59"))))
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


(define-public my-qtile
  (package
    (name "my-qtile")
    (version "0.26.0")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "qtile" version))
        (sha256
          (base32 "1d86b1znm1ndzrnpd3g2b19dqgsyp4js8gydw3hqqypnvfa6z01c"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; Tests require Xvfb and writable temp/cache space
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'patch-paths
           (lambda* (#:key inputs #:allow-other-keys)
             (substitute* "libqtile/pangocffi.py"
               (("^gobject = ffi.dlopen.*")
                 (string-append "gobject = ffi.dlopen(\""
                  (assoc-ref inputs "glib") "/lib/libgobject-2.0.so.0\")\n"))
                (("^pango = ffi.dlopen.*")
                 (string-append "pango = ffi.dlopen(\""
                  (assoc-ref inputs "pango") "/lib/libpango-1.0.so.0\")\n"))
                (("^pangocairo = ffi.dlopen.*")
                 (string-append "pangocairo = ffi.dlopen(\""
                  (assoc-ref inputs "pango") "/lib/libpangocairo-1.0.so.0\")\n")))))
       (add-after 'install 'install-xsession
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (xsessions (string-append out "/share/xsessions"))
                    (qtile (string-append out "/bin/qtile start")))
               (mkdir-p xsessions)
               (copy-file "resources/qtile.desktop" (string-append xsessions "/qtile.desktop"))
               (substitute* (string-append xsessions "/qtile.desktop")
                 (("qtile start") qtile))))))))
    (inputs
      (list glib pango pulseaudio))
    (propagated-inputs
      (list python-cairocffi
            python-cffi
            python-dateutil
            python-dbus-next
            python-iwlib
            python-keyring
            python-mpd2
            python-pyxdg
            my-python-xcffib))
    (native-inputs
      (list pkg-config
            python-flake8
            python-pep8-naming
            python-psutil
            python-pytest-cov
            python-setuptools-scm))
    (home-page "http://qtile.org")
    (synopsis "Hackable tiling window manager written and configured in Python")
    (description "Qtile is simple, small, and extensible.  It's easy to write
your own layouts, widgets, and built-in commands.")
    (license license:expat)))

		
