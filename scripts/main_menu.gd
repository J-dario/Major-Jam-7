extends Node2D

@onready var untitled: Sprite2D = $Untitled
@onready var button: Sprite2D = $Button
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2
@onready var speech_sound1 = preload("res://sounds/pickupCoin (3).wav")
@onready var node_2d: Node2D = $Node2D
@onready var man: Node2D = $Man
@onready var fren: Node2D = $fren

var playerTurn = true
var otherGuy = true
var playerTurn2 = true
var otherGuy2 = true
func _ready() -> void:
	DialogManager.connect("done", _on_node_2d_done)

const lines1: Array[String] = [
	"HEY!",
	"Wanna play Hero vs. Villain with me?",
	"You can be the hero, I'll be the villain",
]

const lines2: Array[String] = [
	"SURE!",
	"I wanna be a ninja!",
]

const lines3: Array[String] = [
	"OK! I wanna be...",
	"Rudenthall The Wicked!",
]
const lines4: Array[String] = [
	"what",
]
const lines5: Array[String] = [
	"hehehhe...",
	"AHAHAHHAHAHA"
]
func _on_button_pressed() -> void:
	audio_stream_player_2d_2.play()
	untitled.queue_free()
	button.queue_free()
	animation_player.play("Intro")

func speak1():
	DialogManager.start_dialog(fren.global_position - global_position, lines1, speech_sound1)

func moveScene():
	get_tree().change_scene_to_file("res://scenes/etg.tscn")
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Intro":
		speak1()

func _on_node_2d_done() -> void:
	if playerTurn:
		DialogManager.start_dialog(man.global_position - global_position, lines2, speech_sound1)
		playerTurn = false
	elif otherGuy:
		DialogManager.start_dialog(fren.global_position - global_position, lines3, speech_sound1)
		otherGuy = false
	elif playerTurn2:
		DialogManager.start_dialog(man.global_position - global_position, lines4, speech_sound1)
		playerTurn2 = false
	elif otherGuy2:
		DialogManager.start_dialog(fren.global_position - global_position, lines5, speech_sound1)
		otherGuy2 = false
	else:
		animation_player.play("Continue")
