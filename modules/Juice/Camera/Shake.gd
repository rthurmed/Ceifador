extends Node


export var camera_path: NodePath
export var default_strength: float = 1.5
export var default_time: float = .05

onready var camera: Camera2D = get_node(camera_path)
onready var tween: Tween = $Tween

signal completed

var rng = RandomNumberGenerator.new()


func _ready():
	rng.randomize()


func impact(time: float = default_time, strength: float = default_strength):
	var force = Vector2(
		rng.randf_range(-strength, strength),
		rng.randf_range(-strength, strength)
	)
	_bounce_camera(force, time)


func is_running() -> bool:
	return tween.is_active()


func _bounce_camera(force: Vector2, time: float):
	var trans_type = Tween.TRANS_BOUNCE
	# warning-ignore:return_value_discarded
	tween.interpolate_method(camera, "set_offset",
		Vector2.ZERO, force,
		time,
		trans_type,
		Tween.EASE_IN
	)
	# warning-ignore:return_value_discarded
	tween.interpolate_method(camera, "set_offset",
		force, Vector2.ZERO,
		time,
		trans_type,
		Tween.EASE_OUT,
		time
	)
	# warning-ignore:return_value_discarded
	tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("completed")
