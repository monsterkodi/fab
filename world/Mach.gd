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
    
    match type:
            Type.Root:    return "Root"
            Type.Prism:   return "Prism"
            Type.Storage: return "Storage"
            _:            return "Invalid"
    
func typeForString(string):
    
    match string:
        "Root":    return Type.Root
        "Prism":   return Type.Prism
        "Storage": return Type.Storage
        _:         return Type.Invalid
