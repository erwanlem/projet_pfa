

type config = {
  key_left: string;
  key_up : string;
  key_down : string;
  key_right : string;
  key_space : string;
  key_return : string;
  key_teleport : string;
}


let js = {  key_left = "q"; 
            key_right = "d"; 
            key_up = "z";
            key_down = "down";
            key_space = " ";
            key_return = "s";
            key_teleport = "Shift"; }

let sdl = { key_left = "q";
            key_right = "d";
            key_up = "space";
            key_down = "s";
            key_space = "f";
            key_return="e";
            key_teleport = "c"}


(* Config touches *)
let config = ref {key_left="";
                  key_up="";
                  key_right="";
                  key_down="";
                  key_space = "";
                  key_return="";
                  key_teleport=""}


let get_config () =
  if Gfx.backend = "js" then js
  else sdl