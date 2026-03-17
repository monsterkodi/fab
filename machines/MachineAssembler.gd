class_name MachineAssembler
extends Machine

var recipe
var consumed = [0, 0, 0]
var producing = false
var canProduce = false
var elapsed = 0

func _init(t, p, o):
    
    recipe = Mach.recipeForType(t)
    super._init(t, p, o) 
    
func saveData(): return super.saveData() + [consumed, canProduce, producing, elapsed]
func loadData(d): 
    consumed   = d[4]
    canProduce = d[5]
    producing  = d[6]
    elapsed    = d[7]
    
func consumeItemAtSlit(item, slit):

    for index in recipe.in.size():
        if item.type == recipe.in[index][0] and consumed[index] < recipe.in[index][1]:
            consumed[index] += 1
            checkProducing()
            return true
    return false
    
func checkProducing():
    
    for index in recipe.in.size():
        if consumed[index] < recipe.in[index][1]:
            canProduce = false
            return
    canProduce = true
    
func produce(delta:float):
    
    if not producing and canProduce:
        producing  = true
        elapsed    = 0.0
        canProduce = false
        for i in recipe.in.size():
            consumed[i] -= recipe.in[i][1]
    if producing:
        elapsed += delta
        if elapsed < recipe.time:
            rotateGear(-deg_to_rad(delta * 360 / 16))
    super.produce(delta)
    
func produceItemAtSlot(slot):
    
    if not producing: return null
    if elapsed < recipe.time: return null
    elapsed   = 0.0
    producing = false
    
    if recipe.out[0].size() == 2:
        return Item.Inst.new(recipe.out[0][0])
    else:
        var r = randf()
        for i in range(1, recipe.out[0].size(), 2):
            if r <= recipe.out[0][i]:
                return Item.Inst.new(recipe.out[0][i-1])

func rotateGear(delta: float):
    
    if bdg:
        bdg.modules[9].trans = bdg.modules[9].trans.rotated_local(Vector3.UP, delta)
        mst.add(bdg)
