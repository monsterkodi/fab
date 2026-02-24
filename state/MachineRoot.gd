class_name MachineRoot
extends Machine

func _init():
    
    type  = Mach.Type.Root
    slots = Mach.slotsForType(type)
    
func produceItemAtSlot(slot):
    
    var item = Item.new()
    item.color = Color(0.01, 0.01, 0.01)
    return item
