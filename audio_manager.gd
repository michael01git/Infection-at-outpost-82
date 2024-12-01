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


@export_subgroup("SSFX")
@export var wind: AudioStreamWAV
@export var bark: AudioStreamWAV
@export var heli: AudioStreamWAV

@onready var ssfx_player = $SSFXPlayer
var scene_tracker = GameManager.currentScene

@onready var music_player = $MusicPlayer
var music_player_stream: AudioStreamWAV

func _process(_delta):
	if scene_tracker != GameManager.currentScene:
		ssfx_player.stop()

func play_special_sfx(track: int) -> void:
	scene_tracker = GameManager.currentScene
	
	var play_track: AudioStreamWAV
	
	match track:
		0:
			ssfx_player.playing = false
		1:
			ssfx_player.pitch_scale = 0.5
			ssfx_player.volume_db = -15
			play_track = wind
		2:
			ssfx_player.pitch_scale = 2
			ssfx_player.volume_db = -30
			play_track = bark
		3:
			ssfx_player.pitch_scale = 4
			ssfx_player.volume_db = -25
			play_track = heli
	
	ssfx_player.stream = play_track
	ssfx_player.play()
	

func play_sfx(track: int) -> void:
	match track:
		1:
			create_sfx(positive, 0)
		2:
			create_sfx(negative, 0)
		3:
			create_sfx(suprise, -15)
		4:
			create_sfx(action, 0)

func create_sfx(sound: AudioStreamWAV, db: int):
	var sfx: AudioStreamPlayer = AudioStreamPlayer.new()
	add_child(sfx)
	sfx.stream = sound
	sfx.volume_db = db
	sfx.play()
	sfx.finished.connect(sfx.queue_free)

func play_music(track: int) -> void:
	var played_track: AudioStreamWAV
	
	match track:
		0:
			music_player.playing = false
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
			music_player.volume_db = -5
		3:
			music_player.pitch_scale = 0.5
			music_player.volume_db = -5
	
	music_player_stream = played_track
	
	music_player.stream = played_track
	music_player.play()

func _on_music_player_finished():
	music_player.play()

func _on_ssfx_player_finished():
	ssfx_player.play()
