let get_free_port () = 
  let socket = Unix.socket Unix.PF_INET Unix.SOCK_STREAM 0 in
  let serverinfo = Unix.getaddrinfo "0.0.0.0" "0" [] in
  match serverinfo with
  | [] -> failwith "Failed to get serverinfo"
  | addr::_ ->
    let () = Unix.bind socket addr.ai_addr in
    let addrinfo2 = Unix.getsockname socket in
    match addrinfo2 with
    | ADDR_UNIX a -> failwith (Printf.sprintf "ADDRUNIX: %s" a)
    | ADDR_INET (_, port) ->
      Unix.close socket;
      port

let get_server () =
  let port = get_free_port () in
  Dream.serve ~port:port Zero2prod.Routes.routes |> ignore;
  port
