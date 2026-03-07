class_name MachineRoot
extends Machine

func _init(p, o):
    
    super._init(Mach.Type.Root, p, o)
    
func produceItemAtSlot(slot):
    
    return Item.Inst.new(Item.Type.CubeBlack)
