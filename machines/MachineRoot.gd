class_name MachineRoot
extends Machine

func _init(p, o):
    
    type  = Mach.Type.Root
    slots = Mach.slotsForType(type)
    
    super._init(p, o)
    
func produceItemAtSlot(slot):
    
    var item = Item.Inst.new()
    item.color = Color(0.01, 0.01, 0.01)
    return item
