extends Node3D
class_name MouseEntered

var collision_object : CollisionObject3D

func _enter_tree():
    
    var pt = get_parent_node_3d()
    for child in pt.get_children():
        if child is CollisionObject3D:
            collision_object = child
            collision_object.connect("mouse_entered", on_mouse_entered)
            collision_object.connect("mouse_exited",  on_mouse_exited)
            break

func on_mouse_entered():
    
    #Log.log("mouse entered", collision_object)
    var pt = get_parent_node_3d()
    #if pt is MeshInstance3D:
        #pt.material_overlay = outline_material

func on_mouse_exited():
    
    #Log.log("mouse exited", collision_object)
    var pt = get_parent_node_3d()
    if pt is MeshInstance3D:
        pt.material_overlay = null
        
