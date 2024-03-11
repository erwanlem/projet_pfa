

type config = {
  key_left: string;
  key_up : string;
  key_down : string;
  key_right : string;
  key_space : string;
  key_return : string;
}


let js = {  key_left = "ArrowLeft"; 
            key_right = "ArrowRight"; 
            key_up = "ArrowUp";
            key_down = "ArrowDown";
            key_space = "Control";
            key_return = "Enter"}

let sdl = { key_left = "left"; key_right = "right"; key_up = "up"; key_down = "down";key_space = "space"; key_return="return"}


(* Config touches *)
let config = ref {key_left=""; key_up=""; key_right=""; key_down=""; key_space = ""; key_return=""}


let get_config () =
  if Gfx.backend = "js" then js
  else sdl