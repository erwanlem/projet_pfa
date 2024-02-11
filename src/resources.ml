

let resources = Hashtbl.create 2

let res = ref None

let input = ["resources/files/01.level"; "resources/files/02.level"; 
            "resources/files/03.level"; "resources/files/04.level"]

let load_resources dt =
  if !res = None then
    (res := Some (List.fold_left (fun acc e -> (e, (Gfx.load_file e)) :: acc) [] input);
    true)
  else
    let res = match !res with Some r -> r | None -> [] in
    let ready = List.fold_left (fun acc (e, l) -> Gfx.resource_ready l && acc) true res in
    if not ready then true
    else (List.iter (fun (e, l) -> Hashtbl.replace resources e l) res; 
    Gfx.debug "false -> %d\n%!" (Hashtbl.length resources); false)
