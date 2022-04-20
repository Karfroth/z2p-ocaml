open Lwt.Syntax

let subscriptions: Dream.request -> Dream.response Lwt.t = fun req ->
  let* data = (Dream.form req) in
  match data with
  | `Ok [("email", _); ("name", _)] -> Dream.empty `OK
  | _ -> Dream.empty `Bad_Request