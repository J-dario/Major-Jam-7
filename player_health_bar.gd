extends Node2D
class_name PlayerHealthBar

@onready var hearts: Sprite2D = $Hearts
@onready var hearts_2: Sprite2D = $Hearts2
const HEARTS = preload("res://sprites/hearts.png")

var currentHealth = 2
var maxHealth = 2
var heartContainers = []
var heartSpawn = 315

func _ready() -> void:
	heartContainers.append(hearts)
	heartContainers.append(hearts_2)
	
func heal():
	if currentHealth == maxHealth:
		return
	
	heartContainers[currentHealth].region_rect.position.x -= 108
	currentHealth += 1
	print("CURRENT HEALRH IS: ", currentHealth)

func takeDMG():
	if currentHealth == 0:
		return

	currentHealth -= 1
	heartContainers[currentHealth].region_rect.position.x += 108
	print("CURRENT HEALRH IS: ", currentHealth)
	
	if currentHealth == 0:
		print("DED")

func healthUP():
	maxHealth += 1
	currentHealth += 1
	
	print ("RUN")
	
	var newHeart = Sprite2D.new()
	newHeart.texture = HEARTS
	newHeart.region_enabled = true
	newHeart.region_rect = Rect2(0, 0, 108, 102)

	newHeart.position.x = heartSpawn
	newHeart.position.y = 69
	add_child(newHeart)
	heartContainers.append(newHeart)
	heartSpawn += 121
