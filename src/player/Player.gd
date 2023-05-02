extends KinematicBody2D
class_name Player


const SPEED = 200
const SPEED_CHANGE_MULTIPLIER = 8 # the lower, the more slippery
const DAMAGE_COLLISION = -3
const ENERGY_COST_BULLET = 1
const ENERGY_COST_DASH = 3
const ENERGY_HEAL_BY_STEALING = 2

onready var gun: Gun = $Gun
onready var health: Health = $Health
onready var energy: Health = $Energy
onready var audio_damage = $Audio/Damage
onready var audio_laser = $Audio/Laser
onready var audio_out_of_ammo = $Audio/OutOfAmmo
onready var audio_energy_heal = $Audio/EnergyHeal

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
	if energy.get_value() < ENERGY_COST_BULLET:
		gun.shooting = false
		
		if (
			Input.is_action_just_pressed("player_shoot") or
			Input.is_action_just_released("player_shoot")
		):
			audio_out_of_ammo.play()
		
		return
	
	gun.shooting = Input.is_action_pressed("player_shoot")
	
	if Input.is_action_just_pressed("player_shoot"):
		gun.shoot()


func _on_Area_area_entered(area):
	if area.is_in_group(Bullet.GROUP):
		health.hit()
		area.queue_free()
	
	if area.is_in_group(Enemy.GROUP):
		health.hit(DAMAGE_COLLISION)
		# TODO: knockback
		pass


func _on_Health_dead():
	queue_free()
	# TODO: fail state


func _on_Gun_shot():
	audio_laser.play()
	energy.hit(-ENERGY_COST_BULLET)


func _on_Health_damage():
	audio_damage.play()


func _on_StealArea_stole_energy():
	energy.heal(ENERGY_HEAL_BY_STEALING)
	audio_energy_heal.play()
