extends Node2D


const PlayerScene = preload("res://src/player/Player.tscn")
const TestStage1 = preload("res://src/stages/TestStage1.tscn")
const TestStage2 = preload("res://src/stages/TestStage2.tscn")
const TestStage3 = preload("res://src/stages/TestStage3.tscn")

const stages = [TestStage1, TestStage2, TestStage3]

onready var stage_holder = $StageHolder
onready var retries_ui = $UI/Retries
onready var player_holder = $PlayerHolder

var stage_max_idx = 2
var stage_current_idx = 0
var stage_current_instance: Stage = null
var stage_current_enemies = []
var stage_current_enemy_count = 0
var retries = 4


func _ready():
	load_stage(0)
	reset_player()
	retries_ui.set_amount(retries)


func _process(_delta):
	if Input.is_action_just_released("cheat_skip"):
		for enemy in stage_current_enemies:
			enemy.health.hit(-9999)


func reset_player():
	# TODO: SPAWN ANIMATION WITH INVINCIBILITY!!!!
	# maybe it goes on the player scene
	var instance = PlayerScene.instance()
	instance.connect("dead", self, "_on_Player_dead")
	player_holder.call_deferred("add_child", instance)


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
	stage_current_enemies = enemies
	
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


func _on_Player_dead():
	if retries <= 0:
		# TODO: show game over
		return
	
	retries = retries - 1
	
	reset_player()
	retries_ui.set_amount(retries)
