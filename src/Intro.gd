extends Node2D


onready var animation = $AnimationPlayer


func _ready():
	# TODO: music
	animation.play("intro")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "intro":
		var _ok = get_tree().change_scene("res://src/Main.tscn")
