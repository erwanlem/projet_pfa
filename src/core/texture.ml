type t = Color of Gfx.color
  | Image of Gfx.surface
  | Animation of { frames : Gfx.surface array;
                   frame_duration :int;
                   mutable current_frame : int;
                   mutable current_time : int }

let color c = Color c


let image_from_surface ctx surface x y w h dw dh =
  let dst = Gfx.create_surface ctx dw dh in
  Gfx.blit_full ctx dst surface x y w h 0 0 dw dh;
  Image dst


let anim_from_surface ctx surface n w h dw dh frame_duration column =
  let frames = 
    Array.init n (fun i ->
      let dst = Gfx.create_surface ctx dw dh in
      Gfx.blit_full ctx dst surface (i*w) (column*h) w h 0 0 dw dh;
      dst)
    in
    Animation { frames; frame_duration; current_time = frame_duration; current_frame = 0 }