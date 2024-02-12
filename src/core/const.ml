type mob_stat={health : float; damage: float; mass:float; elas : float}

let gravity = Vector.{x=0.; y = 0.01}

let horz_vel = Vector.{x = 0.2; y =0.}

let jump = Vector.{x = 0.; y = -0.6}

let player_health = 50.


let sword_damage = 10.
let exclbr_rgd_atk=7.5
let exclbr_mel_atk = 15.
let bullet_speed = 0.2
let arrow_speed = -0.15

let knight_stats = {health = 50.; damage = 10.; mass = 10.; elas = 1.}
let arch_stats = {health = 30.; damage = 5.; mass = infinity; elas = 0.}
let icespirit_stats = {health = infinity; damage = 10.; mass = 2.; elas = 1.}