extends Area2D
class_name Bullet


export var speed = 200
export var angle = 0
export var max_lifetime = 1 # seconds

var lifetime = 0


func _process(delta):
	lifetime += delta
	
	if lifetime >= max_lifetime:
		queue_free()
	
	position += (Vector2.RIGHT * speed).rotated(angle)
