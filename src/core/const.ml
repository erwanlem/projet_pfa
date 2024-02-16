type settings = 
  { t_x : int; t_y : int; t_w : int; t_h : int; texture : string option;
  link : string; }

type mob_stat={health : float; damage: float; mass:float; elas : float}

let gravity = Vector.{x=0.; y = 0.01}

let horz_vel = Vector.{x = 0.2; y =0.}

let jump = Vector.{x = 0.; y = -0.8}

let player_health = 50.

let window_width = 1000
let window_height = 800


let sword_damage = 10.
let exclbr_rgd_atk=7.5
let exclbr_mel_atk = 15.
let bullet_speed = 0.2
let arrow_speed = -0.15

let knight_stats = {health = 50.; damage = 10.; mass = 10.; elas = 1.}
let arch_stats = {health = 30.; damage = 5.; mass = infinity; elas = 0.}
let icespirit_stats = {health = infinity; damage = 10.; mass = 2.; elas = 1.}