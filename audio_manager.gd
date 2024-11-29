extends Node

@export_category("Wav Files")
@export_subgroup("SFX")
@export var positive: AudioStreamWAV
@export var negative: AudioStreamWAV
@export var suprise: AudioStreamWAV
@export var action: AudioStreamWAV

@export_subgroup("Music")
@export var normal_fight: AudioStreamWAV
@export var infected_fight: AudioStreamWAV
@export var ambient_station: AudioStreamWAV


@onready var music_player = $MusicPlayer
var music_player_stream: AudioStreamWAV

func play_sfx(track: int) -> void:
	match track:
		1:
			create_sfx(positive)
		2:
			create_sfx(negative)
		3:
			create_sfx(suprise)
		4:
			create_sfx(action)

func create_sfx(sound: AudioStreamWAV):
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(sfx)
	sfx.stream = sound
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_music(track: int) -> void:
	var played_track: AudioStreamWAV
	
	match track:
		1:
			played_track = normal_fight
		2:
			played_track = infected_fight
		3:
			played_track = ambient_station
	
	## If same music is already being played, do nothing.
	if played_track == music_player_stream:
		return
	
	## Settings.
	match track:
		1:
			music_player.pitch_scale = 1
			music_player.volume_db = 0
		2:
			music_player.pitch_scale = 1
			music_player.volume_db = 0
		3:
			music_player.pitch_scale = 0.5
			music_player.volume_db = -5
	
	music_player_stream = played_track
	
	music_player.stream = played_track
	music_player.play()

func _on_music_player_finished():
	music_player.play()
