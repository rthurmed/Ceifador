extends Node


export var camera_path: NodePath
export var default_time: float = .1
export var default_zoom: Vector2 = Vector2(.5, .5)

onready var camera: Camera2D = get_node(camera_path)
onready var tween: Tween = $Tween

var original_position = Vector2()

signal completed


func at_point(point: Vector2, zoom: Vector2 = default_zoom, time: float = default_time):
	original_position = camera.position
	_move_camera(camera.global_position, point, camera.zoom, zoom, time)


func _move_camera(from_pos: Vector2, to_pos: Vector2, from_zoom: Vector2, to_zoom: Vector2, time):
	var trans_type = Tween.TRANS_LINEAR
	# POSITION
	# warning-ignore:return_value_discarded
	tween.interpolate_method(camera, "set_global_position",
		from_pos, to_pos,
		time,
		trans_type,
		Tween.EASE_IN
	)
	# warning-ignore:return_value_discarded
	tween.interpolate_method(camera, "set_global_position",
		to_pos, from_pos,
		time,
		trans_type,
		Tween.EASE_OUT,
		time
	)
	# ZOOM
	# warning-ignore:return_value_discarded
	tween.interpolate_method(camera, "set_zoom",
		from_zoom, to_zoom,
		time,
		trans_type,
		Tween.EASE_IN
	)
	# warning-ignore:return_value_discarded
	tween.interpolate_method(camera, "set_zoom",
		to_zoom, from_zoom,
		time,
		trans_type,
		Tween.EASE_OUT,
		time
	)
	# warning-ignore:return_value_discarded
	tween.start()


func _on_Tween_tween_all_completed():
	emit_signal("completed")
	camera.position = original_position
