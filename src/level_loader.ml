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
let draw_element id x y w h =
  match id with
  | 0 ->
    ignore (Box.create "platform_"
    (x*basic_block_w) (600-y*basic_block_h+1) 4 (h*basic_block_h-2) (Gfx.color 255 255 0 255) infinity);
    ignore (Box.create "platform_"
    (x*basic_block_w+4) (600-(y-1)*basic_block_h-4) (w*basic_block_w-8) 4 (Gfx.color 0 255 0 255) infinity);
    ignore (Box.create "platform_"
    ((x+w)*basic_block_w-4) (600-y*basic_block_h+1) 4 (h*basic_block_h-2) (Gfx.color 255 255 0 255) infinity); 
    ignore (Box.create "platform"
    (x*basic_block_w+4) (600-y*basic_block_h) (w*basic_block_w-8) (h*basic_block_h-4) (Gfx.color 255 255 0 255) infinity)

  | 1 ->
    ignore (Box.create "platform_"
    (x*basic_block_w) (600-y*basic_block_h+1) 4 (h*basic_block_h-2) (Gfx.color 255 255 0 255) infinity);
    ignore (Box.create "platform_"
    (x*basic_block_w+4) (600-(y-1)*basic_block_h-4) (w*basic_block_w-8) 4 (Gfx.color 0 255 0 255) infinity);
    ignore (Box.create "platform_"
    ((x+w)*basic_block_w-4) (600-y*basic_block_h+1) 4 (h*basic_block_h-2) (Gfx.color 255 255 0 255) infinity); 
    ignore (Jump_box.create "platform"
    (x*basic_block_w+4) (600-y*basic_block_h) (w*basic_block_w-8) (h*basic_block_h-4) (Gfx.color 255 255 0 255) infinity)

  | _ -> ()
  (*| 'X' -> ()
  
  | 'G' -> ()
  
  | '_' -> (* ajoute bordures sur les plateformes *)
  ignore (Box.create "platform_"
  (c*basic_block_w-4) (600-r*basic_block_h-platform_h) 4 platform_h (Gfx.color 0 255 255 255) infinity);
  ignore (Box.create "platform_"
  ((c+1)*basic_block_w) (600-r*basic_block_h-platform_h) 4 platform_h (Gfx.color 0 255 255 255) infinity);  
  ignore (Box.create "platform"
  (c*basic_block_w) (600-r*basic_block_h-platform_h) basic_block_w platform_h (Gfx.color 0 255 255 255) infinity)
  
  | '[' -> ignore (Box.create ("platform_" ^ (string_of_int r) ^ (string_of_int c))
  (c*basic_block_w) (600-(r+1)*basic_block_h) platform_h little_platform_w (Gfx.color 0 255 255 255) infinity)
  
  | ']' -> ignore (Box.create ("platform_" ^ (string_of_int r) ^ (string_of_int c))
  ((c+1)*basic_block_w-platform_h) (600-(r+1)*basic_block_h)
  platform_h little_platform_w (Gfx.color 0 255 255 255) infinity)
  
  | '^' -> ignore (Box.create ("jump_" ^ (string_of_int r) ^ (string_of_int c))
  (c*basic_block_w) (600-r*basic_block_h-platform_h) little_platform_w platform_h (Gfx.color 0 0 0 255) infinity)
  | _   -> ()*)


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
  let l = read_file map in
  print_map l;

  let size = String.split_on_char 'x' (List.hd l) in
  let x = int_of_string (List.nth size 0) in
  let y = int_of_string (List.nth size 1) in

  let l = List.tl l in
  let rev_map = List.rev l in
  List.iter (fun line -> read_line line) rev_map;

  (* Création des bordures *)
  ignore (Box.create "ground"
  0 (600-basic_block_h) (x*basic_block_w) (basic_block_h) (Gfx.color 0 255 128 255) infinity);
  ignore (Box.create "wall_left" 
  0 (600-y*basic_block_h) (basic_block_w) ((y-1)*basic_block_h) (Gfx.color 128 255 0 255) infinity)