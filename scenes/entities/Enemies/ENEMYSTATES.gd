extends Node

@onready var IDLE = $EnemyIdle
@onready var FOLLOW = $EnemyFollow
@onready var ATTACK = $EnemyAttack
#
#var current_state : EnemyState
#var previous_state : EnemyState


## Called when the node enters the scene tree for the first time.
#func _ready():
	#
	#current_state = get_child(0) as EnemyState
	#previous_state = current_state
	#current_state.enter_state()
	#print(get_child(0).name)
#
#func change_state(state):
	#current_state = find_child(state) as EnemyState
	#current_state.enter_state()
	#
	#previous_state.exit_state()
	#previous_state = current_state
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
