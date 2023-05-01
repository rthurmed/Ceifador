extends KinematicBody2D


const SPEED = 300
const SPEED_CHANGE_MULTIPLIER = 8 # the lower, the more slippery

var movement = Vector2.ZERO


func _process(delta):
	apply_movement(delta, SPEED)


func apply_movement(delta, speed):
	var direction = Vector2(
		Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
		Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	)
	
	direction = direction.normalized()
	direction = direction * speed
	
	movement = lerp(movement, direction, delta * SPEED_CHANGE_MULTIPLIER)
	
	movement = move_and_slide(movement)
