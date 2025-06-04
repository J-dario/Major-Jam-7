extends Node2D

@onready var badge: Sprite2D = $Badge
@onready var title: Label = $Title

var badgeType
func _ready() -> void:
	randomize()
	badgeType = randi_range(0, 4)
	while badgeType in get_parent().cards:
		badgeType = randi_range(0, 4)
	get_parent().cards.append(badgeType)
	badge.region_rect.position.x = 100 * badgeType
	
	if badgeType == 1:
		title.text = "DO MORE DAMAGE"
	elif badgeType == 2:
		title.text = "SHOOT FASTER"
	elif badgeType == 3:
		title.text = "MOVE FASTER"
	elif badgeType == 4:
		title.text = "IDK IS JUST BETTER"

func _on_button_pressed() -> void:
	if badgeType == 0:
		GameManager.playerHealthBar.healthUP()
	elif badgeType == 1:
		GameManager.playerDamage += 1
	elif badgeType == 2:
		GameManager.timeBetweenShots -= 0.25
		GameManager.shurikenGun.changeAS(GameManager.timeBetweenShots)
	elif badgeType == 3:
		GameManager.movementSpeed += 100
	elif badgeType == 4:
		randomize()
		var RbadgeType = randi_range(0, 3)
		if RbadgeType == 0:
			GameManager.playerHealthBar.healthUP()
			GameManager.playerHealthBar.healthUP()
		elif RbadgeType == 1:
			GameManager.playerDamage += 2
		elif RbadgeType == 2:
			GameManager.timeBetweenShots -= 0.5
			GameManager.shurikenGun.changeAS(GameManager.timeBetweenShots)
		elif RbadgeType == 3:
			GameManager.movementSpeed += 200
	get_tree().paused = false
	GameManager.playerHealthBar.fullHeal()
	get_parent().queue_free()
