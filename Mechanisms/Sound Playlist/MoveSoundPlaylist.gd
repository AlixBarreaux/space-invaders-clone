extends Node


var playlist_tracks : Array = []

var current_track
var track_amount : int


func _ready() -> void:
	build_playlist()


func build_playlist() -> void:
	for track in self.get_children():
		playlist_tracks.append(track)
	track_amount = playlist_tracks.size()


var index = -1
func play_next_track_from_playlist() -> void:
	index += 1
	if index == track_amount:
		index = 0
	current_track = playlist_tracks[index]
#	playlist_tracks[index].play()
	play_select_track_from_playlist(index)


func play_select_track_from_playlist(track_number : int) -> void:
	playlist_tracks[track_number].play()


func reset_playlist_track_from_playlist_to_first() -> void:
	index = -1
