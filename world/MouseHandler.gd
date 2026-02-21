extends Control

func _gui_input(event: InputEvent):
    
    if get_tree().paused: return
    
    if event is not InputEventMouseMotion and event is not InputEventMouseButton: return
    
    var cam = get_node("/root/World/Camera")
            
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
                
        elif event.button_index == 2:
            
            if event.pressed:
                Post.pointerCancel.emit(ipos)
                
