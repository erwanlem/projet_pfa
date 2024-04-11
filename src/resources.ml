let game_resources = ref None

let game_textures = ref None

let game_fonts = ref None

let game_audio = ref None

let text_resources = Hashtbl.create 10

let input_files = ["resources/files/menu.level"; "resources/files/01.level"; "resources/files/02.level"; "resources/files/03.level";
              "resources/files/04.level"]

let input_images = ["resources/images/arthur.png"; "resources/images/castle.png"; "resources/images/grass.png"; 
                  "resources/images/night.png"; "resources/images/snow.png"; "resources/images/menu_image.jpg";
                  "resources/images/water.png";"resources/images/flame.png";"resources/images/flame2.png";
                  "resources/images/player_attack.png";"resources/images/archer.png";
                  "resources/images/snow_fixed.jpg"; 
                  "resources/images/layer-1.png"; "resources/images/layer-2.png"; "resources/images/layer-3.png";
                  "resources/images/layer-6.png"; "resources/images/snow_layer1.png"; 
                  "resources/images/snow_layer2.png"; "resources/images/night/night-layer1.png";
                  "resources/images/night/night-layer4.png"; "resources/images/night/night-layer3.png";
                  "resources/images/night/night-layer0.jpg"; "resources/images/knight_walk.png";
                  "resources/images/knight_attack.png"]

let audio_input = ["resources/audio/tkucza-happyflutes.mp3"; "resources/audio/The_Bards_Tale_.mp3";
                   "resources/audio/Tavern-Brawl.mp3"; "resources/audio/Lord-McDeath.mp3"; 
                   "resources/audio/dryad.mp3"]

(* (Sdl, JavaScript) *)
let input_fonts = [ ("resources/fonts/Seagram.ttf","serif"); ("resources/fonts/Mono.ttf", "serif")]

let get_resources () =
  match !game_resources with
  None -> failwith "Error"
  | Some h -> h

let get_textures () =
  match !game_textures with
  None -> failwith "Error"
  | Some h -> h

let get_fonts () =
  match !game_fonts with
  None -> failwith "Error"
  | Some h -> h

let get_audio () =
  match !game_audio with
  None -> failwith "Error"
  | Some h -> h


(* Load text resources and put them in text_resources hashtable *)
let load_text_resources () =
  Hashtbl.replace text_resources "title1" "Arthur";
  Hashtbl.replace text_resources "title2" "La quête de la cuillère"


let load_resources () =
  game_resources := Some (Hashtbl.create 10);
  game_textures := Some (Hashtbl.create 10);
  game_fonts := Some (Hashtbl.create 10);
  game_audio := Some (Hashtbl.create 10);
  let h = get_resources () in
  let textures = get_textures () in
  let fonts = get_fonts () in
  let sounds = get_audio () in
  let ctx = Gfx.get_context (Global.window ()) in
  List.iter (fun f -> Hashtbl.replace h f (Gfx.load_file f)) input_files;
  List.iter (fun (f1, f2) -> if Gfx.backend = "js" then Hashtbl.replace fonts f1 (Gfx.load_font f2 "" 100)
                            else Hashtbl.replace fonts f1 (Gfx.load_font f1 "" 80)) input_fonts;
  List.iter (fun f -> Hashtbl.replace textures f (Gfx.load_image ctx f)) input_images;
  List.iter (fun f -> Hashtbl.replace sounds f (Gfx.load_sound f)) audio_input;
  load_text_resources ()


let wait_resources dt =
  let ready1 = Hashtbl.fold (fun a b acc -> (Gfx.resource_ready b) && acc ) (get_resources ()) true in
  let ready2 = Hashtbl.fold (fun a b acc -> (Gfx.resource_ready b) && acc ) (get_textures ()) true in
  let ready3 = Hashtbl.fold (fun a b acc -> (Gfx.resource_ready b) && acc ) (get_audio ()) true in
  (*let ready3 = Array.fold_left (fun acc a -> (Gfx.resource_ready a) && acc) true audio_input in*)
  not ready1 || not ready2 || not ready3