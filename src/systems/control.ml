open Component_defs

type t = controlable

let init _ = ()

let disable = ref false

let keys = Hashtbl.create 16

let cfg = Config.get_config ()

let update dt el =
  let () = match Gfx.poll_event () with
    Gfx.NoEvent -> ()
    | Gfx.KeyDown s -> (*Gfx.debug "%s\n%!" s;*)
                if Hashtbl.mem keys s then ()
                else Hashtbl.replace keys s true
    | Gfx.KeyUp s -> Hashtbl.remove keys s
    | Gfx.MouseButton (b, true, x, y) -> Hashtbl.replace keys "mouse1" true
    | Gfx.MouseButton (b, false, x, y) -> Hashtbl.remove keys "mouse1"
    | _ -> ()
  in
  Seq.iter (fun m ->
    if not !disable || m#id#get = "superuser" then
      let control_fun = m # control # get in
      control_fun keys;
    ) el