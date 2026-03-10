class_name MachineBurner
extends Machine

var consumedEnergy = 0

func _init(p, o):
    
    super._init(Mach.Type.Burner, p, o) 
    
func consumeItemAtSlit(item, slit): 
    
    if consumedEnergy >= 1.0: return false
    var itemEnergy = Item.energyForType(item.type)
    rotate(-deg_to_rad(itemEnergy * 360 / 16))
    consumedEnergy += itemEnergy
    return true
    
func produceItemAtSlot(slot):
    
    if consumedEnergy < 1: return false
    consumedEnergy -= 1
    return Item.Inst.new(slot.item)

func rotate(delta: float):
    
    if bdg:
        bdg.modules[5].trans = bdg.modules[5].trans.rotated_local(Vector3.UP, delta)
        mst.add(bdg)
