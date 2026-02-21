class_name MachineStorage
extends Machine

func _ready():
    
    type  = Mach.Type.Storage
    
    slits = [
        {"pos": Belt.NEIGHBOR[Belt.W], "dir": Belt.W},
    ]
    
    super._ready()
    
func consumeItemAtSlit(item, slit): return true
    
