open Component_defs

(* Réglages des tailles *)
let basic_block_w = 64 (* largeur bloc classique *)
let basic_block_h = 64 (* hauteur bloc classique *)
let platform_h = 10     (* hauteur des plateformes *)


(* Table de hachage des paramètres *)
let settings_table = Hashtbl.create 10 


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
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity (Some (Color (Gfx.color 255 255 0 255))))

  | 1 ->
    ignore (Jump_box.create "jump"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity None)

  | 2 ->
    ignore (Box.create "death_box"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity None)
  
  | 3 -> 
    ignore (Box.create "ground"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity None);
  
  | 4 ->
    ignore (Box.create "wall"
    (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) infinity None)

  | 10 ->
    ignore ( Exit_box.create "exit" (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) 
    (Hashtbl.find settings_table "destination") )
  
  | 20 ->
    ignore ( Button.create "button" (x*basic_block_w) (600-y*basic_block_h) (w*basic_block_w) (h*basic_block_h) 
    (Gfx.color 0 0 0 255) (Hashtbl.find settings_table "link"))

  | 21 ->
    let c = (Box.create "camera"
    (x*basic_block_w) (600-y*basic_block_h) 0 0 infinity (Some (Color (Gfx.color 0 0 0 0))))
    in let cam = Camera.create c
    in Global.init_camera cam

  | 100 ->
    let player = Player.create "player" (x*basic_block_w) (600-y*basic_block_h) 
    40 40 50. 0. (int_of_string (Hashtbl.find settings_table "level")) None in
    Global.init_camera (Camera.create (player:>box))

  | 101 -> 
    ignore(Arch.create "arch" (x*basic_block_w) (600-y*basic_block_h) 40 40)

  | _ -> ()


(* Lecture des paramètres et ajout dans la table de hachage  *)
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

  List.iter (fun line -> read_line line) l;