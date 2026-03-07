class_name MachineStorage
extends Machine

func _init(p, o):
    
    super._init(Mach.Type.Storage, p, o) 
    
func consumeItemAtSlit(item, slit): 
    
    fab.storage.addItem(item.type)
    return true
    
