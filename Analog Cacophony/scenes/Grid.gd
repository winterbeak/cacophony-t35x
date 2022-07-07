extends Node2D

var timer = 0

func _ready():
	$ChordComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$SequenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	$ScaleComponent.position.y = Constants.LIGHT_DISTANCE_VERT

func _process(delta):
	if timer % 600 == 0:
		$SequenceComponent.activate(3)
	elif timer % 600 == 100:
		$ScaleComponent.activate($ScaleComponent.note_time * 5)
	elif timer % 600 == 200:
		$QueryComponent.activate(3)
	elif timer % 600 == 400:
		$ChordComponent.activate(3)
	
	timer += 1
