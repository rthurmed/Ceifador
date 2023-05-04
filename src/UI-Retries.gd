extends Control


const RetryIcon = preload("res://src/ui/RetryIcon.tscn")

onready var container = $HBoxContainer


func set_amount(amount):
	# clean
	for child in container.get_children():
		container.remove_child(child)
	
	# rebuild
	for _i in range(0, amount):
		var instance = RetryIcon.instance()
		container.add_child(instance)
