extends Stage
class_name BossBattle


export var boss_path: NodePath

onready var boss: Enemy = get_node(boss_path)


func _ready():
	var _ok = boss.connect("dead", self, "_on_Boss_dead")


func _on_Boss_dead():
	var all_enemies = get_tree().get_nodes_in_group(Enemy.GROUP)
	for that_enemy in all_enemies:
		if is_a_parent_of(that_enemy):
			that_enemy.health.hit(-9999)
