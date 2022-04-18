let routes = Dream.router [
  Dream.get "/health_check" (fun _ -> Dream.empty `OK)
]
