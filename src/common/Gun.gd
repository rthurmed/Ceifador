extends Node2D
class_name Gun

# GUN
# keep shooting when enabled

signal shot

const GROUP = 'gun'
const ANIMATION_DURATION = 0.5 # seconds

export var bullet_scene: PackedScene
export var shooting = false
export (float, 0.5, 2) var time_between_shots: float = 1.0 # seconds
export var delay_first = true
export (float) var time = 0.0

onready var bullet_spawn_point = $BulletSpawnPoint
onready var animation = $AnimationPlayer
onready var delay: Timer = $Delay
onready var mock_bullet = $BulletSpawnPoint/MockBullet

var was_shooting_before = false


func _ready():
	add_to_group(GROUP)
	
	var bullet_mock_instance = bullet_scene.instance()
	bullet_mock_instance.only_visual = true
	mock_bullet.add_child(bullet_mock_instance)
	
	delay.set_wait_time(time_between_shots - ANIMATION_DURATION)
	if shooting:
		delay.start()


func _process(delta):
	if not shooting: return
	
	if not was_shooting_before and not delay_first:
		# FIXME
		time = time_between_shots
	
	if time >= time_between_shots:
		time = 0
		was_shooting_before = false
		# shoot()
	
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


func _on_Delay_timeout():
	animation.play("prepare")


func _on_AnimationPlayer_animation_finished(anim_name):
	if not anim_name == "prepare": return
	
	mock_bullet.modulate = Color.transparent
	shoot()
	
	if shooting:
		# starts next shot
		delay.start()
