extends Node2D
class_name Gun

# GUN
# keep shooting when enabled

export var bullet_scene: PackedScene
export var shooting = false
export (float, 0.1, 2) var time_between_shots: float = 1.0 # seconds
export var delay_first = true

onready var bullet_spawn_point = $BulletSpawnPoint

var was_shooting_before = false
var time = 0


func _process(delta):
	if not shooting: return
	
	if not was_shooting_before and not delay_first:
		time = time_between_shots
	
	if time >= time_between_shots:
		time = 0
		was_shooting_before = false
		shoot()
	
	was_shooting_before = true
	time += delta


func shoot():
	var instance: Bullet = bullet_scene.instance()
	
	instance.global_position = bullet_spawn_point.global_position
	instance.angle = bullet_spawn_point.global_rotation
	# instance.global_rotation = bullet_spawn_point.global_rotation
	
	var stage: Node2D = get_tree().get_nodes_in_group('stage')[0]
	stage.add_child(instance)
