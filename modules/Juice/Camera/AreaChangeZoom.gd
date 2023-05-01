extends Area2D


export var zoom = Vector2.ONE * 2
export var group_name = "camera_holder"

var camera: Camera2D = null
var initial_zoom = Vector2.ZERO


func _process(delta):
	if camera == null: return
	camera.zoom = lerp(camera.zoom, zoom, delta)


func _on_AreaChangeZoom_body_entered(body):
	if body.is_in_group(group_name):
		var _camera = body.find_node("Camera2D")
		camera = _camera
		initial_zoom = _camera.zoom
