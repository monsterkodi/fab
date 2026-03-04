extends MeshInstance3D

func _process(delta: float) -> void:
    
    transform = transform.rotated(Vector3.UP, delta)
