class_name MachineStorage
extends Machine

func _init():
    
    type  = Mach.Type.Storage
    
    slits = [
        {"pos": Vector2i(0,0), "dir": Belt.W},
    ]
    
func consumeItemAtSlit(item, slit): 
    
    return true
    
