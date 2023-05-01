extends CanvasLayer


export var disabled = false

onready var ui = $UI


func _unhandled_input(event):
	if disabled: return
	
	if event.is_action_released("pause"):
		paused(not get_tree().paused)
	
	if (
		ui.visible and
		event.is_action_released("reset")
	):
		var _ok = get_tree().reload_current_scene()
		paused(false)


func paused(state: bool):
	get_tree().paused = state
	ui.visible = state


func _exit_tree():
	paused(false)
