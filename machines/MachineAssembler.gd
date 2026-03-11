class_name MachineAssembler
extends Machine

var recipe = {"in": [[Item.Type.CubeRed, 2], [Item.Type.CubeGreen, 2], [Item.Type.CubeBlue, 2]], "out": Item.Type.CubeCross, "time": 6.0}
var consumed = [0, 0, 0]
var producing = false
var elapsed = 0

func _init(p, o):
    
    super._init(Mach.Type.Assembler, p, o) 
    
func consumeItemAtSlit(item, slit):
    
    if producing: return false
    for index in range(recipe.in.size()):
        if item.type == recipe.in[index][0] and consumed[index] < recipe.in[index][1]:
            consumed[index] += 1
            checkProducing()
            return true
    return false
    
func checkProducing():
    
    for index in range(recipe.in.size()):
        if consumed[index] < recipe.in[index][1]:
            producing = false
            return
    producing = true
    
func produce(delta:float):
    
    if producing:
        elapsed += delta
        if elapsed < recipe.time:
            rotate(-deg_to_rad(delta * 360 / 16))
    super.produce(delta)
    
func produceItemAtSlot(slot):
    
    if not producing: return false
    if elapsed < recipe.time: return false
    elapsed   = 0.0
    consumed  = [0, 0, 0]
    producing = false
    return Item.Inst.new(recipe.out)

func rotate(delta: float):
    
    if bdg:
        bdg.modules[9].trans = bdg.modules[9].trans.rotated_local(Vector3.UP, delta)
        mst.add(bdg)
