class_name MachineRoot
extends Machine

func _ready():
    
    type  = Mach.Type.Root
    slots = [
        {"pos": Belt.NEIGHBOR[Belt.E], "dir": Belt.E},
        {"pos": Belt.NEIGHBOR[Belt.S], "dir": Belt.S},
        {"pos": Belt.NEIGHBOR[Belt.W], "dir": Belt.W},
        {"pos": Belt.NEIGHBOR[Belt.N], "dir": Belt.N},
        ]
    
    super._ready()
    
    
