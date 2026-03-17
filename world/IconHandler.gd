class_name IconHandler
extends Control

func _ready():
    
    if not is_visible_in_tree(): return
    
    get_tree().paused = true

    %Viewport.get_node("Camera").look_at(Vector3.ZERO)

    if not DirAccess.dir_exists_absolute("res://icons/buildings/"):
        DirAccess.make_dir_recursive_absolute("res://icons/buildings/")

    if not DirAccess.dir_exists_absolute("res://icons/machines/"):
        DirAccess.make_dir_recursive_absolute("res://icons/machines/")

    if not DirAccess.dir_exists_absolute("res://icons/items/"):
        DirAccess.make_dir_recursive_absolute("res://icons/items/")
        
    #for res in Utils.resourcesInDir("res://buildings/"):
        #if res is PackedScene: 
            #generateIcon(res, "res://icons/buildings/")

    Post.subscribe(self)
    
func levelStart():
            
    for type in Item.Types:
        generateItemIcon(type)
        await RenderingServer.frame_post_draw
            
    for type in Mach.Types:
        if type:
            generateMachineIcon(type)
            await RenderingServer.frame_post_draw
                    
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
    
func frame_camera(camera: Camera3D, item: Node3D):
    
    var aabb   = get_full_aabb(item)
    var center = aabb.get_center()
    var length = aabb.size.length()
    var distance = (length / 2.0) / tan(deg_to_rad(camera.fov) / 2.0)
    
    distance *= 1.1
    
    camera.position = center + Vector3(-1, 1, 1).normalized() * distance
    camera.look_at(center)        

func generateIcon(itemRes : PackedScene, path: String):

    var container = %Container.duplicate()
    var viewport = container.get_node("Viewport")
    var item : Node3D = itemRes.instantiate()
    var camera : Camera3D  = viewport.get_node("Camera")

    viewport.add_child(item)
    %Grid.add_child(container)

    frame_camera(camera, item)
    
    await RenderingServer.frame_post_draw # wait for the frame to render
    
    var iconPath = path + itemRes.resource_path.get_file().get_basename() + ".png"
    var error = viewport.get_texture().get_image().save_png(iconPath)
    if error != OK:
        push_error("Failed to save icon: ", error, iconPath)
    else:
        print("icon: ", iconPath)

func frame_camera_on_machine(camera: Camera3D, item: Node3D, type : Mach.Type):
    
    var aabb   = get_full_aabb(item)
    var center = aabb.get_center()
    var length = aabb.size.length()
    length = (maxf(aabb.size.z, maxf(aabb.size.x, aabb.size.y)) + length)/2
    #Log.log(length, aabb.size.length(), item.scene_file_path)
    var distance = (length / 2.0) / tan(deg_to_rad(camera.fov) / 2.0)
    
    distance *= 1.1
    
    camera.position = center + Vector3(0, 0.5, 0.2).normalized() * distance
    
    match type:
        Mach.Type.Root : center.y -= 1
    
    camera.look_at(center)        

func generateMachineIcon(type : Mach.Type):

    var container = %Container.duplicate()
    var viewport = container.get_node("Viewport")
    var camera : Camera3D  = viewport.get_node("Camera")

    %Grid.add_child(container)
    var level = Utils.level()
    var oldParent = level.get_parent()
    oldParent.remove_child(level)
    viewport.add_child(level)
    level.get_node("Floor").hide()
    
    var fab : FabState = level.get_node("FabState")
    
    fab.addMachineAtPosOfType(Vector2i.ZERO, type)
    
    if type == Mach.Type.Counter:
        fab.machines[Vector2i.ZERO].gauge.setFactor(0.666)

    frame_camera_on_machine(camera, fab.mst, type)
    
    await RenderingServer.frame_post_draw # wait for the frame to render
    
    var iconPath = "res://icons/machines/" + Mach.stringForType(type) + ".png"
    var error = viewport.get_texture().get_image().save_png(iconPath)
    if error != OK:
        push_error("Failed to save icon: ", error, iconPath)
    else:
        print("icon: ", iconPath)

    fab.delMachineAtPos(Vector2i.ZERO)
    viewport.remove_child(level)
    oldParent.add_child(level)
    level.get_node("Floor").show()
    
func frame_camera_on_item(camera: Camera3D, type : Item.Type):
    
    var center = Vector3.ZERO
    camera.position = center + Vector3(1, 1, 1).normalized() * 1.75
    camera.look_at(center)        
    
func generateItemIcon(type : Item.Type):

    var container = %Container.duplicate()
    var viewport = container.get_node("Viewport")
    var camera : Camera3D  = viewport.get_node("Camera")

    %Grid.add_child(container)
    var level = Utils.level()
    var oldParent = level.get_parent()
    oldParent.remove_child(level)
    viewport.add_child(level)
    level.get_node("Floor").hide()
    level.get_node("TrackState").hide()
    var fab : FabState = level.get_node("FabState")
    
    var item = Item.Inst.new(type)
    item.scale = -1
    fab.addItem(Vector2.ZERO, Belt.W, item)

    frame_camera_on_item(camera, type)
    
    await RenderingServer.frame_post_draw # wait for the frame to render
    
    var iconPath = "res://icons/items/" + Item.stringForType(type) + ".png"
    var error = viewport.get_texture().get_image().save_png(iconPath)
    if error != OK:
        push_error("Failed to save icon: ", error, iconPath)
    else:
        print("icon: ", iconPath)

    fab.delItemsAtPos(Vector2.ZERO)
    viewport.remove_child(level)
    oldParent.add_child(level)
    level.get_node("Floor").show()
    level.get_node("TrackState").show()
