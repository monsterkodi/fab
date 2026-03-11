class_name MachineRoot
extends Machine

func _init(p, o):
    
    super._init(Mach.Type.Root, p, o)
    
func produceItemAtSlot(slot):
    
    return Item.Inst.new(Item.Type.CubeBlack)
    
func consume(delta:float):
    
    if bdg:
        var origin = bdg.modules[9].trans.origin
        bdg.modules[9].trans.origin = Vector3.ZERO
        bdg.modules[9].trans = bdg.modules[9].trans.rotated(Vector3.UP, delta)
        bdg.modules[9].trans.origin = origin
        mst.add(bdg)
