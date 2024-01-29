

type config = {
  key_left: string;
  key_up : string;
  key_down : string;
  key_right : string;
}


let js = {  key_left = "ArrowLeft"; 
            key_right = "ArrowRight"; 
            key_up = "ArrowUp";
            key_down = "ArrowDown"}

let sdl = { key_left = "left"; key_right = "right"; key_up = "up"; key_down = "down"}


(* Config touches *)
let config = ref {key_left=""; key_up=""; key_right=""; key_down=""}


let get_config () =
  if Gfx.backend = "js" then js
  else sdl

let register conf =
  config := conf