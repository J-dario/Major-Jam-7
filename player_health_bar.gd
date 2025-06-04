extends Node2D
class_name PlayerHealthBar

@onready var hearts: Sprite2D = $Hearts
@onready var hearts_2: Sprite2D = $Hearts2
const HEARTS = preload("res://sprites/hearts.png")

var heartContainers = []
var heartSpawn = 315

func _ready() -> void:
	heartContainers.append(hearts)
	heartContainers.append(hearts_2)
	GameManager.playerHealthBar = self

func heal():
	if GameManager.currentHealth == GameManager.maxHealth:
		return
	
	heartContainers[GameManager.currentHealth].region_rect.position.x -= 108
	GameManager.currentHealth += 1

func takeDMG():
	if GameManager.currentHealth > 0:
		GameManager.currentHealth -= 1
		heartContainers[GameManager.currentHealth].region_rect.position.x += 108

func fullHeal():
	for i in range(GameManager.maxHealth):
			heal()
	
func healthUP():
	
	if GameManager.currentHealth != GameManager.maxHealth:
		fullHeal()

	GameManager.maxHealth += 1
	GameManager.currentHealth += 1
	
	var newHeart = Sprite2D.new()
	newHeart.texture = HEARTS
	newHeart.region_enabled = true
	newHeart.region_rect = Rect2(0, 0, 108, 102)

	newHeart.position.x = heartSpawn
	newHeart.position.y = 69
	add_child(newHeart)
	heartContainers.append(newHeart)
	heartSpawn += 121
