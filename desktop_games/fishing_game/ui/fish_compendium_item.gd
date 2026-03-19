extends HBoxContainer

@export var fish_res: FishResource

@onready var fish_sprite: TextureRect = %FishSprite
@onready var fish_name: Label = %FishName
@onready var fish_value: Label = %FishValue
@onready var fish_size: Label = %FishSize

var checked: bool = false

const FISH_SIZE_TO_TEXT: Dictionary[FishResource.SIZE, String] = {
	FishResource.SIZE.Small : "Small",
	FishResource.SIZE.Medium : "Medium",
	FishResource.SIZE.Big : "Big",
	FishResource.SIZE.Huge : "Huge",
}

func _ready() -> void:
	fish_sprite.texture = fish_res.sprite
	
	fish_value.text = "%.2f$" % fish_res.default_money_value
	fish_size.text = FISH_SIZE_TO_TEXT[fish_res.fish_size]
	
	DesktopManager.fishing_game_reeling.connect(check)

func check() -> void:
	if checked: return
	if !DesktopManager.fishing_compendium.has(fish_res): return
	
	var shader: ShaderMaterial = fish_sprite.material
	shader.set_shader_parameter("enabled", false)
	
	fish_name.text = fish_res.fish_name
	
	checked = true
