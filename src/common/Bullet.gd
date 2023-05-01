extends Area2D
class_name Bullet


const GROUP = 'bullet'

export var speed = 100
export var angle = 0
export var max_lifetime = 2.4 # seconds

var lifetime = 0


func _ready():
	add_to_group(GROUP)


func _process(delta):
	lifetime += delta
	
	if lifetime >= max_lifetime:
		queue_free()
	
	var movement = (Vector2.RIGHT * speed).rotated(angle)
	position += movement * delta
