extends Node2D
class_name Gun

# GUN
# keep shooting when enabled

signal shot

const GROUP = 'gun'

export var bullet_scene: PackedScene
export var shooting = false
export (float, 0.1, 2) var time_between_shots: float = 1.0 # seconds
export var delay_first = true
export (float) var time = 0.0

onready var bullet_spawn_point = $BulletSpawnPoint

var was_shooting_before = false


func _ready():
	add_to_group(GROUP)


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
	var instance = bullet_scene.instance()
	
	instance.global_position = bullet_spawn_point.global_position
	if 'angle' in instance:
		instance.angle = bullet_spawn_point.global_rotation
	
	var stage: Node2D = get_tree().get_nodes_in_group('stage')[0]
	stage.add_child(instance)
	
	emit_signal("shot")
