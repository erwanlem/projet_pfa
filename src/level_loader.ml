open Component_defs
open Const

(* Réglages des tailles *)
let basic_block_w = block_size (* largeur bloc classique *)
let basic_block_h = block_size (* hauteur bloc classique *)


(* Table de hachage des paramètres *)
let settings_table = Hashtbl.create 10 

(* Chargement des paramètres de la table *)
let load_settings () =
  {
    t_x = (try int_of_string (Hashtbl.find settings_table "texture_x") with Not_found -> 0);
    t_y = (try int_of_string (Hashtbl.find settings_table "texture_y") with Not_found -> 0);
    t_w = (try int_of_string (Hashtbl.find settings_table "texture_w") with Not_found -> 1);
    t_h = (try int_of_string (Hashtbl.find settings_table "texture_h") with Not_found -> 1);
    width = (try int_of_string (Hashtbl.find settings_table "width") with Not_found -> 90);
    texture = (try Some (Hashtbl.find settings_table "texture") with Not_found -> None);
    link = (try Hashtbl.find settings_table "link" with Not_found -> "");
    animation = (try int_of_string (Hashtbl.find settings_table "animation") with Not_found -> 0);
    color = (let c = (try Hashtbl.find settings_table "color" with Not_found -> "black") in
       try Hashtbl.find colors c with Not_found -> Gfx.color 0 0 0 255);
    text = (try Hashtbl.find settings_table "text" with Not_found -> "");
    text_key = (try Hashtbl.find settings_table "text_key" with Not_found -> "");
    font = (try Hashtbl.find settings_table "font" with Not_found -> "");
    layer = (try int_of_string (Hashtbl.find settings_table "layer") with Not_found -> 5);
    parallax = (try float_of_string (Hashtbl.find settings_table "parallax") with Not_found -> 1.);
    track = (try (Hashtbl.find settings_table "track") with Not_found -> "")
  }  


(* Affichage console du fichier lu *)
let rec print_map map =
  match map with
  | [] -> ()
  | e :: l' -> Gfx.debug "%s\n%!" e; print_map l'


(* Crée l'élément donné par l'id *)
let draw_element id x y w h =
  (* Computes values *)
  let val_x = x*block_size in
  let val_y = Const.window_height-y*basic_block_h in
  let val_w = w*block_size in
  let val_h = h*block_size in

  match id with
  | 0 ->
    ignore (Box.create "platform"
              val_x val_y val_w val_h infinity (load_settings ()))

  | 1 ->
    ignore (Jump_box.create "jump"
              val_x val_y val_w val_h infinity
              (load_settings ()))

  | 2 ->
    ignore (Box.create "death_box"
              val_x val_y val_w val_h infinity (load_settings ()))

  | 3 -> 
    ignore (
      Box.create "ground"
        val_x val_y val_w val_h infinity (load_settings ()));

  | 4 ->
    ignore (Box.create "wall"
              val_x val_y val_w val_h infinity (load_settings ()))

  | 5 ->
    ignore (Decor.create "decor"
              val_x val_y val_w val_h (load_settings ()))

  | 6 ->
    ignore (Fall_box.create "platform"
              val_x val_y val_w val_h infinity
              (load_settings ()))

  | 7 ->
    ignore (Hide_box.create "platform"
              val_x val_y val_w val_h infinity
              (load_settings ()))

  | 10 ->
    ignore ( Exit_box.create "exit" val_x val_y val_w val_h 
               (load_settings ()) )

  | 19 ->
    ignore ( Text.create val_x (y*block_size) val_w val_h (load_settings ()) )

  | 20 ->
    ignore ( Button.create "button" val_x val_y val_w val_h 
               (Gfx.color 0 0 0 255) (load_settings ()))

  | 21 -> 
    let cam = Camera.create "position" in
    cam#pos#set Vector.{x=0.; y=0.};
    cam#axis#set "xy";
    Global.init_camera cam

  | 22 -> ignore (Background.create "menu_background" (load_settings ()))

  | 23 -> ignore (Audio.create (load_settings ()).track)

  | 24 -> 
    let level = int_of_string (
      try (Hashtbl.find settings_table "level") 
      with Not_found -> failwith "Level not found") in
    ignore (Opening.create "op1" (load_settings ()) level);

  | 100 ->
    let player = Player.create "player" val_x val_y 
        block_size block_size 50. 0. (int_of_string (
            try (Hashtbl.find settings_table "level") 
            with Not_found -> failwith "Level not found")) None in
    Global.init_player player

  | 101 -> 
    ignore (Arch.create "arch" val_x val_y block_size block_size None)

  | 102 -> 
    ignore (Knight.create "knight" val_x val_y block_size block_size None)
  
  | 103 -> 
    let e = Event_box.create "appear_box" val_x
    val_y (block_size*2) (block_size*2) (load_settings ()) in
    e#onCollideEvent#set (Alexandre.appear_on_collide (e:>collidable) x y)
 
  | 200 -> ignore ( Medkit.create "medkit" val_x val_y)

  | 1000 ->
    let s = load_settings () in
    map_width := s.width * block_size;
    max_gap := float (!map_width - window_width)
    
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
  Hashtbl.clear settings_table;

  (* Reset map size with the default size *)
  map_width := 90 * block_size;
  max_gap := float (!map_width - window_width);

  Fall_box.remove_fall_box ();
  Hide_box.remove_hide_box ();
  let l = try (Hashtbl.find (Resources.get_resources ()) map) with Not_found -> failwith "Map not found\n" in
  let l = Gfx.get_resource l in
  let l = String.split_on_char '\n' l in
  (*print_map l;*)

  List.iter (fun line -> read_line line) l