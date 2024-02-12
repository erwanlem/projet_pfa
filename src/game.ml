open System_defs
open Component_defs


(* On crée une fenêtre *)
let () = Global.init (Format.sprintf "game_canvas:%dx%d:r=presentvsync" 800 600)


let init dt =
  Ecs.System.init_all dt;
  false





(*
let table = Hashtbl.create 16
let has_key s = Hashtbl.mem table s
let set_key s= Hashtbl.replace table s ()
let unset_key s = Hashtbl.remove table s
let v_up = Vector. { x = 0.0; y = -5.0 }
let v_down = Vector.sub Vector.zero v_up*)

let update dt =
  if Global.level_switch () then
    Level_loader.load_map (Global.get_level ());
  Ecs.System.update_all dt;
  true


let run () =
  Resources.load_resources ();
  Gfx.main_loop Resources.wait_resources;

  Gfx.main_loop init;
  Gfx.main_loop update