class_name MachineTunnel
extends Machine

var items : Array[Item.Type] = []

func _init(p, o):
    
    super._init(Mach.Type.Tunnel, p, o)
    
func consumeItemAtSlit(item, slit):
    
    if items.size() < 6:
        items.push_back(item.type)
        return true
    return false
    
func produceItemAtSlot(slot):
    
    if items.size():
        return Item.Inst.new(items.pop_front())
    return null
    
