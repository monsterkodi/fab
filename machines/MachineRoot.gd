class_name MachineRoot
extends Machine

func _init(p, o):
    
    type  = Mach.Type.Root
    slots = Mach.slotsForType(type)
    
    super._init(p, o)
    
func produceItemAtSlot(slot):
    
    return Item.Inst.new(Item.Type.CubeBlack)
