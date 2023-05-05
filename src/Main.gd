extends Node2D


const PlayerScene = preload("res://src/player/Player.tscn")

const stages = [
	preload("res://src/stages/Stage1.tscn"),
	preload("res://src/stages/Stage4.tscn"),
	preload("res://src/stages/Stage5.tscn"),
	preload("res://src/stages/Stage6.tscn"),
	preload("res://src/stages/Stage9.tscn"),
	preload("res://src/stages/Stage8.tscn"),
	preload("res://src/stages/Stage7.tscn"),
	# TODO: Final Boss
]

onready var stage_holder = $StageHolder
onready var retries_ui = $UI/Retries
onready var player_path_follower = $PlayerPath/AutoPathFollow
onready var player_holder = $PlayerPath/AutoPathFollow/PlayerHolder
onready var player_move_delay = $PlayerPath/PlayerMoveDelay
onready var player_damage_delay = $PlayerPath/PlayerDamageDelay
onready var audio_pass_stage = $Audio/PassStage
onready var audio_player_death = $Audio/PlayerDeath

var stage_max_idx = len(stages)
var stage_current_idx = 0
var stage_current_instance: Stage = null
var stage_current_enemies = []
var stage_current_enemy_count = 0
var retries = 4
var player_instance: Player


func _ready():
	load_stage(0)
	reset_player()
	retries_ui.set_amount(retries)


func _process(_delta):
	if Input.is_action_just_released("cheat_skip"):
		for enemy in stage_current_enemies:
			enemy.health.hit(-9999)


func reset_player():
	player_path_follower.offset = 0
	player_instance = PlayerScene.instance()
	
	player_instance.modulate = Color(1, 1, 1, .5)
	player_instance.player_managed = false
	player_instance.immune_to_damage = true
	
	var _ok
	_ok = player_instance.connect("dead", self, "_on_Player_dead")
	_ok = player_instance.connect("tree_entered", self, "_on_Player_tree_entered")
	
	player_holder.call_deferred("add_child", player_instance)


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
	
	audio_pass_stage.play()
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
	
	audio_player_death.play()
	
	reset_player()
	retries_ui.set_amount(retries)


func _on_Player_tree_entered():
	player_move_delay.start()
	player_damage_delay.start()


func _on_PlayerMoveDelay_timeout():
	player_instance.player_managed = true


func _on_PlayerDamageDelay_timeout():
	player_instance.modulate = Color(1, 1, 1, 1)
	player_instance.immune_to_damage = false
