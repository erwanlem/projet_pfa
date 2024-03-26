let game_resources = ref None

let game_textures = ref None

let game_fonts = ref None

let input_files = ["resources/files/menu.level"; "resources/files/01.level"; "resources/files/02.level"; "resources/files/03.level";
              "resources/files/04.level"]

let input_images = ["resources/images/arthur.png"; "resources/images/castle.png"; "resources/images/grass.png"; 
                  "resources/images/night.png"; "resources/images/snow.png"; "resources/images/menu_image.jpg";
                  "resources/images/water.png";"resources/images/flame.png";"resources/images/flame2.png";
                  "resources/images/player_attack.png";"resources/images/archer.png";
                  "resources/images/snow_fixed.jpg"; 
                  "resources/images/layer-1.png"; "resources/images/layer-2.png"; "resources/images/layer-3.png";
                  "resources/images/layer-6.png"; "resources/images/snow_layer1.png"; 
                  "resources/images/snow_layer2.png" ]


let input_fonts = [("resources/fonts/Seagram.ttf","serif"); ("resources/fonts/Mono.ttf", "serif")]

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


let load_resources () =
  game_resources := Some (Hashtbl.create 10);
  game_textures := Some (Hashtbl.create 10);
  game_fonts := Some (Hashtbl.create 10);
  let h = get_resources () in
  let textures = get_textures () in
  let fonts = get_fonts () in
  let ctx = Gfx.get_context (Global.window ()) in
  List.iter (fun f -> Hashtbl.replace h f (Gfx.load_file f)) input_files;
  List.iter (fun (f1, f2) -> if Gfx.backend = "js" then Hashtbl.replace fonts f1 (Gfx.load_font f2 "" 100)
                            else Hashtbl.replace fonts f1 (Gfx.load_font f1 "" 80)) input_fonts;
  List.iter (fun f -> Hashtbl.replace textures f (Gfx.load_image ctx f)) input_images


let wait_resources dt =
  let ready = Hashtbl.fold (fun a b acc -> (Gfx.resource_ready b) && acc ) (get_resources ()) true in
  not ready