class_name MachineMixer
extends Machine

var consumed = [false, false, false]

func _init(p, o):
    
    type  = Mach.Type.Mixer
    slots = Mach.slotsForType(type)
    slits = Mach.slitsForType(type)
    
    super._init(p, o)
    
func consumeItemAtSlit(item, slit):
    
    var slitIndex = slits.find(slit)
    if consumed[slitIndex]: return false
    consumed[slitIndex] = true
    return true
    
func produceItemAtSlot(slot):
    
    if not consumed[0] or not consumed[1] or not consumed[2]: return false
    
    var item = Item.Inst.new()
    item.scale = 0.01
    item.color = slot.color
    item.type  = Item.Type.CubeWhite
    consumed = [false, false, false]
    return item
        
