extends AnimatedSprite2D
class_name VictorSprite

signal died()

@onready var death_particles: GPUParticles2D = %DeathParticles

func death() -> void:
	self_modulate.a = 0.0
	death_particles.emitting = true
	await death_particles.finished
	died.emit()
