open Component_defs

type t = drawable

let init _ = ()

let update _dt el =
  let camera = Global.camera () in
  
  if camera#focus#get = "player" then begin
    let camera_pos = (Global.ply ())#pos#get in
    Seq.iter (fun m ->
      if Vector.get_x camera_pos > float (Const.window_width/3) then
        let Vector.{x; y} = m # pos # get in
  
        let new_x, new_y =
          ((x -. (Vector.get_x camera_pos) +. float (Const.window_width/3)) *. m#parallax#get, y)
        in
  
        (* Seulement pour affichage hitbox, sinon retirer *)
        (*let cam_position = Vector.add Vector.{x=new_x;y=y} m#hitbox_display#get in*)
        let cam_position =Vector.{x=new_x;y=new_y} in
  
        let position_gap = (x -. Vector.get_x cam_position) in
        if position_gap >= !Const.max_gap *. m#parallax#get then
          m#camera_position#set Vector.{x=x-.(!Const.max_gap)*.m#parallax#get; y=y}
        else
          m#camera_position#set cam_position

      else
        let Vector.{x; y} = m # pos # get in
        m#camera_position#set (Vector.add Vector.{x;y} m#hitbox_display#get)
    ) el
  end


  else
    let camera_pos = camera#pos#get in
    Seq.iter (fun m ->
        let Vector.{x; y} = m # pos # get in
  
        let new_x, new_y =
          ((x -. (Vector.get_x camera_pos) ) *. m#parallax#get,
          (y -. (Vector.get_y camera_pos)) )
        in
        let cam_position =Vector.{x=new_x;y=new_y} in
        m#camera_position#set cam_position
    ) el
