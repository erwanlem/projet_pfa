open Component_defs

type t = controlable

let init _ = ()

let keys = Hashtbl.create 16

let cfg = Config.get_config ()

let update dt el =
  let () = match Gfx.poll_event () with
    Gfx.NoEvent -> ()
    | Gfx.KeyDown s -> (*Gfx.debug "%s@\n%!" s;*)
                if Hashtbl.mem keys s then ()
                else Hashtbl.replace keys s true
    | Gfx.KeyUp s -> Hashtbl.remove keys s
    | _ -> ()
  in
  Seq.iter (fun m ->
      let control_fun = m # control # get in
      control_fun keys;
    ) el