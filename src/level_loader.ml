open Component_defs
open Const

(* Réglages des tailles *)
let basic_block_w = 64 (* largeur bloc classique *)
let basic_block_h = 64 (* hauteur bloc classique *)


(* Table de hachage des paramètres *)
let settings_table = Hashtbl.create 10 

(* Chargement des paramètres de la table *)
let load_settings () =
  {
    t_x = (try int_of_string (Hashtbl.find settings_table "texture_x") with Not_found -> 0);
    t_y = (try int_of_string (Hashtbl.find settings_table "texture_y") with Not_found -> 0);
    t_w = (try int_of_string (Hashtbl.find settings_table "texture_w") with Not_found -> 1);
    t_h = (try int_of_string (Hashtbl.find settings_table "texture_h") with Not_found -> 1);
    texture = (try Some (Hashtbl.find settings_table "texture") with Not_found -> None);
    link = (try Hashtbl.find settings_table "link" with Not_found -> "");
    animation = (try int_of_string (Hashtbl.find settings_table "animation") with Not_found -> 0);
    color = (let c = (try Hashtbl.find settings_table "color" with Not_found -> "black") in
            try Hashtbl.find colors c with Not_found -> Gfx.color 0 0 0 255);
    text = (try Hashtbl.find settings_table "text" with Not_found -> "");
    font = (try Hashtbl.find settings_table "font" with Not_found -> "");
    layer = (try int_of_string (Hashtbl.find settings_table "layer") with Not_found -> 0)
  }  


(* Affichage console du fichier lu *)
let rec print_map map =
  match map with
  | [] -> ()
  | e :: l' -> Gfx.debug "%s\n%!" e; print_map l'


(* Crée l'élément donné par l'id *)
let draw_element id x y w h =
  match id with
  | 0 ->
    ignore (Box.create "platform"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity (load_settings ()))

  | 1 ->
    ignore (Jump_box.create "jump"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity
    (load_settings ()))

  | 2 ->
    ignore (Box.create "death_box"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity (load_settings ()))
  
  | 3 -> 
    ignore (
    Box.create "ground"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity (load_settings ()));
  
  | 4 ->
    ignore (Box.create "wall"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity (load_settings ()))

  | 5 ->
    ignore (Decor.create "decor"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) (load_settings ()))

  | 10 ->
    ignore ( Exit_box.create "exit" (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) 
    (load_settings ()) )
  
  | 20 ->
    ignore ( Button.create "button" (x*basic_block_w) (Const.window_height-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) 
    (Gfx.color 0 0 0 255) (load_settings ()))

  | 21 ->
    let c = (Box.create "camera"
    (x*basic_block_w) (Const.window_height-y*basic_block_h) 0 0 infinity (load_settings ()))
    in let cam = Camera.create c
    in Global.init_camera cam

  | 22 ->
    let bgnd = try Some (Hashtbl.find settings_table "image") with Not_found -> None in
    ignore (Background.create "menu_background" bgnd)

  | 100 ->
    let player = Player.create "player" (x*basic_block_w) (Const.window_height-y*basic_block_h) 
    44 64 50. 0. (int_of_string (Hashtbl.find settings_table "level")) None in
    Global.init_camera (Camera.create (player:>box))

  | 101 -> 
    ignore(Arch.create "arch" (x*basic_block_w) (Const.window_height-y*basic_block_h) 64 64 None)

  | _ -> ()


(* Lecture des paramètres et ajout dans la table de hachage  *)
let read_settings s =
  Hashtbl.clear settings_table;
  let l = String.split_on_char ',' s in
  let add_setting s =
    (*Gfx.debug "%s\n" s;*)
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
    let settings = List.nth cut 2 in
    let x = int_of_string (List.nth (String.split_on_char 'x' pos) 0) in
    let y = int_of_string (List.nth (String.split_on_char 'x' pos) 1) in
    let w = int_of_string (List.nth (String.split_on_char 'x' size) 0) in
    let h = int_of_string (List.nth (String.split_on_char 'x' size) 1) in
    read_settings settings;
    draw_element id x y w h


(* Charge le fichier au chemin donné en paramètre et renvoie la liste des lignes *)
let load_map (map : string) =
  let l = Hashtbl.find (Resources.get_resources ()) map in
  let l = Gfx.get_resource l in
  let l = String.split_on_char '\n' l in
  print_map l;

  List.iter (fun line -> read_line line) l