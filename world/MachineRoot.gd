class_name MachineRoot
extends Machine

func _ready():
    
    type  = Mach.Type.Root
    slots = [
        {"pos": Belt.NEIGHBOR[Belt.E], "type": Belt.E},
        {"pos": Belt.NEIGHBOR[Belt.S], "type": Belt.S},
        {"pos": Belt.NEIGHBOR[Belt.W], "type": Belt.W},
        {"pos": Belt.NEIGHBOR[Belt.N], "type": Belt.N},
        ]
    
    super._ready()
    
    
