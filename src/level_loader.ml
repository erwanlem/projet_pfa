open Component_defs

(* Réglages des tailles *)
let basic_block_w = 40 (* largeur bloc classique *)
let basic_block_h = 40 (* hauteur bloc classique *)
let little_platform_w = 40 (* petite plateforme *)
let medium_platform_w = 40 (* moyenne plateforme *)
let large_platform_w = 80  (* grande plateforme *)
let platform_h = 10     (* hauteur des plateformes *)


let settings_table = Hashtbl.create 10 


(* Affichage console de la map *)
let rec print_map map =
  match map with
  | [] -> ()
  | e :: l' -> Gfx.debug "%s\n%!" e; print_map l'




(* Place un élément à partir d'un caractère *)
(*
  Identifiants de bloc
  0 -> plateforme
  1 -> jump box
  2 -> kill box 
  3 -> sol
  4 -> mur
  10 -> bloc changement niveau
  100 -> joueur  
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
    ignore ( Exit_box.create "exit" (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) 
    (Hashtbl.find settings_table "destination") )

  | 100 ->
    let player = Player.create "player" (x*basic_block_w) (600-y*basic_block_h) 40 40 (Gfx.color 255 0 0 255) 50. 0. in
    Global.init_camera (Camera.create (player:>box))

  | _ -> ()


let read_settings s =
  let l = String.split_on_char ',' s in
  let add_setting s =
    Gfx.debug "%s\n" s;
    let cut = String.split_on_char '=' s in
    let setting_name = List.nth cut 0 in
    let setting_value = List.nth cut 1 in
    Hashtbl.replace settings_table setting_name setting_value
  in
  List.iter (fun e -> if e <> "" then add_setting e) l


(* Place les éléments d'une ligne *)
let read_line line =
  if line = "" || line.[0] = '#' then ()
  else
    (* Récupération des informations *)
    let line = List.hd (String.split_on_char '#' line) in
    let line = String.trim line in
    let cut = String.split_on_char ':' line in
    let id = int_of_string (List.hd cut) in
    let cut = String.split_on_char '|' (List.nth cut 1) in
    let pos = List.nth cut 0 in
    let size =List.nth cut 1 in
    let settings = try List.nth cut 2 with Failure n -> Gfx.debug "nth set"; exit 0  in
    let x = int_of_string (List.nth (String.split_on_char 'x' pos) 0) in
    let y = int_of_string (List.nth (String.split_on_char 'x' pos) 1) in
    let w = int_of_string (List.nth (String.split_on_char 'x' size) 0) in
    let h = int_of_string (List.nth (String.split_on_char 'x' size) 1) in
    read_settings settings;
    draw_element id x y w h

(* Charge le fichier au chemin donné en paramètre et renvoie la liste des lignes *)
let load_map (map : string) =
  let l = try Hashtbl.find Resources.resources map 
        with Not_found -> (Gfx.debug "Map file not found\n%!"); exit 0 in
  let l = Gfx.get_resource l in
  let l = String.split_on_char '\n' l in
  print_map l;

  List.iter (fun line -> read_line line) l;