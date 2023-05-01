extends Control


func _ready():
	visible = OS.is_debug_build()
