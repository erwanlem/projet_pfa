open Component_defs

type t = audible

let init _ = ()

let current_track = ref "track1"

let sounds = Hashtbl.create 10
let () =
  Hashtbl.replace sounds "track1" Resources.audio_input

let update _dt el =

  Seq.iter (fun m ->
    let index = m#index#get in
    let sound_track_array = Hashtbl.find sounds !current_track in
    let sound_track = Hashtbl.find (Resources.get_audio ()) sound_track_array.(index) in
    if not (Gfx.is_playing sound_track) then begin
      Gfx.debug "%b\n%!" (not (Gfx.is_playing sound_track));
      (if index+1 >= Array.length sound_track_array then begin
        Gfx.debug "PLAY %d\n%!" index;
        m#index#set 0 
      end
      else begin
        Gfx.debug "PLAY +++++ %d\n%!" (index+1);
        m#index#set (index+1) 
      end;
      let index = m#index#get in
      let sound_track_array = Hashtbl.find sounds !current_track in
      let sound_track = Hashtbl.find (Resources.get_audio ()) sound_track_array.(index) in
      Gfx.debug "INDEX = %d\n%!" m#index#get;
      Gfx.play_sound sound_track)
    end
  ) el;