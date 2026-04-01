extends FishingItem
class_name FishingItemVictorBait

var hook: FishingHook

func start() -> void:
	hook = get_parent()
	hook.has_victor_bait = true

func end() -> void:
	hook.has_victor_bait = false
	queue_free()

func reel() -> void:
	pass
