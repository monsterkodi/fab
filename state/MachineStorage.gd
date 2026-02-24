class_name MachineStorage
extends Machine

func _init():
    
    type  = Mach.Type.Storage
    slits = Mach.slitsForType(type)    
    
func consumeItemAtSlit(item, slit): 
    
    return true
    
