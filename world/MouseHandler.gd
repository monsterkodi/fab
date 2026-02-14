extends Control

func _input(event: InputEvent):

    if event is InputEventMouseMotion:
        
        var cam = get_node("/root/World/Camera")
             
        #var cam : Camera3D = camera.freeFlight
            
        %RayCast3D.global_position = cam.get_pos()
        %RayCast3D.target_position = cam.get_pos() + cam.freeFlight.project_ray_normal(event.position) * 1000
        %RayCast3D.force_raycast_update()
        var collider = %RayCast3D.get_collider()
        if collider:
            if collider.name == "Floor":
                var pos = %RayCast3D.get_collision_point()
                Post.pointerHover.emit(Vector2i(round(pos.x), round(pos.z)))
                
