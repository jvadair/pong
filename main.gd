extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction = Vector2(-1.0, 0.0)
const INITIAL_BALL_SPEED = 150
var ball_speed = INITIAL_BALL_SPEED
var points_l = 0
var points_r = 0
var screen_size
var bar_size
var ball_height
var bar_height


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	# Get the scaled ball size
	ball_height = get_node("Ball/Sprite").texture.get_height() * get_node("Ball/Sprite").scale.y
	bar_height = get_node("LeftBar/Sprite").texture.get_height() * get_node("LeftBar/Sprite").scale.y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var ball_pos = get_node("Ball").position
	get_node("Ball").position += direction * ball_speed * delta
	# If anyone scored
	if (ball_pos.x < 0 or ball_pos.x > screen_size.x):
		update_scores(ball_pos.x)
		get_node("Ball").position = screen_size*0.5  # Place in the center
		ball_speed = INITIAL_BALL_SPEED  # Reset speed
		direction = Vector2(get_random([-1, 1]), 0)  # Reset to random left/right direction
	# Flip when touching roof or floor, account for ball size
	elif ((ball_pos.y < ball_height/2 and direction.y < 0) or (ball_pos.y > screen_size.y - ball_height/2 and direction.y > 0)):
		direction.y = -direction.y
	
	# User input
	for b in ["LeftBar", "RightBar"]:
		print(get_node(b).position.y)
		if (get_node(b).position.y < screen_size.y - bar_height/2) and (Input.is_action_pressed(b + "_down")):  # Down
			get_node(b).position.y += 10
		elif (get_node(b).position.y > bar_height/2) and (Input.is_action_pressed(b + "_up")):  # Up
			get_node(b).position.y -= 10

func touching_bar(body):
	direction.x = -direction.x  # From left to right and vice versa
	direction.y = randf()*2.0 - 1  # Random angle
	direction = direction.normalized()  # Make length of vector 1
	ball_speed *= 1.2  # Game gets progressively harder
	
func get_random(list_obj):
	return list_obj[randi() % list_obj.size()]  # The remainder can be between 0 and list.size()

func update_scores(ball_pos):
	if ball_pos < 0:
		points_r += 1
		get_node("ScoreRight").bbcode_text = "[center]" + str(points_r)
	else:
		points_l += 1
		get_node("ScoreLeft").bbcode_text = "[center]" + str(points_l)
	
	
	# TODO: Update score labels
