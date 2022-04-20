(lang dune 3.0)

(name zero2prod)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name")

(maintainers "Maintainer Name")

(license MIT)

(documentation https://url/to/documentation)

(package
 (name zero2prod)
 (synopsis "A short synopsis")
 (description "A longer description")
 (depends
  ocaml
  caqti-lwt
  caqti-driver-postgresql
  dune
  (dream (= "1.0.0~alpha4"))
  lwt
  (alcotest :with-test)
  (alcotest-lwt :with-test)
  (cohttp :with-test)
  (cohttp-lwt-unix :with-test)
  (omigrate :with-test)
  )
 (tags
  (topics "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
