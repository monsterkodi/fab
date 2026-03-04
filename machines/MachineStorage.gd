class_name MachineStorage
extends Machine

func _init(p, o):
    
    type  = Mach.Type.Storage
    slits = Mach.slitsForType(type)
     
    super._init(p, o) 
    
func consumeItemAtSlit(item, slit): 
    
    fab.storage.addItem(item.type)
    return true
    
