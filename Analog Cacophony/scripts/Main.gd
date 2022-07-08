extends Node2D

onready var cacophony = $Cacophony

func _ready() -> void:
	cacophony.start()
