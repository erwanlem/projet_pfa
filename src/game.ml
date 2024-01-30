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
  let obj = Box.create "object" 100 100 40 40 (Gfx.color 255 0 0 255) 10.0 in
  obj # sum_forces # set Vector.{ x=0.2; y=(-0.2) }

let init_player () =
  let player = Character.create "player" (100) 100 40 40 (Gfx.color (Random.int 255) (Random.int 255) (Random.int 255) 255) 50. 0. in
  Global.init_camera (Camera.create (player:>box))
  (*in player # sum_forces # set Vector.{x =((Random.float 2.)-.1.);y = ((Random.float 2.)-.1.)}*)

(*let ball = Box.create "ball" 50 295 10 10 (Gfx.color 0 0 0 255)
let () = Move_system.register (ball :> movable)


let random_v b =
  let a = Random.float (Float.pi/.2.0) -. (Float.pi /. 4.0) in
  let v = Vector.{x = cos a; y = sin a} in
  let v = Vector.mult 5.0 (Vector.normalize v) in
  if b then v else Vector.{ v with x = -. v.x }
let () = Random.self_init ()
let () = ball # velocity # set Vector.zero

let player1 = Box.create "player1" 30 (300-50) 10 100 (Gfx.color 0 0 0 255)
let () = Move_system.register (player1 :> movable)

let player2 = Box.create "player2" 760 (300-50) 10 100 (Gfx.color 0 0 0 255)
let () = Move_system.register (player2 :> movable)*)


let init dt =
  Level_loader.load_map "resources/files/01.level";
  (*init_walls ();*)
  (*init_objects ();*)
  init_player ();
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
  Ecs.System.update_all dt;
  true

  let run cfg = 
    Config.register cfg;
    Gfx.main_loop init;
    Gfx.main_loop update