let get_free_port () = 
  let open Lwt in
  let socket = Lwt_unix.socket Lwt_unix.PF_INET Lwt_unix.SOCK_STREAM 0 in
  let%lwt serverinfo = Lwt_unix.getaddrinfo "0.0.0.0" "0" [] in
  match serverinfo with
  | [] -> failwith "Failed to get serverinfo"
  | addr::_ ->
    let%lwt () = Lwt_unix.bind socket addr.ai_addr in
    let addrinfo2 = Lwt_unix.getsockname socket in
    match addrinfo2 with
    | ADDR_UNIX a -> failwith (Printf.sprintf "ADDRUNIX: %s" a)
    | ADDR_INET (_, port) ->
      (Lwt_unix.close socket) >>= fun () ->
      Lwt.return port

let get_server () =
  let%lwt port = get_free_port () in
  Dream.serve ~port:port Zero2prod.Routes.routes |> ignore;
  Lwt.return port

let build_addr port =
  Printf.sprintf "http://localhost:%i" port

let test_lwt _ () =
  let open Lwt in
  get_server () >>= fun port ->
  let base_addr = build_addr port in
  let addr = Printf.sprintf "%s/health_check" base_addr in
  Cohttp_lwt_unix.Client.get (Uri.of_string addr) >|= fun (resp, _) ->
  let code = resp |> Cohttp.Response.status |> Cohttp.Code.code_of_status in
  Alcotest.(check int) "health code 200" 200 code
  
let () =
  Lwt_main.run @@ Alcotest_lwt.run "zero2prod" [
    "all", [
      Alcotest_lwt.test_case "health_check respond with 200" `Quick test_lwt
    ]
  ]