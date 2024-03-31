open System_defs
open Component_defs


(* On crée une fenêtre *)
let () = Global.init (Format.sprintf "game_canvas:%dx%d:r=presentvsync" Const.window_width Const.window_height)


let init dt =
  Ecs.System.init_all dt;
  false

let init_sound dt =
  let a = Hashtbl.find (Resources.get_audio ()) "resources/audio/The_Bards_Tale_.mp3" in
  Gfx.play_sound a;
  false

let chain_functions l =
  let todo = ref l in
  (fun dt ->
    match !todo with
      [] -> false
      | f :: ll ->
        let res = f dt in
        if res then true
        else begin
          todo := ll;
          true
        end)


let fps = ref 0
let d = ref 0.

let update dt =
  (* Affiche FPS *)
  (*(if (int_of_float dt) mod 1000 <= 5 then
    (Gfx.debug "%d FPS\n%!" !fps;
    fps := 0)
  else
    fps := !fps + 1);*)

  if Global.level_switch () then begin
    ignore (Superuser.create ());
    Level_loader.load_map (Global.get_level ()) end;
  Ecs.System.update_all dt;
  true


let run () =
  Resources.load_resources ();

  Gfx.main_loop (chain_functions [Resources.wait_resources; init_sound; init; update])