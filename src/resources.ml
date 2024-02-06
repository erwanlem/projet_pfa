

let resources = Hashtbl.create 10


let input = ["resources/files/01.level"; "resources/files/02.level"]

let load_resources dt =
  let res = List.fold_left (fun acc e -> (e, (Gfx.load_file e)) :: acc) [] input in
  let ready = List.fold_left (fun acc (e, l) -> Gfx.resource_ready l && acc) true res in
  if not ready then true
  else (List.iter (fun (e, l) -> Hashtbl.replace resources e l) res; false)
