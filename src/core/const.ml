type settings = 
  { 
    t_x : int; 
    t_y : int; 
    t_w : int; 
    t_h : int; 
    width : int;
    texture : string option;
    link : string;
    animation : int;
    color : Gfx.color;
    text : string;
    text_key : string;
    font : string;
    layer : int;
    parallax : float;
    track : string}

type mob_stat={health : float; damage: float; mass:float; elas : float}

let window_width = 1440
let window_height = 810
let block_size = window_width/20
let map_width = ref (60*block_size)
let max_gap = float (!map_width - window_width)

let force_const = float (block_size) /. 64.

let gravity = Vector.{x=0.; y = 0.05 *. force_const}


(* Player *)
let horz_vel = ref Vector.{x = 0.3 *. force_const; y =0.}
let jump = Vector.{x = 0.; y = -1.6 *. force_const}
let player_health = 50.
let sword_damage = 10.


let exclbr_rgd_atk=7.5
let exclbr_mel_atk = 15.
let bullet_speed = 0.35
let arrow_speed = -0.15
let arrow_speed = Vector.{x = 0.5; y = 0.}
let arrow_size = Rect.{width = 32; height=7}

let medkit_size = Rect.{width =block_size/3; height = block_size/3}

let fbdamage = 5.

let knight_vel = ref Vector.{x = 0.20; y = 0.}
let alexandre_vel = ref Vector.{x = 0.10; y = 0.}
let knight_stats = {health = 50.; damage = 10.; mass = 50.; elas = 0.}
let arch_stats = {health = 30.; damage = 5.; mass = 50.; elas = 0.}
let alexandre_stats = {health = 150.; damage = 10.; mass = 50.; elas = 0.}


let colors =
  let h = Hashtbl.create 10 in
  Hashtbl.add h "red" (Gfx.color 255 0 0 255);
  Hashtbl.add h "green" (Gfx.color 0 255 0 255);
  Hashtbl.add h "blue" (Gfx.color 0 0 255 255);
  Hashtbl.add h "transparent" (Gfx.color 0 0 0 0);
  Hashtbl.add h "yellow" (Gfx.color 255 255 0 255);
  Hashtbl.add h "cyan" (Gfx.color 0 255 255 255);
  Hashtbl.add h "white" (Gfx.color 255 255 255 255);
  Hashtbl.add h "black" (Gfx.color 0 0 0 255);
  Hashtbl.add h "pink" (Gfx.color 255 0 255 255);
  Hashtbl.add h "gold" (Gfx.color 212 172 13 255);
  h