extends Area2D
class_name Enemy

const COLLISION_LAYER = 4 # being the enemy
const COLLISION_MASK = 8 # get hit by player bullets
const GROUP = 'enemy'

onready var health = $Health


func _ready():
	collision_layer = COLLISION_LAYER
	collision_mask = COLLISION_MASK
	
	add_to_group(GROUP)
	
	var _ok
	_ok = connect("area_entered", self, '_on_Enemy_area_entered')
	_ok = health.connect("dead", self, '_on_Health_dead')


func _on_Enemy_area_entered(area):
	if area.is_in_group(Bullet.GROUP):
		health.hit()
		area.queue_free()


func _on_Health_dead():
	queue_free()
	# TODO: animation?
