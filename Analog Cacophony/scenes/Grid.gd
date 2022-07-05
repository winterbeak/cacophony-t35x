extends Node2D

var timer = 0

func _ready():
	$SequenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6

func _process(delta):
	if timer % 600 == 0:
		$SequenceComponent.activate(3)
	elif timer % 600 == 200:
		$QueryComponent.activate(3)
	timer += 1
