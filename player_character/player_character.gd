extends MeshInstance3D

func _ready():
	name = str(get_multiplayer_authority())
	$Name.text = str(name)

func _physics_process(delta):
	if is_multiplayer_authority():
		var direction:Vector3 = Vector3.ZERO
		
		if Input.is_key_pressed(KEY_W):direction.z -= 1
		if Input.is_key_pressed(KEY_S):direction.z += 1
		if Input.is_key_pressed(KEY_A):direction.x -= 1
		if Input.is_key_pressed(KEY_D):direction.x += 1
		
		global_position += direction.normalized()
		rpc("remote_set_position", global_position)
		
@rpc(unreliable)
func remote_set_position(authority_position):
	global_position = authority_position

@rpc(authority, call_local, reliable, 1)
func display_message(message):
	$Message.text = str(message)
	
@rpc(any_peer, call_local, reliable, 1)
func clicked_by_player():
	$Message.text = str(multiplayer.get_remote_sender_id()) + " clicked on me!"



func _on_mouse_click_area_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		rpc("clicked_by_player")
