extends KinematicBody2D


const SPEED = 200
const SPEED_CHANGE_MULTIPLIER = 8 # the lower, the more slippery

onready var gun: Gun = $Gun
onready var health: Health = $Health

var movement = Vector2.ZERO


func _process(delta):
	apply_movement(delta, SPEED)
	apply_shooting(delta)


func apply_movement(delta, speed):
	var direction = Vector2(
		Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
		Input.get_action_strength("player_down") - Input.get_action_strength("player_up")
	)
	
	direction = direction.normalized()
	direction = direction * speed
	
	movement = lerp(movement, direction, delta * SPEED_CHANGE_MULTIPLIER)
	
	movement = move_and_slide(movement)


func apply_shooting(_delta):
	gun.shooting = Input.is_action_pressed("player_shoot")


func _on_Area_area_entered(area):
	if area.is_in_group(Bullet.GROUP):
		health.hit()
	
	if area.is_in_group(Enemy.GROUP):
		# TODO: knockback
		pass


func _on_Health_dead():
	queue_free()
	# TODO: fail state
