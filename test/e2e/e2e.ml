let build_addr port =
  Printf.sprintf "http://localhost:%i" port

let test_lwt _ () =
  let open Lwt in
  let port = Zero2prod_test_helper.Server.get_server () in
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