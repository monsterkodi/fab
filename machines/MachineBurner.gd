class_name MachineBurner
extends Machine

var consumedEnergy = 0

func _init(p, o):
    
    type  = Mach.Type.Burner
    slits = Mach.slitsForType(type)
    slots = Mach.slotsForType(type)
     
    super._init(p, o) 
    
func consumeItemAtSlit(item, slit): 
    
    if consumedEnergy >= 1.0: return false
    consumedEnergy += Item.energyForType(item.type)
    return true
    
func produceItemAtSlot(slot):
    
    if consumedEnergy < 1: return false
    consumedEnergy -= 1
    return Item.Inst.new(slot.item)
