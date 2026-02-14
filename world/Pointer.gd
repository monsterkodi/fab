extends Node3D

func _ready():
    
    Post.pointerHover.connect(onPointerHover)
    
func onPointerHover(pos):
    
    get_tree().root.get_node("/root/World/MousePointer").global_position.x = round(pos.x)
    get_tree().root.get_node("/root/World/MousePointer").global_position.z = round(pos.y)
