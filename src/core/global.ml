let window_r = ref None

let window () = match !window_r with Some w -> w | None -> failwith "Uninitialized window"

let init str =
  let w = Gfx.create str in
  window_r := Some w


let scoring_r = ref 0

let set_scoring n = scoring_r := n
let scoring () = !scoring_r



(* Gestion caméra *)
let camera = ref None

let init_camera cam =
  camera := Some (cam)

let camera () = match !camera with Some c -> c | None -> failwith "Uninitialized camera"


(* Gestion des niveaux *)
let level = ref "resources/files/01.level"
let switch_level = ref true

let level_switch () =
  !switch_level
let get_level () =
  switch_level := false;
  !level
let set_level l =
  level := l;
  switch_level := true
