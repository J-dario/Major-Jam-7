extends Node2D

@onready var music: AudioStreamPlayer2D = $music
@onready var space_player: CharacterBody2D = $spacePlayer
@onready var boss: Node2D = $Boss
@onready var PICKUP_COIN__2_ = preload("res://sounds/pickupCoin (2).wav")
@onready var PICKUP_COIN__3_ = preload("res://sounds/pickupCoin (3).wav")
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer
@onready var health_bar: HealthBar = $CanvasLayer/HealthBar
@onready var canvas_layer: CanvasLayer = $CanvasLayer

var phase1 = true

func _ready() -> void:
	GameManager.playerCanMove = false
	GameManager.enemyCanAttack = false
	GameManager.bossHealth = 100
	GameManager.canvas_layer = canvas_layer
	health_bar._setup_health_bar(GameManager.bossHealth)
	DialogManager.connect("done", _dialogEnd)
	
	print(GameManager.maxHealth)
	print(GameManager.currentHealth)
	print(GameManager.movementSpeed)
	print(GameManager.timeBetweenShots)
	print(GameManager.playerDamage)

func begin():
	DialogManager.start_dialog(boss.global_position - global_position, ["Behold.", "I have trancended human form.", "Now perish.", "..Also I took away your dodge lmao", "try and weave beween this, loser"], PICKUP_COIN__2_)

func _dialogEnd():
	if phase1:
		GameManager.playerCanMove = true
		GameManager.enemyCanAttack = true
		animation_player.play("spawnHealthBars")
		music.play()
