class_name MachinePrism
extends Machine

var canProduce = false

func _init():
    
    type  = Mach.Type.Prism
    slots = Mach.slotsForType(type)
    slits = Mach.slitsForType(type)
    
func consumeItemAtSlit(item, slit):
    
    if canProduce: return false
    
    for i in range(slots.size()):
        if advanceAtSlotIndex(i) < 0:
            return false
    
    canProduce = true
    return true
    
func produceItemAtSlot(slot):
    
    if not canProduce: return null
    
    var item = ItemState.Item.new()
    item.color = slot.color
    if slot == slots[-1]: canProduce = false
    return item
        
