class_name MachineSorter
extends Machine

var slotItems = [-1, -1, -1]

func _init(p, o):
    
    super._init(Mach.Type.Sorter, p, o)
    
func slotIndexForItem(item):
    
    return item.type % 3

func consumeItemAtSlit(item, slit):
    
    var index = slotIndexForItem(item)
    if slotItems[index] < 0:
        slotItems[index] = item.type
        return true
    return false
    
func produceItemAtSlot(slot):
    
    var index = slots.find(slot)
    if slotItems[index] >= 0:
        var item = Item.Inst.new(slotItems[index])
        slotItems[index] = -1
        return item
    return null
