extends Node2D

var timer = 0

func _process(delta):
	if timer % 600 == 0:
		$SequenceComponent.activate(3)
	timer += 1
