extends Resource
class_name FishingStats

# TODO: remember to change this to default
@export var money_gain: float = 20.0#1.0
const MONEY_GAIN_UPGRADES: Array[float] = [1.2, 1.4, 1.6, 1.8, 2.0]
const MONEY_GAIN_COSTS: Array[float] = [25.0, 90.0, 150.0, 400.0, 880.0]

@export var area_size: float = 8.0
const AREA_SIZE_UPGRADES: Array[int] = [12, 16, 20, 24, 32]
const AREA_SIZE_COSTS: Array[float] = [8.0, 24.0, 52.0, 98.0, 212.0]

@export var moving_speed: float = 12.0
const MOVING_SPEED_UPGRADES: Array[float] = [16.0, 20.0, 24.0, 28.0, 32.0, 36.0]
const MOVING_SPEED_COSTS: Array[float] = [18.0, 40.0, 88.0, 156.0, 332.0, 708.0]
@export var jump_strength: float = 24.0
const JUMP_STRENGTH_UPGRADES: Array[float] = [48.0, 72.0, 96.0]
const JUMP_STRENGTH_COSTS: Array[float] = [65.0, 205.0, 650.0]
@export var jump_cooldown: float = 3.0
const JUMP_COOLDOWN_UPGRADES: Array[float] = [2.6, 2.2, 1.8, 1.5, .5]
const JUMP_COOLDOWN_COSTS: Array[float] = [25.0, 125.0, 225.0, 525.0, 1025.0]

# -80, 176
@export var line_length: float = 256.0
const LINE_LENGTH_UPGRADES: Array[float] = [432.0, 608.0, 784.0, 1136.0] #1664.0
const LINE_LENGTH_COSTS: Array[float] = [30.0, 200.0, 800.0, 1200.0]

@export var hook_size: int = 0
const HOOK_SIZE_UPGRADES: Array[int] = [1, 2]
const HOOK_SIZE_COSTS: Array[float] = [50.0, 500.0]
@export var max_capacity: int = 5
const MAX_CAPACITY_UPGRADES: Array[int] = [10, 20, 35, 70, 120]
const MAX_CAPACITY_COSTS: Array[float] = [5.0, 40.0, 160.0, 450.0, 900.0]

@export var fish_mult: int = 1
const FISH_MULT_UPGRADES: Array[int] = [2, 4, 6]
const FISH_MULT_COSTS: Array[float] = [350.0, 880.0, 1600.0]
