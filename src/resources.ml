let game_resources = ref None

let game_textures = ref None

let input_files = ["resources/files/menu.level"; "resources/files/01.level"; "resources/files/02.level"; "resources/files/03.level";
              "resources/files/04.level"]

let input_images = ["resources/images/arthur.png"]

let get_resources () =
  match !game_resources with
  None -> failwith "Error"
  | Some h -> h

let get_textures () =
  match !game_textures with
  None -> failwith "Error"
  | Some h -> h


let load_resources () =
  game_resources := Some (Hashtbl.create 10);
  game_textures := Some (Hashtbl.create 10);
  let h = get_resources () in
  let textures = get_textures () in
  let ctx = Gfx.get_context (Global.window ()) in
  List.iter (fun f -> Hashtbl.replace h f (Gfx.load_file f)) input_files;
  List.iter (fun f -> Hashtbl.replace textures f (Gfx.load_image ctx f)) input_images


let wait_resources dt =
  let ready = Hashtbl.fold (fun a b acc -> (Gfx.resource_ready b) && acc ) (get_resources ()) true in
  not ready