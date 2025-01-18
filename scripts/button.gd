extends Button

@onready var default_scale = scale  # Save the original scale
@onready var hover_scale = default_scale * 1.2  # Scale the button by 20% on hover

func _ready() -> void:
	# Center the pivot point
	pivot_offset = size / 2

func _on_mouse_entered() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", hover_scale, 0.2)

func _on_mouse_exited() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", default_scale, 0.2)
