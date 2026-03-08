class_name MachineRoot
extends Machine

func _init(p, o):
    
    super._init(Mach.Type.Root, p, o)
    
func produceItemAtSlot(slot):
    
    return Item.Inst.new(Item.Type.CubeBlack)
    
func _process(delta: float):
    
    if bdg:
        bdg.modules[9].trans = bdg.modules[9].trans.rotated(Vector3.UP, delta)
        mst.add(bdg)
