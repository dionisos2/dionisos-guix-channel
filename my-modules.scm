(define-module (my-modules))

(use-modules (guix packages)
             (guix download)
             (guix build-system gnu)
						 ((guix licenses) #:prefix license:)
						 (guix build-system python)
						 (gnu packages)
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
						 (guix build-system go)
						 (gnu packages golang)
						 (gnu packages golang-build)
						 (gnu packages golang-check)
						 (gnu packages golang-web)
						 (gnu packages golang-xyz)
						 (gnu packages version-control)
						 (gnu packages textutils)
						 (guix utils)
						 (guix build-system trivial)
						 (gnu packages rust-apps)
						 (gnu packages golang-crypto)
						 (guix build utils)
						 )

(define-public my-tiddlywiki
  (package
    (name "my-tiddlywiki")
    (version "5.3.6")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/tiddlywiki/-/tiddlywiki-5.3.6.tgz")
       (sha256
        (base32 "0kh68vq19zx0ic9516lqznir5ln422qcsmvwjmy8p5pxh5jfvcy3"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-dependencies '("eslint" "@eslint/js"))))))))
    (home-page "https://github.com/TiddlyWiki/TiddlyWiki5#readme")
    (synopsis "a non-linear personal web notebook")
    (description "a non-linear personal web notebook")
    (license #f)))

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
   (version "0.29.0")
   (source
    (origin
     (method url-fetch)
     (uri (pypi-uri "qtile" version))
     (sha256
      (base32 "0qlb34s2747as5i8wdg730a27121drf89bjg86m28rif5byhq81h"))))
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
    (list python-cairocffi python-cffi my-python-xcffib))
   (native-inputs
    (list python-cairocffi
          python-cffi
          python-dbus-next
          ;; my-python-libcst
          python-pygobject
          python-pytest
          python-setuptools
          python-setuptools-scm
          python-wheel))
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

;; (define-public my-chezmoi
;;   (package
;;    (name "my-chezmoi")
;;    (version "2.52.2")
;;    (source (origin
;;             (method git-fetch)
;;             (uri (git-reference
;;                   (url "https://github.com/twpayne/chezmoi")
;;                   (commit (string-append "v" version))))
;;             (file-name (git-file-name name version))
;;             (sha256
;;              (base32
;;               "0mgvzbh89l6r7w9zvrqvpb162f2dkncq4rsa613jawf2h5110b29"))))
;;    (build-system trivial-build-system)
;; 	 (arguments
;; 		`(#:modules ((guix build utils) (guix build union))
;; 			#:builder
;; 			(begin
;; 				(use-modules (guix build utils) (guix build union) (srfi srfi-26))
;; 				(invoke "make" "install-from-git-working-copy")
;; 				)
;; 			)
;; 		)

;;    (native-inputs
;;     (list go-github-com-alecthomas-chroma-v2
;;           go-github-com-bmatcuk-doublestar-v2
;;           go-github-com-charmbracelet-glamour
;;           go-github-com-coreos-go-semver
;;           go-github-com-google-go-github-v33
;;           go-github-com-google-renameio
;;           go-github-com-masterminds-sprig-v3
;;           go-github-com-pelletier-go-toml
;;           go-github-com-pkg-diff
;;           go-github-com-rogpeppe-go-internal
;;           go-github-com-sergi-go-diff
;;           go-github-com-spf13-cobra
;;           go-github-com-spf13-viper
;;           go-github-com-stretchr-testify
;;           go-github-com-twpayne-go-shell
;;           go-github-com-twpayne-go-vfs
;;           go-github-com-twpayne-go-vfsafero
;;           go-github-com-twpayne-go-xdg-v3
;;           go-github-com-zalando-go-keyring
;;           ;; go-github-go-git
;;           go-go-etcd-io-bbolt
;;           go-golang-org-x-oauth2
;;           go-golang-org-x-sys
;;           go-golang-org-x-term
;;           go-gopkg-in-yaml-v2
;;           go-howett-net-plist))
;;    (home-page "https://www.chezmoi.io/")
;;    (synopsis "Personal configuration files manager")
;;    (description "This package helps to manage personal configuration files
;; across multiple machines.")
;;    (license license:expat)))

(define-public go-github-com-go-git-go-git-fixtures
  (package
   (name "go-github-com-go-git-go-git-fixtures")
   (version "4.0.1")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/go-git/go-git-fixtures")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "002yb1s2mxq2xijkl39ip1iyc3l52k23ikyi9ijfl4bgqxy79ljg"))))
   (build-system go-build-system)
   (arguments
    (list
     ;; XXX: panic: runtime error: makeslice: cap out of range
     #:tests? (target-64bit?)
     #:import-path "github.com/go-git/go-git-fixtures/v4"
     #:phases
     #~(modify-phases %standard-phases
											(delete 'reset-gzip-timestamps))))
   (native-inputs
    (list go-github-com-alcortesm-tgz go-github-com-go-git-go-billy
          go-golang-org-x-sys go-gopkg-in-check-v1))
   (home-page "https://github.com/go-git/go-git-fixtures/")
   (synopsis "Fixtures used by @code{go-git}")
   (description "This package provides fixtures used by @code{go-git}.")
   (license license:asl2.0)))

(define-public go-github-com-go-git-go-billy
  (package
   (name "go-github-com-go-git-go-billy")
   (version "5.0.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/go-git/go-billy")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "1wdzczfk1n50dl2zpgf46m69b0sm8qkan5xyv82pk9x53zm1dmdx"))))
   (build-system go-build-system)
   (arguments
    `(#:import-path "github.com/go-git/go-billy/v5"))
   (propagated-inputs
    (list go-golang-org-x-sys))
   (native-inputs
    (list go-gopkg-in-check-v1))
   (home-page "https://github.com/go-git/go-billy/")
   (synopsis "File system abstraction for Go")
   (description "Billy implements an interface based on the OS's standard
library to develop applications without depending on the underlying storage.
This makes it virtually free to implement mocks and testing over
file system operations.")
   (license license:asl2.0)))

(define-public go-github-go-git
  (package
   (name "go-github-go-git")
   (version "5.1.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/go-git/go-git")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "1vkcmhh2qq8c38sjbnzf0wvg2rzr19wssaq177bsvrjwj1xz1qbs"))))
   (build-system go-build-system)
   (arguments
    `(#:tests? #f ;requires network connection
      #:import-path "github.com/go-git/go-git/v5"
      #:phases
      (modify-phases %standard-phases
										 (add-before 'build 'setup
																 (lambda* (#:key inputs #:allow-other-keys)
																	 (let* ((git (assoc-ref inputs "git"))
																					(git-bin (string-append (assoc-ref inputs "git") "/bin"))
																					(git-exe (string-append git-bin "/git")))
																		 (setenv "GIT_DIST_PATH=" git)
																		 (setenv "GIT_EXEC_PATH=" git-bin)
																		 (setenv "HOME" (getcwd))
																		 (invoke git-exe "config" "--global" "user.email" "gha@example.com")
																		 (invoke git-exe "config" "--global" "user.name" "GitHub Actions")
																		 #t)
																	 #t)))))
   (propagated-inputs
    (list go-github-com-alcortesm-tgz
          go-github-com-emirpasic-gods
          go-github-com-go-git-gcfg
          go-github-com-go-git-go-billy
          go-github-com-go-git-go-git-fixtures
          go-github-com-imdario-mergo
          go-github-com-jbenet-go-context
          go-github-com-kevinburke-ssh-config
          go-github-com-mitchellh-go-homedir
          go-github-com-sergi-go-diff
          go-github-com-xanzy-ssh-agent
          go-golang-org-x-crypto
          go-golang-org-x-net
          go-golang-org-x-text
          go-gopkg-in-check-v1
          go-gopkg-in-warnings))
   (native-inputs (list git))
   (home-page "https://github.com/go-git/")
   (synopsis "Git implementation library")
   (description "This package provides a Git implementation library.")
   (license license:asl2.0)))

(define-public my-chezmoi
  (package
   (name "my-chezmoi")
   (version "2.56.0")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/twpayne/chezmoi")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "0s7fmxg4sbs8km7042ywhkvagh03dhmhczbipizna9hic4cxydiy"))))
   (build-system go-build-system)
   (arguments
    (list
     #:import-path "github.com/twpayne/chezmoi"
     #:embed-files #~(list ".*\\.xml")
     #:install-source? #f
     #:phases
     #~(modify-phases %standard-phases
											;; Remove test script which expect additional user's programs available
											;; in the PATH. The testdata directory is removed in the latest version
											;; (2.46.1) of the program.
											;; (add-after 'unpack 'remove-failing-test-scripts
											;;   (lambda* (#:key import-path #:allow-other-keys)
											;;     (for-each (lambda (f)
											;;                 (delete-file (string-append "src/" import-path "/testdata/scripts/" f)))
											;;               '("bitwarden.txt"
											;;                 "cd.txt"
											;;                 "cd_unix.txt"
											;;                 "completion.txt"
											;;                 "diff.txt"
											;;                 "edit.txt"
											;;                 "editconfig.txt"
											;;                 "git.txt"
											;;                 "gopass.txt"
											;;                 "keepassxc.txt"
											;;                 "lastpass.txt"
											;;                 "onepassword.txt"
											;;                 "pass.txt"
											;;                 "runscriptdir_unix.txt"
											;;                 "script_unix.txt"
											;;                 "secretgeneric.txt"
											;;                 "secretgopass.txt"
											;;                 "secretkeepassxc.txt"
											;;                 "secretlastpass.txt"
											;;                 "secretonepassword.txt"
											;;                 "secretpass.txt"))))
											)))
   (native-inputs
    (list go-github-com-masterminds-sprig-v3
          go-github-com-bmatcuk-doublestar-v2
          go-github-com-charmbracelet-glamour
          go-github-com-coreos-go-semver
          go-github-com-go-git-go-git-v5
          go-github-com-google-go-github-v33
          go-github-com-google-renameio
          go-github-com-muesli-combinator
          go-github-com-pelletier-go-toml
          go-github-com-pkg-diff
          go-github-com-rogpeppe-go-internal
          go-github-com-rs-zerolog
          go-github-com-sergi-go-diff
          go-github-com-spf13-cobra
          go-github-com-spf13-viper
          go-github-com-stretchr-testify
          go-github-com-twpayne-go-shell
          go-github-com-twpayne-go-vfs
          go-github-com-twpayne-go-vfsafero
          go-github-com-twpayne-go-xdg-v3
          go-github-com-zalando-go-keyring
          go-go-etcd-io-bbolt
          go-go-uber-org-multierr
          go-golang-org-x-oauth2
          go-golang-org-x-sys
          go-golang-org-x-term
          go-gopkg-in-yaml-v2
          go-gopkg-in-yaml-v3
          go-howett-net-plist))
   (home-page "https://www.chezmoi.io/")
   (synopsis "Personal configuration files manager")
   (description "This package helps to manage personal configuration files
across multiple machines.")
   (license license:expat)))

