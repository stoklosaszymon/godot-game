extends Node2D

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(self.queue_free)
