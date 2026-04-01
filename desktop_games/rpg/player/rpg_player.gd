extends CharacterBody2D
class_name RPGPlayer

@export var input: RPGInput

@onready var state_machine: StateMachine = %StateMachine

const SPEED: float = 80.0
const ACCELERATION: float = 40.0
const DECELERATION: float = 40.0

func _ready() -> void:
	DesktopManager.rpg_start_battle.connect(func(_battle: BattleResource): state_machine.change_state("battle"))
	DesktopManager.rpg_battle_ended.connect(func(): state_machine.change_state("idle"))

func _physics_process(delta: float) -> void:
	move_and_slide()
