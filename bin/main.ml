let () =
  Dream.run
  ~port: 0
  @@ Dream.logger
  @@ Zero2prod.Routes.routes