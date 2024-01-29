open Component_defs


type t = drawable

let init _ = ()

let white = Gfx.color 255 255 255 255

let update _dt el =
  let window = Global.window () in
  let ctx = Gfx.get_context window in
  let surface = Gfx.get_surface window in
  let ww, wh = Gfx.get_context_logical_size ctx in
  Gfx.set_color ctx white;
  Gfx.fill_rect ctx surface 0 0 ww wh;
  Seq.iter (fun d ->
      let color = d # color # get in
      let Rect.{width; height} = d # rect # get in
      let Vector.{x; y} = d # pos # get in
      let x = int_of_float x in
      let y = int_of_float y in
      Gfx.set_color ctx color;
      Gfx.fill_rect ctx surface x y width height
    ) el;
  Gfx.commit ctx