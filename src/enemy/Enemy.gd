extends Area2D
class_name Enemy

const COLLISION_LAYER = 4 # being the enemy
const COLLISION_MASK = 8 # get hit by player bullets
const GROUP = 'enemy'

onready var gun = $Gun
onready var health = $Health
onready var audio_damage = $Audio/Damage
onready var audio_laser = $Audio/Laser
onready var animation = $AnimationPlayer


func _ready():
	collision_layer = COLLISION_LAYER
	collision_mask = COLLISION_MASK
	
	add_to_group(GROUP)


func _on_Enemy_area_entered(area):
	if area.is_in_group(Bullet.GROUP):
		health.hit()
		audio_damage.play()
		area.queue_free()


func _on_Health_dead():
	animation.play("death")


func _on_Gun_shot():
	audio_laser.pitch_scale = rand_range(0.8, 1.2)
	audio_laser.play()


func _on_Health_damage():
	audio_damage.play()
