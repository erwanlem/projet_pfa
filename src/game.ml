open System_defs
open Component_defs


(* On crée une fenêtre *)
let () = Global.init (Format.sprintf "game_canvas:%dx%d:r=presentvsync" Const.window_width Const.window_height)


let init dt =
  Ecs.System.init_all dt;
  false


let fps = ref 0


let update dt =
  (* Affiche FPS *)
  (*(if (int_of_float dt) mod 1000 <= 5 then
    (Gfx.debug "%d\n%!" !fps;
    fps := 0)
  else
    fps := !fps + 1);*)

  if Global.level_switch () then
    Level_loader.load_map (Global.get_level ());
  Ecs.System.update_all dt;
  true


let run () =
  Resources.load_resources ();
  Gfx.main_loop Resources.wait_resources;

  Gfx.main_loop init;
  Gfx.main_loop update