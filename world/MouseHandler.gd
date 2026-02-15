extends Control

func _input(event: InputEvent):
    
    if get_tree().paused: return
    
    if event is not InputEventMouseMotion and event is not InputEventMouseButton: return
    
    var cam = get_node("/root/World/Camera")
            
    #%RayCast3D.global_position = cam.freeFlight.project_ray_origin(event.position)
    #%RayCast3D.target_position = %RayCast3D.global_position + cam.freeFlight.project_ray_normal(event.position) * 1000
    #%RayCast3D.force_raycast_update()
    #var collider = %RayCast3D.get_collider()
    #if not collider or collider.name != "Floor": return
    
    #var pos = %RayCast3D.get_collision_point()
    #var ipos = Vector2i(round(pos.x), round(pos.z))

    var ipos : Vector2i
    var mousePos = get_window().get_mouse_position()
    var camera = get_window().get_viewport().get_camera_3d()
    var plane = Plane.PLANE_XZ
    
    var intersect = plane.intersects_ray(camera.project_ray_origin(mousePos), camera.project_ray_normal(mousePos))
    if intersect:
        ipos.x = round(intersect.x)
        ipos.y = round(intersect.z)

    if event is InputEventMouseMotion:
        
            if event.button_mask == 0:
                Post.pointerHover.emit(ipos)
            elif event.button_mask == 1:
                Post.pointerDrag.emit(ipos)
                    
    elif event is InputEventMouseButton:
        #Log.log(event)
        if event.button_index == 1:
            if event.pressed:
                if event.shift_pressed:
                    Post.pointerShiftClick.emit(ipos)
                else:
                    Post.pointerClick.emit(ipos)
            else:
                if event.shift_pressed:
                    Post.pointerShiftRelease.emit(ipos)
                else:
                    Post.pointerRelease.emit(ipos)
        elif event.button_index == 3:
            
            if event.pressed:
                Post.pointerShiftClick.emit(ipos)
            else:
                Post.pointerShiftRelease.emit(ipos)
                
        elif event.button_index == 2:
            
            if event.pressed:
                Post.pointerCancel.emit(ipos)
                
