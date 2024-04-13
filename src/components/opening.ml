open Component_defs
open System_defs
open Const

let file1 = "Lorem ipsum dolor sit amet,
consectetur adipiscing elit. Phasellus
quis imperdiet turpis, sit amet
efficitur diam. Integer lacus risus,
blandit a tortor nec, eleifend aliquet
quam. Donec mauris lectus, dapibus ut
pulvinar feugiat, elementum sit amet sem.
Lorem ipsum dolor sit amet,
consectetur adipiscing elit. Phasellus
quis imperdiet turpis, sit amet
efficitur diam. Integer lacus risus,
blandit a tortor nec, eleifend aliquet
quam. Donec mauris lectus, dapibus ut
pulvinar feugiat, elementum sit amet sem.
Lorem ipsum dolor sit amet,
consectetur adipiscing elit. Phasellus
quis imperdiet turpis, sit amet
efficitur diam. Integer lacus risus,
blandit a tortor nec, eleifend aliquet
quam. Donec mauris lectus, dapibus ut
pulvinar feugiat, elementum sit amet sem."

let create id settings nbr =
  let font_size = 80 in
  let h_space = 10 in
  let line = String.split_on_char '\n' file1 in
  List.iter (fun e -> Gfx.debug "-> %s\n%!" e) line;

  let height = (font_size+h_space) * List.length line in

  let box = new opening in
  box # pos # set Vector.{ x = float (block_size * 4); y = float (-height) };
  box # rect # set Rect.{width = block_size * 12; height = height};
  box # id # set id;
  box # layer # set 20;

  let res = try (Hashtbl.find (Resources.get_fonts ()) "resources/fonts/Seagram.ttf") 
            with Not_found -> failwith (Format.sprintf "Font not resources/fonts/Seagram.ttf found") in
  let ctx = Gfx.get_context (Global.window ()) in

  let surf = Gfx.create_surface ctx (Rect.get_width box#rect#get) height in

  Gfx.set_color ctx (Gfx.color 0 0 0 255);
  for i = 0 to List.length line - 1 do
    let surf_font = Gfx.render_text ctx (List.nth line i) res in
    Gfx.blit ctx surf surf_font 0 (i * (font_size+h_space))

  done;

  box#texture#set (Image surf);

  (*(match settings.texture with 
  None -> box # texture # set (Color (Gfx.color 255 255 255 255))
  | Some t -> 
    let res = Gfx.get_resource (Hashtbl.find (Resources.get_textures ()) t) in
    let ctx = Gfx.get_context (Global.window ()) in

    let w, h = Gfx.surface_size res in
    Gfx.debug "%d, %d\n%!" w h;

    let texture = Texture.image_from_surface ctx res 0 0 
          w h Const.window_width Const.window_height in    
    
    box # texture # set texture);*)
  Move_system.register (box :> movable);
  Draw_system.register (box :> drawable);
  View_system.register (box :> drawable);
  box