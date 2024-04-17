open Component_defs
open System_defs
open Const

let cfg = Config.get_config ()

let onAction button link key =
  if Hashtbl.mem key "mouse1" then begin 
    let pos = Hashtbl.find key "mouse1" in
    match pos with
    | None -> ()
    | Some (x, y) ->
    if Rect.intersect button#pos#get button#rect#get Vector.{x=float x;y=float y} Rect.{width=0;height=0} then begin
      reset_systems ();
      Global.set_level link;
      Hashtbl.remove key cfg.key_return 
    end
  end


let create id x y w h color settings =
  if settings.text <> "" then
    ignore (Text.create (x+20) y (w) h settings);

  let btn = new button in
  btn # pos # set Vector.{ x = float x; y = float y };
  btn # rect # set Rect.{width = w+40; height = h};
  btn # id # set id;
  btn # layer # set (settings.layer-1);
  btn # texture # set (Color (Gfx.color 0 0 0 100));
  btn # control # set (onAction btn settings.link);
  btn # camera_position # set Vector.{ x = float x; y = float y };

  Draw_system.register (btn :> drawable);
  View_system.register (btn :> drawable);
  Control_system.register (btn :> controlable);

  btn