extends Node2D

onready var bar = $Bar
onready var background = $Background

func set_fraction(fraction: float) -> void:
	bar.rect_size[0] = background.rect_size[0] * fraction
