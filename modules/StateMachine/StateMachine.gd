class_name StateMachine
extends Node


# Based on
# https://www.gdquest.com/tutorial/godot/design-patterns/finite-state-machine/

signal transition(state_name)

export var initial_state: NodePath

onready var state = get_node(initial_state)


func _ready():
	yield(owner, "ready")
	
	for child in get_children():
		child.connect("transition", self, "_on_State_transition")
		child.machine = self
	
	state.enter()


func _unhandled_input(event):
	state.handle_input(event)


func _process(delta):
	state.process(delta)


func _physics_process(delta):
	state.physics_process(delta)


func transition(state_name):
	state.exit()
	state = get_node(state_name)
	state.enter()
	emit_signal("transition", state_name)


func _on_State_transition(state_name):
	transition(state_name)
