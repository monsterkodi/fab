class_name IconHandler
extends Control

func _ready():
    
    if not is_visible_in_tree(): return

    if not DirAccess.dir_exists_absolute("res://icons/buildings/"):
        DirAccess.make_dir_recursive_absolute("res://icons/buildings/")
    
    %Viewport.get_node("Camera").look_at(Vector3.ZERO)
    
    for res in Utils.resourcesInDir("res://buildings/"):    
        generateIcon(res, "res://icons/buildings/")
        
func get_full_aabb(node: Node3D) -> AABB:
    
    var total_aabb: AABB = AABB()
    var found_first_mesh = false

    var stack = [node]
    while stack.size() > 0:
        var current = stack.pop_back()
        
        if current is VisualInstance3D:
            var local_aabb = current.get_aabb()
            
            var reltrans = node.global_transform.affine_inverse() * current.global_transform
            var world_aabb = reltrans * local_aabb
            
            if not found_first_mesh:
                total_aabb = world_aabb
                found_first_mesh = true
            else:
                total_aabb = total_aabb.merge(world_aabb)
        
        stack.append_array(current.get_children())
        
    return total_aabb    
    
func frame_camera_on_item(camera: Camera3D, item: Node3D):
    
    var aabb   = get_full_aabb(item)
    var center = aabb.get_center()
    var length = aabb.size.length()
    length = maxf(aabb.size.z, maxf(aabb.size.x, aabb.size.y))
    
    var distance = (length / 2.0) / tan(deg_to_rad(camera.fov) / 2.0)
    
    distance *= 1.4
    
    camera.position = center + Vector3(-1, 1, 1).normalized() * distance
    camera.look_at(center)        

func generateIcon(itemRes : PackedScene, path: String):

    var container = %Container.duplicate()
    var viewport = container.get_node("Viewport")
    var item : Node3D = itemRes.instantiate()
    var camera : Camera3D  = viewport.get_node("Camera")

    viewport.add_child(item)
    %Grid.add_child(container)

    frame_camera_on_item(camera, item)
    
    await RenderingServer.frame_post_draw # wait for the frame to render
    
    var iconPath = path + item.name + ".png"
    var error = viewport.get_texture().get_image().save_png(iconPath)
    if error != OK:
        push_error("Failed to save icon: ", error, iconPath)
    else:
        print("icon: ", iconPath)
