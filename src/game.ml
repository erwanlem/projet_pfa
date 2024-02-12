open System_defs
open Component_defs


(* On crée une fenêtre *)
let () = Global.init (Format.sprintf "game_canvas:%dx%d:r=presentvsync" 800 600)

let init_walls () =
  ignore (Box.create "wall_top" 0 0 800 40 (Gfx.color 0 0 255 255) infinity);
  ignore (Box.create "ground" 0 560 800 40 (Gfx.color 0 0 255 255) infinity);
  ignore (Box.create "wall_left" 0 40 40 520 (Gfx.color 0 255 0 255) infinity);
  ignore (Box.create "wall_right" 760 40 40 520 (Gfx.color 0 255 0 255) infinity)


let init_objects () =
  let obj = Box.create "object" 100 100 40 40 (Gfx.color 255 0 0 255) 50.0 in
  obj # sum_forces # set Vector.{ x=0.2; y=(-0.2) }

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
    Gfx.main_loop Resources.load_resources;
    Gfx.main_loop init;
    Gfx.main_loop update