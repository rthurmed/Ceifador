extends Node2D


onready var animation = $AnimationPlayer


func _ready():
	animation.play("intro")


func _process(_delta):
	if Input.is_action_just_released("player_shoot"):
		go_to_next()


func go_to_next():
	var _ok = get_tree().change_scene("res://src/Main.tscn")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "intro":
		go_to_next()
