extends Node2D

@onready var label: Label = $Label
@onready var animated_sprite_2d_2: AnimatedSprite2D = $AnimatedSprite2D2
@onready var animated_sprite_2d: AnimatedSprite2D = $AudioStreamPlayer2D2/AnimatedSprite2D
@onready var speech_sound1 = preload("res://sounds/pickupCoin (3).wav")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	label.text = "You Only Died " + str(GameManager.playerDeaths) + " Times!"
	DialogManager.connect("done", startDia)

var fren1 = true
var u1 = true
var fren2 = true
func startDia():
	if (fren1):
		DialogManager.start_dialog(animated_sprite_2d_2.global_position - Vector2(0, 50), ["So yeah that's what I think will happen if we played Hero vs. Villain", "So whadaya think wanna join me?"], speech_sound1)
		fren1 = false
	elif (u1):
		DialogManager.start_dialog(animated_sprite_2d.global_position- Vector2(0, 50), ["Wow, you've got a pretty wild imagination", "hehe", "but not today I'm stuck to the floor", "I can't move"], speech_sound1)
		u1 = false
	elif fren2:
		DialogManager.start_dialog(animated_sprite_2d_2.global_position- Vector2(0, 50), ["aww.. no worries, I'll see you around!"], speech_sound1)
		fren2 = false
	else:
		animation_player.play("ending")

		
