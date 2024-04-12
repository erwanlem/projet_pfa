open Component_defs
open System_defs
open Const

let file1 = "Lorem ipsum dolor sit amet,
consectetur adipiscing elit.
Phasellus quis imperdiet turpis,
sit amet efficitur diam.
Integer lacus risus, blandit
a tortor nec, eleifend aliquet
quam. Donec mauris lectus,
dapibus ut pulvinar feugiat,
elementum sit amet sem."

let text_setting settings text =
  {t_x=0;t_y=0;t_w=0;t_h=0;
  width=settings.width;
  texture=None;
  link="";
  animation=0;
  color=Hashtbl.find Const.colors "black";
  text=text;
  text_key="";
  font=settings.font;
  layer=1;
  parallax=1.;
  track=""}

let create id settings =
  let font_size = 80 in
  let h_space = 5 in
  let line = String.split_on_char '\n' file1 in
  List.iter (fun e -> Gfx.debug "-> %s\n%!" e) line;

  let height = (font_size+h_space) * List.length line in

  let box = new box in
  box # pos # set Vector.{ x = 0.; y = float (-height) };
  box # rect # set Rect.{width = block_size * 12; height = height};
  box # id # set id;
  box # layer # set 0;

  for i = 0 to List.length line - 1 do
    ignore (Text.create 0 ((-height) + i * (font_size+h_space)) (block_size * 12) font_size (text_setting settings (List.nth line i)))
  done;



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
  Draw_system.register (box :> drawable);
  box