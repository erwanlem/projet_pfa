open Component_defs

type t = audible

let init _ = ()

let current_track = ref "track1"

let sounds = Hashtbl.create 10
let () =
  Hashtbl.replace sounds "" [||];
  Hashtbl.replace sounds "track1" [|"resources/audio/tkucza-happyflutes.mp3"; "resources/audio/The_Bards_Tale_.mp3"|];
  Hashtbl.replace sounds "track2" [|"resources/audio/Tavern-Brawl.mp3"|];
  Hashtbl.replace sounds "track3" [|"resources/audio/dryad.mp3"|];
  Hashtbl.replace sounds "track4" [|"resources/audio/Tavern-Brawl.mp3"|];
  Hashtbl.replace sounds "track5" [|"resources/audio/Lord-McDeath.mp3"|]

let update _dt el =

  Seq.iter (fun m ->
    let index = m#index#get in
    let sound_track_array = Hashtbl.find sounds m#track#get in
    if !current_track <> m#track#get then begin
      let prev_sound_track_array = Hashtbl.find sounds (!current_track) in
      Array.iter (fun e -> 
        if Gfx.resource_ready (Hashtbl.find (Resources.get_audio ()) e) then
          Gfx.pause_sound (Hashtbl.find (Resources.get_audio ()) e)) prev_sound_track_array;
      current_track := m#track#get;
    end;
    if sound_track_array <> [||] then begin
      let sound_track = Hashtbl.find (Resources.get_audio ()) sound_track_array.(index) in
      if not (Gfx.is_playing sound_track) then begin
        (if index+1 >= Array.length sound_track_array then begin
          m#index#set 0 
        end
        else begin
          m#index#set (index+1) 
        end;
        let index = m#index#get in
        let sound_track_array = Hashtbl.find sounds m#track#get in
        let sound_track = Hashtbl.find (Resources.get_audio ()) sound_track_array.(index) in
        Gfx.play_sound sound_track)
      end
    end
  ) el