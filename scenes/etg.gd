extends Node2D

@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var audio_stream_player_2d_5: AudioStreamPlayer2D = $player/AudioStreamPlayer2D5
@onready var king: CharacterBody2D = %King
@onready var PICKUP_COIN__2_ = preload("res://sounds/pickupCoin (2).wav")
@onready var PICKUP_COIN__3_ = preload("res://sounds/pickupCoin (3).wav")
@onready var player: CharacterBody2D = $player
@onready var camera_2d: Camera2D = $player/Camera2D

var actrivated = false

func _ready() -> void:
	GameManager.connect("phaseChange", changePhase)
	DialogManager.connect("done", makeDialog)
	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if actrivated == false:
		if body.IS_PLAYER:
			animation_player.play("intro")
			actrivated = true

func makeDialog():
	if GameManager.bossPhase == 1:	
		GameManager.playerCanMove = false
		GameManager.enemyCanAttack = false
		DialogManager.start_dialog(king.global_position - global_position, ["No fair! No fair! No fair!", "My guy actually has another form and is even stronger!"], PICKUP_COIN__2_)
		camera_2d.reparent(king)
		GameManager.bossPhase += 1
	elif GameManager.bossPhase == 3:	
		GameManager.playerCanMove = false
		GameManager.enemyCanAttack = false
		DialogManager.start_dialog(king.global_position - global_position, ["No! No! No!", "This isn't over...", "My guy actually can fly so take that!"], PICKUP_COIN__2_)
		camera_2d.reparent(king)
		GameManager.bossPhase += 1
		
	if DialogManager.is_active == false:
		GameManager.playerCanMove = true
		GameManager.enemyCanAttack = true
		camera_2d.reparent(player)
		
		if GameManager.bossPhase == 2:		
			beginPhase2()
		elif GameManager.bossPhase == 4:
			beginPhase3()

func beginPhase3():
	king.should_chase = true
	# king.sprite_2d.region_rect.position.x = 90.0
	king.phase3()


func beginPhase2():
	king.should_chase = true
	king.sprite_2d.region_rect.position.x = 90.0
	king.phase2()

func changePhase():
	if  GameManager.bossPhase == 1:
		endPhase1()
	elif GameManager.bossPhase == 3:
		endPhase2()


func endPhase2():
	GameManager.playerCanMove = false
	GameManager.enemyCanAttack = false
	king.should_chase = false
	DialogManager.start_dialog(player.global_position - global_position, ["Woohoo! This time for real!"], PICKUP_COIN__3_)

func endPhase1():
	GameManager.playerCanMove = false
	GameManager.enemyCanAttack = false
	DialogManager.start_dialog(player.global_position - global_position, ["Yes! I beat you!"], PICKUP_COIN__3_)
