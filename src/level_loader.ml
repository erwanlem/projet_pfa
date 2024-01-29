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
  try
    (let c = open_in file in
    In_channel.input_lines c)
  with Sys_error e -> (Gfx.debug "Error while loading map : %s" e); []


(* Place un élément à partir d'un caractère *)
let draw_char r c char =
  match char with
  | 'X' -> ignore (Box.create ("bloc_" ^ (string_of_int r) ^ (string_of_int c)) 
  (c*basic_block_w) (600-(r+1)*basic_block_h) basic_block_w basic_block_h (Gfx.color 0 0 255 255) infinity)
  | '_' -> ignore (Box.create ("platform_" ^ (string_of_int r) ^ (string_of_int c))
  (c*basic_block_w) (600-r*basic_block_h-platform_h) little_platform_w platform_h (Gfx.color 0 255 255 255) infinity)
  | '[' -> ignore (Box.create ("platform_" ^ (string_of_int r) ^ (string_of_int c))
  (c*basic_block_w) (600-(r+1)*basic_block_h) platform_h little_platform_w (Gfx.color 0 255 255 255) infinity)
  | ']' -> ignore (Box.create ("platform_" ^ (string_of_int r) ^ (string_of_int c))
  ((c+1)*basic_block_w-platform_h) (600-(r+1)*basic_block_h)  
  platform_h little_platform_w (Gfx.color 0 255 255 255) infinity)
  | '^' -> ignore (Box.create ("jump_" ^ (string_of_int r) ^ (string_of_int c))
  (c*basic_block_w) (600-r*basic_block_h-platform_h) little_platform_w platform_h (Gfx.color 0 0 0 255) infinity)

  | _   -> ()


(* Place les éléments d'une ligne *)
let draw_line r line =
  String.iteri (fun col c -> draw_char r col c) line


(* Charge le fichier au chemin donné en paramètre et renvoie la liste des lignes *)
let load_map (map : string) =
  let l = read_file map in
  print_map l;
  let rev_map = List.rev l in
  List.iteri (fun nbLine line -> draw_line nbLine line) rev_map