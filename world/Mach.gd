extends Node
# singleton Mach

enum Type {
    Invalid,
    Root,
    Prism,
    Storage,
}

var Class = [
    null, 
    MachineRoot,
    MachinePrism,
    MachineStorage,
]

func stringForType(type):
    
    var s
    match type:
            Type.Root:    s = "Root"
            Type.Prism:   s = "Prism"
            Type.Storage: s = "Storage"
            _:            s = "Invalid"

    return s
    
func typeForString(string):
    
    var t
    match string:
        "Root":    t = Type.Root
        "Prism":   t = Type.Prism
        "Storage": t = Type.Storage
        _:         t = Type.Invalid
    return t
