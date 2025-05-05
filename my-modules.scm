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

;; (define-public go-github-com-go-git-go-git-fixtures
;;   (package
;;    (name "go-github-com-go-git-go-git-fixtures")
;;    (version "4.0.1")
;;    (source (origin
;;             (method git-fetch)
;;             (uri (git-reference
;;                   (url "https://github.com/go-git/go-git-fixtures")
;;                   (commit (string-append "v" version))))
;;             (file-name (git-file-name name version))
;;             (sha256
;;              (base32
;;               "002yb1s2mxq2xijkl39ip1iyc3l52k23ikyi9ijfl4bgqxy79ljg"))))
;;    (build-system go-build-system)
;;    (arguments
;;     (list
;;      ;; XXX: panic: runtime error: makeslice: cap out of range
;;      #:tests? (target-64bit?)
;;      #:import-path "github.com/go-git/go-git-fixtures/v4"
;;      #:phases
;;      #~(modify-phases %standard-phases
;; 											(delete 'reset-gzip-timestamps))))
;;    (native-inputs
;;     (list go-github-com-alcortesm-tgz go-github-com-go-git-go-billy
;;           go-golang-org-x-sys go-gopkg-in-check-v1))
;;    (home-page "https://github.com/go-git/go-git-fixtures/")
;;    (synopsis "Fixtures used by @code{go-git}")
;;    (description "This package provides fixtures used by @code{go-git}.")
;;    (license license:asl2.0)))

;; (define-public go-github-com-go-git-go-billy
;;   (package
;;    (name "go-github-com-go-git-go-billy")
;;    (version "5.0.0")
;;    (source (origin
;;             (method git-fetch)
;;             (uri (git-reference
;;                   (url "https://github.com/go-git/go-billy")
;;                   (commit (string-append "v" version))))
;;             (file-name (git-file-name name version))
;;             (sha256
;;              (base32
;;               "1wdzczfk1n50dl2zpgf46m69b0sm8qkan5xyv82pk9x53zm1dmdx"))))
;;    (build-system go-build-system)
;;    (arguments
;;     `(#:import-path "github.com/go-git/go-billy/v5"))
;;    (propagated-inputs
;;     (list go-golang-org-x-sys))
;;    (native-inputs
;;     (list go-gopkg-in-check-v1))
;;    (home-page "https://github.com/go-git/go-billy/")
;;    (synopsis "File system abstraction for Go")
;;    (description "Billy implements an interface based on the OS's standard
;; library to develop applications without depending on the underlying storage.
;; This makes it virtually free to implement mocks and testing over
;; file system operations.")
;;    (license license:asl2.0)))

;; (define-public go-github-go-git
;;   (package
;;    (name "go-github-go-git")
;;    (version "5.1.0")
;;    (source (origin
;;             (method git-fetch)
;;             (uri (git-reference
;;                   (url "https://github.com/go-git/go-git")
;;                   (commit (string-append "v" version))))
;;             (file-name (git-file-name name version))
;;             (sha256
;;              (base32
;;               "1vkcmhh2qq8c38sjbnzf0wvg2rzr19wssaq177bsvrjwj1xz1qbs"))))
;;    (build-system go-build-system)
;;    (arguments
;;     `(#:tests? #f ;requires network connection
;;       #:import-path "github.com/go-git/go-git/v5"
;;       #:phases
;;       (modify-phases %standard-phases
;; 										 (add-before 'build 'setup
;; 																 (lambda* (#:key inputs #:allow-other-keys)
;; 																	 (let* ((git (assoc-ref inputs "git"))
;; 																					(git-bin (string-append (assoc-ref inputs "git") "/bin"))
;; 																					(git-exe (string-append git-bin "/git")))
;; 																		 (setenv "GIT_DIST_PATH=" git)
;; 																		 (setenv "GIT_EXEC_PATH=" git-bin)
;; 																		 (setenv "HOME" (getcwd))
;; 																		 (invoke git-exe "config" "--global" "user.email" "gha@example.com")
;; 																		 (invoke git-exe "config" "--global" "user.name" "GitHub Actions")
;; 																		 #t)
;; 																	 #t)))))
;;    (propagated-inputs
;;     (list go-github-com-alcortesm-tgz
;;           go-github-com-emirpasic-gods
;;           go-github-com-go-git-gcfg
;;           go-github-com-go-git-go-billy
;;           go-github-com-go-git-go-git-fixtures
;;           go-github-com-imdario-mergo
;;           go-github-com-jbenet-go-context
;;           go-github-com-kevinburke-ssh-config
;;           go-github-com-mitchellh-go-homedir
;;           go-github-com-sergi-go-diff
;;           go-github-com-xanzy-ssh-agent
;;           go-golang-org-x-crypto
;;           go-golang-org-x-net
;;           go-golang-org-x-text
;;           go-gopkg-in-check-v1
;;           go-gopkg-in-warnings))
;;    (native-inputs (list git))
;;    (home-page "https://github.com/go-git/")
;;    (synopsis "Git implementation library")
;;    (description "This package provides a Git implementation library.")
;;    (license license:asl2.0)))

;; (define-public my-chezmoi
;;   (package
;;    (name "my-chezmoi")
;;    (version "2.56.0")
;;    (source (origin
;;             (method git-fetch)
;;             (uri (git-reference
;;                   (url "https://github.com/twpayne/chezmoi")
;;                   (commit (string-append "v" version))))
;;             (file-name (git-file-name name version))
;;             (sha256
;;              (base32
;;               "0s7fmxg4sbs8km7042ywhkvagh03dhmhczbipizna9hic4cxydiy"))))
;;    (build-system go-build-system)
;;    (arguments
;;     (list
;;      #:import-path "github.com/twpayne/chezmoi"
;;      #:embed-files #~(list ".*\\.xml")
;;      #:install-source? #f
;;      #:phases
;;      #~(modify-phases %standard-phases
;; 											;; Remove test script which expect additional user's programs available
;; 											;; in the PATH. The testdata directory is removed in the latest version
;; 											;; (2.46.1) of the program.
;; 											;; (add-after 'unpack 'remove-failing-test-scripts
;; 											;;   (lambda* (#:key import-path #:allow-other-keys)
;; 											;;     (for-each (lambda (f)
;; 											;;                 (delete-file (string-append "src/" import-path "/testdata/scripts/" f)))
;; 											;;               '("bitwarden.txt"
;; 											;;                 "cd.txt"
;; 											;;                 "cd_unix.txt"
;; 											;;                 "completion.txt"
;; 											;;                 "diff.txt"
;; 											;;                 "edit.txt"
;; 											;;                 "editconfig.txt"
;; 											;;                 "git.txt"
;; 											;;                 "gopass.txt"
;; 											;;                 "keepassxc.txt"
;; 											;;                 "lastpass.txt"
;; 											;;                 "onepassword.txt"
;; 											;;                 "pass.txt"
;; 											;;                 "runscriptdir_unix.txt"
;; 											;;                 "script_unix.txt"
;; 											;;                 "secretgeneric.txt"
;; 											;;                 "secretgopass.txt"
;; 											;;                 "secretkeepassxc.txt"
;; 											;;                 "secretlastpass.txt"
;; 											;;                 "secretonepassword.txt"
;; 											;;                 "secretpass.txt"))))
;; 											)))
;;    (native-inputs
;;     (list go-github-com-masterminds-sprig-v3
;;           go-github-com-bmatcuk-doublestar-v2
;;           go-github-com-charmbracelet-glamour
;;           go-github-com-coreos-go-semver
;;           go-github-com-go-git-go-git-v5
;;           go-github-com-google-go-github-v33
;;           go-github-com-google-renameio
;;           go-github-com-muesli-combinator
;;           go-github-com-pelletier-go-toml
;;           go-github-com-pkg-diff
;;           go-github-com-rogpeppe-go-internal
;;           go-github-com-rs-zerolog
;;           go-github-com-sergi-go-diff
;;           go-github-com-spf13-cobra
;;           go-github-com-spf13-viper
;;           go-github-com-stretchr-testify
;;           go-github-com-twpayne-go-shell
;;           go-github-com-twpayne-go-vfs
;;           go-github-com-twpayne-go-vfsafero
;;           go-github-com-twpayne-go-xdg-v3
;;           go-github-com-zalando-go-keyring
;;           go-go-etcd-io-bbolt
;;           go-go-uber-org-multierr
;;           go-golang-org-x-oauth2
;;           go-golang-org-x-sys
;;           go-golang-org-x-term
;;           go-gopkg-in-yaml-v2
;;           go-gopkg-in-yaml-v3
;;           go-howett-net-plist))
;;    (home-page "https://www.chezmoi.io/")
;;    (synopsis "Personal configuration files manager")
;;    (description "This package helps to manage personal configuration files
;; across multiple machines.")
;;    (license license:expat)))

