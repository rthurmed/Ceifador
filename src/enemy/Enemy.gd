extends Area2D
class_name Enemy

const COLLISION_LAYER = 4 # being the enemy
const COLLISION_MASK = 8 # get hit by player bullets
const GROUP = 'enemy'
const DropHPScene = preload("res://src/enemy/DropHP.tscn")

signal dead

export var should_drop_hp = false
export var external_life_bar_path: NodePath

onready var health: Health = $Health
onready var audio_damage = $Audio/Damage
onready var audio_laser = $Audio/Laser
onready var animation = $AnimationPlayer

var my_guns = []


func _ready():
	collision_layer = COLLISION_LAYER
	collision_mask = COLLISION_MASK
	
	monitorable = true
	monitoring = true
	
	add_to_group(GROUP)
	
	if external_life_bar_path != "":
		health.bar = get_node(external_life_bar_path)
	
	var _ok
	_ok = connect("area_entered", self, '_on_Enemy_area_entered')
	_ok = health.connect("dead", self, '_on_Health_dead')
	_ok = health.connect("damage", self, '_on_Health_damage')
	_ok = animation.connect("animation_finished", self, '_on_AnimationPlayer_animation_finished')
	
	# TODO: maybe pass the sound to the gun instead of doing all that
	var all_guns = get_tree().get_nodes_in_group(Gun.GROUP)
	for that_gun in all_guns:
		if is_a_parent_of(that_gun):
			my_guns.append(that_gun)
			that_gun.connect("shot", self, '_on_Gun_shot')
	
	if get_node("AnimatedSprite") != null:
		get_node("AnimatedSprite").playing = true


func spawn_hp_drop():
	var instance = DropHPScene.instance()
	
	instance.global_position = global_position
	
	var stage: Node2D = get_tree().get_nodes_in_group('stage')[0]
	stage.call_deferred("add_child", instance)


func _on_Enemy_area_entered(area):
	if area.is_in_group(Bullet.GROUP):
		health.hit()
		audio_damage.play()
		area.queue_free()


func _on_Gun_shot():
	audio_laser.pitch_scale = rand_range(0.8, 1.2)
	audio_laser.play()


func _on_Health_dead():
	animation.play("death")
	
	for that_gun in my_guns:
		that_gun.shooting = false


func _on_Health_damage():
	audio_damage.play()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "death":
		emit_signal("dead")
		if should_drop_hp:
			spawn_hp_drop()
		queue_free()
