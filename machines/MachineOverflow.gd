class_name MachineOverflow
extends Machine

var slotItems = [-1, -1]

func _init(p, o):
    
    super._init(Mach.Type.Overflow, p, o)
    
func consumeItemAtSlit(item, slit):
    
    if slotItems[0] < 0:
        slotItems[0] = item.type
        return true
    if slotItems[1] < 0:
        slotItems[1] = item.type
        return true
    return false
    
func produceItemAtSlot(slot):
    
    var index = slots.find(slot)
    if slotItems[index] >= 0:
        var item = Item.Inst.new(slotItems[index])
        slotItems[index] = -1
        if index == 0 and slotItems[1] >= 0:
            slotItems[0] = slotItems[1]
            slotItems[1] = -1
        return item
    return null
