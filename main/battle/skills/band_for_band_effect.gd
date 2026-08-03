extends Node3D

@onready var beam: MeshInstance3D = $BeamMesh


func play():
	beam.show()
	beam.scale = Vector3(1.0, 1.0, 1.0)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_parallel(true)
	tween.tween_property(beam, "scale:x", 0.0, 1.0).from(1.0)
	tween.tween_property(beam, "scale:z", 0.0, 1.0).from(1.0)
