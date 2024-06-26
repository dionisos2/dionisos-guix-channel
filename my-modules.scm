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
						 (guix git-download)
						 (gnu packages linux)
						 (gnu packages video)
						 (gnu packages xiph)
						 (gnu packages fontutils)
						 (gnu packages vulkan)
						 (gnu packages xdisorg)
						 (gnu packages xml)
						 (gnu packages tls)
						 (gnu packages gl)
						 (gnu packages audio)
						 (gnu packages qt)
						 (gnu packages sdl)
						 (gnu packages compression)
						 (gnu packages base)
						 (guix build-system node)
						 (guix gexp)
						 )

(define-public my-tiddlywiki
  (package
    (name "my-tiddlywiki")
    (version "5.3.3")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/tiddlywiki/-/tiddlywiki-5.3.3.tgz")
       (sha256
        (base32 "0z5j89hkbsnigab3zx89nfpya0lzsgk133yx7nv75c8n5k9hvbv8"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases #~(modify-phases %standard-phases
                   (delete 'build)
                   (add-after 'patch-dependencies 'delete-dev-dependencies
                     (lambda _
                       (delete-dependencies '("eslint")))))))
    (home-page "https://github.com/Jermolene/TiddlyWiki5#readme")
    (synopsis "a non-linear personal web notebook")
    (description "a non-linear personal web notebook")
    (license license:bsd-3)))


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


(define-public my-retroarch
  (package
    (name "my-retroarch")
    (version "1.19.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/libretro/RetroArch")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        ;; (base32 "0wdl9zrb1gpqgrxxmv6fida1si1s5g6061aja9dm0hnbpa8cbsdq"))))
				(base32 "15nh4y4vpf4n1ryhiy4fwvzn5xz5idzfzn9fsi5v9hzp25vbjmrm"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f                      ; no tests
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (etc (string-append out "/etc"))
                    (vulkan (assoc-ref inputs "vulkan-loader"))
                    (wayland-protocols (assoc-ref inputs "wayland-protocols")))
               ;; Hard-code some store file names.
               (substitute* "gfx/common/vulkan_common.c"
                 (("libvulkan.so") (string-append vulkan "/lib/libvulkan.so")))
               (substitute* "gfx/common/wayland/generate_wayland_protos.sh"
                 (("/usr/local/share/wayland-protocols")
                 (string-append wayland-protocols "/share/wayland-protocols")))

               ;; Without HLSL, we can still enable GLSLANG and Vulkan support.
               (substitute* "qb/config.libs.sh"
                 (("[$]HAVE_GLSLANG_HLSL") "notcare"))

               ;; The configure script does not yet accept the extra arguments
               ;; (like ‘CONFIG_SHELL=’) passed by the default configure phase.
               (invoke
                 "./configure"
                 ,@(if (string-prefix? "armhf" (or (%current-target-system)
                                                  (%current-system)))
                       '("--enable-neon" "--enable-floathard")
                       '())
                 (string-append "--prefix=" out)
								 )))))))
    (inputs
     (list alsa-lib
           eudev
           ffmpeg
           flac
           freetype
           glslang
           libxinerama
           libxkbcommon
           libxml2
           libxrandr
           libxv
           mbedtls-lts
           mesa
           openal
           openssl
           pulseaudio
           python
           qtbase-5
           sdl2
           spirv-headers
           spirv-tools
           vulkan-loader
           wayland
           zlib))
    (native-inputs
     (list pkg-config wayland-protocols which))
    (native-search-paths
     (list (search-path-specification
            (variable "LIBRETRO_DIRECTORY")
            (separator #f)              ; single entry
            (files '("lib/libretro")))))
    (home-page "https://www.libretro.com/")
    (synopsis "Reference frontend for the libretro API")
    (description
     "Libretro is a simple but powerful development interface that allows for
the easy creation of emulators, games and multimedia applications that can plug
straight into any libretro-compatible frontend.  RetroArch is the official
reference frontend for the libretro API, currently used by most as a modular
multi-system game/emulator system.")
    (license license:gpl3+)))
