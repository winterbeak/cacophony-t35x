extends Node2D

onready var animation = $Logo/Animation
onready var text = $Logo/Text
onready var logo = $Logo

const LOGO_NAME_GAP: float = 6.0
const SCALE: float = 4.0

func _ready():
	animation.scale = Vector2(SCALE, SCALE)
	text.scale = Vector2(SCALE, SCALE)
	
	var animation_size: Vector2 = animation.get_sprite_frames().get_frame("default", 0).get_size()
	var screen_size: Vector2 = get_viewport_rect().size
	
	var logo_width: float = (text.texture.get_width() + LOGO_NAME_GAP + animation_size.x)*SCALE
	var logo_height: float = (animation_size.y + 1)*SCALE

	animation.position.x = screen_size.x / 2 - logo_width / 2
	animation.position.y = screen_size.y / 2 - logo_height / 2
	
	text.position.x = animation.position.x + (animation_size.x + LOGO_NAME_GAP)*SCALE
	text.position.y = animation.position.y - 3*SCALE
