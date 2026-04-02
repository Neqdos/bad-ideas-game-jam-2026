extends Resource
class_name FishingStats

@export var money_gain: float = 1.0
const MONEY_GAIN_UPGRADES: Array[float] = [1.2, 1.4, 1.6, 1.8, 2.0]
const MONEY_GAIN_COSTS: Array[float] = [25.0, 100.0, 300.0, 700.0, 1500.0]

@export var area_size: float = 8.0
const AREA_SIZE_UPGRADES: Array[int] = [12, 16, 24, 32, 48, 64]
const AREA_SIZE_COSTS: Array[float] = [8.0, 24.0, 52.0, 90.0, 185.0, 450.0]

@export var moving_speed: float = 12.0
const MOVING_SPEED_UPGRADES: Array[float] = [20.0, 28.0, 36.0]
const MOVING_SPEED_COSTS: Array[float] = [3.0, 30.0, 300.0]
@export var jump_strength: float = 16.0
const JUMP_STRENGTH_UPGRADES: Array[float] = [20.0, 28.0, 36.0]
const JUMP_STRENGTH_COSTS: Array[float] = [30.0, 90.0, 370.0]
@export var jump_cooldown: float = 3.0
const JUMP_COOLDOWN_UPGRADES: Array[float] = [2.5, 2.0, 1.5, 1.0]
const JUMP_COOLDOWN_COSTS: Array[float] = [36.0, 80.0, 220.0, 515.0]

# -80, 176
@export var line_length: float = 256.0
const LINE_LENGTH_UPGRADES: Array[float] = [432.0, 608.0, 784.0, 1136.0] #1664.0
const LINE_LENGTH_COSTS: Array[float] = [14.0, 65.0, 360.0, 1100.0]

@export var hook_size: int = 0
const HOOK_SIZE_UPGRADES: Array[int] = [1, 2]
const HOOK_SIZE_COSTS: Array[float] = [50.0, 440.0]
@export var max_capacity: int = 5
const MAX_CAPACITY_UPGRADES: Array[int] = [10, 20, 40, 80, 160, 320]
const MAX_CAPACITY_COSTS: Array[float] = [5.0, 32.0, 130.0, 450.0, 900.0, 1700.0]

@export var fish_mult: int = 1
const FISH_MULT_UPGRADES: Array[int] = [2, 4, 6]
const FISH_MULT_COSTS: Array[float] = [200.0, 600.0, 1400.0]

@export var falling_speed: float = 24.0
const FALLING_SPEED_UPGRADES: Array[float] = [48.0, 72.0]
const FALLING_SPEED_COSTS: Array[float] = [100.0, 600.0]
