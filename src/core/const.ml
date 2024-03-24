type settings = 
  { 
    t_x : int; 
    t_y : int; 
    t_w : int; 
    t_h : int; 
    resize : int * int;
    texture : string option;
    link : string;
    animation : int;
    color : Gfx.color;
    text : string;
    font : string;
    layer : int;
    fixed : bool }

type mob_stat={health : float; damage: float; mass:float; elas : float}

let gravity = Vector.{x=0.; y = 0.05}

let horz_vel = ref Vector.{x = 0.3; y =0.}

let jump = Vector.{x = 0.; y = -1.6}

let player_health = 50.

let window_width = 1000
let window_height = 800


let sword_damage = 10.
let exclbr_rgd_atk=7.5
let exclbr_mel_atk = 15.
let bullet_speed = 0.35
let arrow_speed = -0.15

let fbdamage = 5.

let knight_stats = {health = 50.; damage = 10.; mass = 10.; elas = 1.}
let arch_stats = {health = 30.; damage = 5.; mass = infinity; elas = 0.}
let icespirit_stats = {health = infinity; damage = 10.; mass = 2.; elas = 1.}


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
  h



let empty_settings = {
  t_x = 0; 
  t_y = 0; 
  t_w = 0; 
  t_h = 0; 
  texture = None;
  link = "";
  resize = (0, 0);
  animation = 0;
  color = Hashtbl.find colors "red";
  text = "";
  font = "";
  layer = 0;
  fixed = false }