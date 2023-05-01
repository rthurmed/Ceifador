extends Area2D
class_name Enemy

const COLLISION_LAYER = 4 # being the enemy
const COLLISION_MASK = 8 # get hit by player bullets
const GROUP = 'enemy'

func _ready():
	collision_layer = COLLISION_LAYER
	collision_mask = COLLISION_MASK
	add_to_group(GROUP)
