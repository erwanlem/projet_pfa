open Component_defs

(* Réglages des tailles *)
let basic_block_w = 40 (* largeur bloc classique *)
let basic_block_h = 40 (* hauteur bloc classique *)
let little_platform_w = 40 (* petite plateforme *)
let medium_platform_w = 40 (* moyenne plateforme *)
let large_platform_w = 80  (* grande plateforme *)
let platform_h = 10     (* hauteur des plateformes *)

(* Affichage console de la map *)
let rec print_map map =
  match map with
  | [] -> ()
  | e :: l' -> Gfx.debug "%s\n%!" e; print_map l'


(* Lecture d'un fichier texte et renvoie la liste des lignes *)
let read_file file =
  let res = Gfx.load_file file in
  let rec wait_until_ready res =
    if Gfx.resource_ready res then res
    else wait_until_ready res
  in
  (try
  String.split_on_char '\n' (Gfx.get_resource (wait_until_ready res))
  with Failure m -> Gfx.debug "Error while loading map : %s" m; [] 
  )


(* Place un élément à partir d'un caractère *)
(*
  Identifiants de bloc
  0 -> plateforme
  1 -> jump box
  2 -> kill box   
*)

let draw_element id x y w h =
  match id with
  | 0 ->
    ignore (Box.create "platform"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) (Gfx.color 255 255 0 255) infinity)

  | 1 ->
    ignore (Jump_box.create "jump"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) (Gfx.color 255 255 0 255) infinity)

  | 2 ->
    ignore (Box.create "death_box"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) (Gfx.color 255 255 0 255) infinity)
  
  | 3 -> 
    ignore (Box.create "ground"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) (Gfx.color 0 255 128 255) infinity);
  
  | 4 ->
    ignore (Box.create "wall" 
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) (Gfx.color 128 255 0 255) infinity)

  | 10 ->
    ignore ( Exit_box.create "exit" (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) )

  | 100 ->
    let player = Player.create "player" (x*basic_block_w) (600-y*basic_block_h) 40 40 (Gfx.color 255 0 0 255) 50. 0. in
    Global.init_camera (Camera.create (player:>box))

  | _ -> ()


(* Place les éléments d'une ligne *)
let read_line line =
  if line = "" || line.[0] = '#' then ()
  else
    (* Récupération des informations *)
    let line = List.hd (String.split_on_char '#' line) in
    let line = String.trim line in
    let cut = String.split_on_char ':' line in
    let id = int_of_string (List.hd cut) in
    let pos = List.nth (String.split_on_char '|' (List.nth cut 1)) 0 in
    let size =List.nth (String.split_on_char '|' (List.nth cut 1)) 1 in
    let x = int_of_string (List.nth (String.split_on_char 'x' pos) 0) in
    let y = int_of_string (List.nth (String.split_on_char 'x' pos) 1) in
    let w = int_of_string (List.nth (String.split_on_char 'x' size) 0) in
    let h = int_of_string (List.nth (String.split_on_char 'x' size) 1) in
    draw_element id x y w h

(* Charge le fichier au chemin donné en paramètre et renvoie la liste des lignes *)
let load_map (map : string) =
  let l = Hashtbl.find Resources.resources map in
  let l = Gfx.get_resource l in
  let l = String.split_on_char '\n' l in
  print_map l;

  List.iter (fun line -> read_line line) l;