class_name MachineFarm
extends MachineAssembler

var fruits = {}
var mature = []
var seeds  = []

func _init(p, o):
    
    super._init(Mach.Type.Farm, p, o)
    
    Post.subscribe(self)
    
func delFruit(p):
    
    if fruits.has(p):
        fruits.erase(p)
        fab.delFruitAtPos(p)

func saveData(): 
    
    var fd = []
    for fp in fruits:
        fd.push_back([fp.x, fp.y, fruits[fp]])
    return super.saveData() + [fd]
    
func loadData(d): 
    
    super.loadData(d)
    if d.size() > 8:
        for f in d[8]:
            addFruitAtPos(Vector2i(f[0], f[1]), f[2])

func consumeItemAtSlit(item, slit):
    
    var consm = super.consumeItemAtSlit(item, slit)
    if not consm:
        if slits.find(slit) >= recipe.in.size():
            if seeds.size() < 2:
                seeds.push_back(item.type) 
                return true 
    return consm
    
func produce(delta:float):
    
    for fp in fruits:
        var fruit = fruits[fp]
        if fruit[1] < 1.0:
            fruit[1] = minf(1.0, fruit[1] + delta / recipe.grow)
            fab.scaleFruitAtPos(fp, fruit[1])
            if fruit[1] >= 1.0:
                mature.push_back(fp)                
    super.produce(delta)    

func produceDelta(delta):
        
    super.produceDelta(delta)
    
    if elapsed >= recipe.time:
        elapsed   = 0.0
        producing = false
        var p = findPosForPlant()
        if p:
            addFruitAtPos(p, [chooseFruitType(), 0])

func produceItemAtSlot(slot):
    
    if not mature.is_empty():
        var fp = mature.pop_front()
        var t = fruits[fp][0] 
        delFruit(fp)
        
        if elapsed >= recipe.time:
            elapsed   = 0.0
            producing = false
        
        return Item.Inst.new(t)
    else:
        return super.produceItemAtSlot(slot)

func chooseFruitType():
    
    if seeds.size():
        var seed = seeds.pop_front()
        if recipe.seed.has(seed):
            return recipe.seed[seed]
    
    var r = randf_range(0.0, recipe.out[0][1] + recipe.out[0][3])
    if r < recipe.out[0][1]: return recipe.out[0][0]
    return recipe.out[0][2]

func addFruitAtPos(p, f):
    
    fruits[p] = f
    fab.addFruitAtPos(p, f[0])
    
func findPosForPlant():
    
    if not fruits.is_empty():
        for fp in fruits:
            return searchPosForPlant(fp)
    
    var p = pos + Belt.orientatePos(orientation, Vector2i(-2,0))
    if fab.fruitAtPos(p) < 0 and fab.machineOfTypeAtPos(Mach.Type.Humus, p):
        return p
       
    return searchPosForPlant(p) 
            
func searchPosForPlant(p: Vector2i, visited = {}):
    
    visited[p] = true
    var humus = []
        
    var dirs = [0, 1, 2, 3]
    dirs.shuffle()
    for d in dirs:
        var np = p + Belt.NEIGHBOR[d]
        if fab.machineOfTypeAtPos(Mach.Type.Humus, np):
            if fab.fruitAtPos(np) < 0:
                return np
            else:
                humus.push_back(np)

    for np in humus:
        if visited.has(np): continue
        var fp = searchPosForPlant(np, visited)
        if fp: return fp
        
    return null
    
