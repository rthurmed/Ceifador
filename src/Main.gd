extends Node2D


const TestStage1 = preload("res://src/stages/TestStage1.tscn")
const TestStage2 = preload("res://src/stages/TestStage2.tscn")
const TestStage3 = preload("res://src/stages/TestStage3.tscn")

const stages = [TestStage1, TestStage2, TestStage3]

onready var stage_holder = $StageHolder

var stage_max_idx = 2
var stage_current_idx = 0
var stage_current_instance: Stage = null
var stage_current_enemy_count = 0


func _ready():
	load_stage(0)


func load_stage(stage_idx):
	if not is_inside_tree(): return
	
	# prepare stage
	var stage = stages[stage_idx]
	
	stage_current_idx = stage_idx
	stage_current_instance = stage.instance()
	var _ok = stage_current_instance.connect("tree_exited", self, "_on_Current_Stage__tree_exited")
	
	stage_holder.add_child(stage_current_instance)
	
	# prepare enemies
	var enemies = get_tree().get_nodes_in_group(Enemy.GROUP)
	
	stage_current_enemy_count = len(enemies)
	
	for enemy in enemies:
		_ok = enemy.connect("dead", self, "_on_Enemy_dead")


func _on_Current_Stage__tree_exited():
	if stage_current_idx >= stage_max_idx:
		# TODO: call end screen
		return
	
	load_stage(stage_current_idx + 1)


func _on_Enemy_dead():
	stage_current_enemy_count = stage_current_enemy_count - 1
	if stage_current_enemy_count <= 0:
		stage_current_instance.queue_free()
