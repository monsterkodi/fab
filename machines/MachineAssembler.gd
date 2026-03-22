class_name MachineAssembler
extends Machine

var recipe
var consumed   = [0, 0, 0]
var producing  = false
var canProduce = false
var elapsed    = 0
var gearIndex  = -1

func _init(t, p, o):
    
    recipe    = Mach.recipeForType(t)
    gearIndex = Mach.indexOfModule(t, Module.Type.GEAR)
    super._init(t, p, o) 
    
func saveData(): return super.saveData() + [consumed, canProduce, producing, elapsed]
func loadData(d): 
    if d.size() > 4:
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
        produceDelta(delta)
            
    super.produce(delta)
    
func produceDelta(delta):
    
    elapsed += delta
    if elapsed < recipe.time:
        rotateGear(-deg_to_rad(delta * 360 / 16))
    
func produceItemAtSlot(slot):
    
    if not producing: return null
    if elapsed < recipe.time: return null
    elapsed   = 0.0
    producing = false
    
    if recipe.out[0].size() == 2:
        return Item.Inst.new(recipe.out[0][0])
    else:
        var item = chooseOutItemType()
        if item >= 0:
            return Item.Inst.new(item)
        
func chooseOutItemType():
    
    var r = randf()
    for i in range(1, recipe.out[0].size(), 2):
        if r <= recipe.out[0][i]:
            return recipe.out[0][i-1]
        r -= recipe.out[0][i]
    return -1

func rotateGear(delta: float):
    
    if bdg and gearIndex >= 0:
        bdg.modules[gearIndex].trans = bdg.modules[gearIndex].trans.rotated_local(Vector3.UP, delta)
        mst.add(bdg)
