open Component_defs
open System_defs
open Const

let move_cam opening background _ =
  let cam = Global.camera () in
  let Vector.{x ; y} = cam#pos#get in
  if y >= 0. then begin
    cam#focus#set "player";
    Control.disable := false;
    Real_time_system.unregister (opening :> real_time);
    Draw_system.unregister (opening :> drawable);
    View_system.unregister (opening :> drawable);
    Draw_system.unregister (background :> drawable);
    View_system.unregister (background :> drawable);
  end
  else
    cam#pos#set Vector.{x=x;y=y+.1.}



let create id settings nbr =
  let font_size = 80 in
  let h_space = 10 in

  let text = Gfx.get_resource 
  (try (Hashtbl.find (Resources.get_resources ()) 
        ("resources/files/opening" ^ string_of_int nbr ^ ".level"))
  with Not_found -> failwith (Printf.sprintf "%s not found\n%!" ("opening" ^ string_of_int nbr ^ ".level"))) in
  let line = String.split_on_char '\n' text in

  List.iter (fun e -> Gfx.debug "-> %s\n%!" e) line;

  let ctx = Gfx.get_context (Global.window ()) in

  let height = (font_size+h_space) * List.length line in

  (* Create the background of the opening *)
  let background = new box in
  background#pos#set Vector.{ x = 0.; y = float (-height-Const.window_height) };
  background#rect#set Rect.{width = block_size * 20; height = height+Const.window_height};
  background#layer#set 0;
  let surf_back = Gfx.create_surface ctx (Rect.get_width background#rect#get) height in
  let back =
    if nbr = 1 || nbr = 2 then
      (try Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/op1.png") 
              with Not_found -> failwith "Background not found")
    else if nbr = 3 then
      (try Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/op2.png") 
      with Not_found -> failwith "Background not found") 
    else if nbr = 4 then
      (try Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) "resources/images/op3.png") 
      with Not_found -> failwith "Background not found") 
    else failwith "Invalid opening id"
  in
  Gfx.blit_scale ctx surf_back back 0 0 (Rect.get_width background#rect#get) height;
  background#texture#set (Image surf_back);

  Draw_system.register (background :> drawable);
  View_system.register (background :> drawable);

  (* Text of the opening *)
  let box = new opening in
  box # pos # set Vector.{ x = 0.; y = float (-height) };
  box # rect # set Rect.{width = block_size * 20; height = height};
  box # id # set id;
  box # layer # set 20;

  let res = try (Hashtbl.find (Resources.get_fonts ()) "resources/fonts/Seagram.ttf") 
            with Not_found -> failwith "Font not resources/fonts/Seagram.ttf found" in

  let surf = Gfx.create_surface ctx (Rect.get_width box#rect#get) height in

  Gfx.set_color ctx (Gfx.color 0 0 0 255);
  for i = 0 to List.length line - 1 do
    let surf_font = Gfx.render_text ctx (List.nth line i) res in
    Gfx.blit_scale ctx surf surf_font (block_size * 4) (i * (font_size+h_space)) (block_size * 12) font_size;

  done;

  box#texture#set (Image surf);

  box#real_time_fun#set (move_cam box background);

  (* Place camera for the opening *)
  let cam = Camera.create "position" in
  cam#axis#set "xy";
  cam#pos#set Vector.{ x = 0.; y = float (-height-Const.window_height) };
  Global.init_camera cam;

  Control.disable := true;

  Real_time_system.register (box :> real_time);
  Draw_system.register (box :> drawable);
  View_system.register (box :> drawable);
  box