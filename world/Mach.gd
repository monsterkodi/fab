extends Node
# singleton Mach

enum Type {
    Invalid,
    Root,
}

var Class = [
    null, 
    MachineRoot,
]

func stringForType(type):
    
    var s
    match type:
            Type.Root: s = "Root"
            _:         s = "Invalid"

    return s
