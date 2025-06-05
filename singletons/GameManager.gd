extends Node

var playerCanMove = true
var enemyCanAttack = true
@onready var PICKUP_COIN__2_ = preload("res://sounds/pickupCoin (2).wav")
const DEAD_SCREEN = preload("res://scenes/dead_screen.tscn")
var canvas_layer: CanvasLayer
var shurikenGun
var playerHealthBar

# Player Stats
var playerDamage = 5
var timeBetweenShots = 1
var movementSpeed: float = 400.0
var maxHealth = 2
var currentHealth = 2
var bossHealth = 10

var bossPhase = 0
signal phaseChange

func playerDed():
	var newScreen = DEAD_SCREEN.instantiate()
	canvas_layer.add_child(newScreen)
	get_tree().paused = true
