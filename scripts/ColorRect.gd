extends ColorRect

var size
var mat

var screenshot_count = 0

var draggable = false

# Called when the node enters the scene tree for the first time.
func _ready():
	size = get_viewport().size
	
	mat = self.get_material()
	var width = mat.get_shader_param("x_range_max") - mat.get_shader_param("x_range_min")
	var factor = size.y/size.x
	
	mat.set_shader_param("y_range_min", 
		-factor * width *0.5
	)
	
	mat.set_shader_param("y_range_max",
		factor * width *0.5
	)
	
	resize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	size = get_viewport().size
	resize()


func _input(event):
	# increase/decrease iterations
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_PLUS:
			details(+10)
		if event.scancode == KEY_MINUS:
			details(-10)
		if event.scancode == KEY_F:
			screenshot("screenshot_%06d.png" % screenshot_count)
	
	# zoom in/out
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_UP:
		zoom(+1.1)
	if event is InputEventMouseButton and event.button_index == BUTTON_WHEEL_DOWN:
		zoom(-1.1)
		
	
	# make canvas draggable if left mouse button is pressed
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		draggable = event.is_pressed()
	
	# move canvas on drag
	if event is InputEventMouseMotion:
		var mouse = event.relative
		if draggable:
			var xrange = mat.get_shader_param("x_range_max") - mat.get_shader_param("x_range_min")
			var yrange = mat.get_shader_param("y_range_max") - mat.get_shader_param("y_range_min")
			move(-xrange/size.x * mouse[0], -yrange/size.y * mouse[1]) # convert relative mosue movement (px) to range change on canvas


func move(x, y):
	mat.set_shader_param("x_range_min",
		mat.get_shader_param("x_range_min") + x
	)
	mat.set_shader_param("x_range_max",
		mat.get_shader_param("x_range_max") + x
	)
	
	mat.set_shader_param("y_range_min",
		mat.get_shader_param("y_range_min") + y
	)
	mat.set_shader_param("y_range_max",
		mat.get_shader_param("y_range_max") + y
	)


func zoom(factor):
	var xcenter = 0.5*(mat.get_shader_param("x_range_max") + mat.get_shader_param("x_range_min"))
	var ycenter = 0.5*(mat.get_shader_param("y_range_max") + mat.get_shader_param("y_range_min"))
	var dx = mat.get_shader_param("x_range_max") - xcenter
	var dy = mat.get_shader_param("y_range_max") - ycenter
	
	if factor > 0:
		mat.set_shader_param("x_range_max", xcenter + dx/factor)
		mat.set_shader_param("x_range_min", xcenter - dx/factor)
		mat.set_shader_param("y_range_max", ycenter + dy/factor)
		mat.set_shader_param("y_range_min", ycenter - dy/factor)
	else:
		mat.set_shader_param("x_range_max", xcenter + dx*factor)
		mat.set_shader_param("x_range_min", xcenter - dx*factor)
		mat.set_shader_param("y_range_max", ycenter + dy*factor)
		mat.set_shader_param("y_range_min", ycenter - dy*factor)


func details(amount):
	# increase/decrease iterations
	var new = mat.get_shader_param("iterations") + amount
	if new > 0:
		mat.set_shader_param("iterations", new)
	# alternative: set to max(1, new)


func screenshot(filename):
	get_viewport().get_texture().get_data().save_png(filename)


func resize():
	self.margin_right = size.x
	self.margin_bottom = size.y
