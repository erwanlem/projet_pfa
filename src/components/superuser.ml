open Component_defs
open System_defs
open Const

let cfg = Config.get_config ()

let onAction key =
  if Hashtbl.mem key "0" then begin
    Gfx.debug "Switch 0\n%!";
    reset_systems ();
    Global.set_level "resources/files/menu.level" end;
  if Hashtbl.mem key "1" then begin
    Gfx.debug "Switch 1\n%!";
    reset_systems ();
    Global.set_level "resources/files/01.level" end;
  if Hashtbl.mem key "2" then begin
    Gfx.debug "Switch 2\n%!";
    reset_systems ();
    Global.set_level "resources/files/02.level" end;
  if Hashtbl.mem key "3" then begin
    Gfx.debug "Switch 3\n%!";
    reset_systems ();
    Global.set_level "resources/files/03.level" end;
  if Hashtbl.mem key "4" then begin
    Gfx.debug "Switch 4\n%!";
    reset_systems ();
    Global.set_level "resources/files/04.level" end;
  if Hashtbl.mem key "u" then begin
    Const.horz_vel := Vector.{x= Vector.get_x !Const.horz_vel +. 0.01 ; y= Vector.get_y !Const.horz_vel };
    Gfx.debug "Velocity = %a\n%!" Vector.pp (!Const.horz_vel) end;
  if Hashtbl.mem key "j" then begin
    Const.horz_vel := Vector.{x= Vector.get_x !Const.horz_vel -. 0.01 ; y= Vector.get_y !Const.horz_vel };
    Gfx.debug "Velocity = %a\n%!" Vector.pp (!Const.horz_vel) end;
  if Hashtbl.mem key "p" && Hashtbl.find key "p" <> None then begin
    Hashtbl.replace key "p" None;
    let c = Global.camera () in
    if c#focus#get = "player" then begin
      c#focus#set "position";
      c#pos#set ((Global.ply ())#pos#get);
    end
    else c#focus#set "player"
  end;

  if Hashtbl.mem key "o" then begin
    let c = Global.camera () in
    c#pos#set (Vector.add c#pos#get Vector.{x=0.;y=(-10.)})
  end;
  if Hashtbl.mem key "k" then begin
    let c = Global.camera () in
    c#pos#set (Vector.add c#pos#get Vector.{x=(-10.);y=0.})
  end;
  if Hashtbl.mem key "l" then begin
    let c = Global.camera () in
    c#pos#set (Vector.add c#pos#get Vector.{x=0.;y=(10.)})
  end;
  if Hashtbl.mem key "m" then begin
    let c = Global.camera () in
    c#pos#set (Vector.add c#pos#get Vector.{x=10.;y=0.})
  end



let create () =
  let box = new controlable in
  box # id # set "superuser";
  box # pos # set Vector.{ x = 0.; y = 0. };
  box # rect # set Rect.{width = 0; height = 0};
  box # control # set (onAction);

  Control_system.register (box);

  box