extends Node2D

var timer = 0

func _ready():
	# Row 1 position setting
	$ChordComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 4
	$SequenceComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 6
	
	# Row 2 position setting
	$ScaleComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$VolumeComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	$ParityComponent.position.y = Constants.LIGHT_DISTANCE_VERT
	
	$VolumeComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ
	$ParityComponent.position.x = Constants.LIGHT_DISTANCE_HORIZ * 7
	

func _process(delta):
	if timer % 600 == 0:
		$SequenceComponent.activate(3)
	elif timer % 600 == 100:
		$ScaleComponent.activate($ScaleComponent.note_time * 5)
	elif timer % 600 == 200:
		$QueryComponent.activate(3)
	elif timer % 600 == 300:
		$ParityComponent.activate(3)
	elif timer % 600 == 400:
		$ChordComponent.activate(3)
	elif timer % 600 == 500:
		$VolumeComponent.activate(5)
	
	timer += 1
