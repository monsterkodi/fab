class_name MachineMixer
extends Machine

var consumed = [false, false, false]

func _init(p, o):
    
    super._init(Mach.Type.Mixer, p, o)
    
func consumeItemAtSlit(item, slit):
    
    var slitIndex = slits.find(slit)
    if consumed[slitIndex]: return false
    consumed[slitIndex] = true
    return true
    
func produceItemAtSlot(slot):
    
    if not consumed[0] or not consumed[1] or not consumed[2]: return false
    consumed = [false, false, false]
    return Item.Inst.new(Item.Type.CubeWhite)
        
