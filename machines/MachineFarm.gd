class_name MachineFarm
extends MachineAssembler

var fruits = {}
var seeds  = []

func _init(p, o):
    
    super._init(Mach.Type.Farm, p, o)
    
    Post.subscribe(self)
    
func delFruit(p):
    
    if fruits.has(p):
        fruits.erase(p)
        if bdg:
            hide()
            show()

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
                Log.log("seed consumed")
                return true 
    return consm

func produceDelta(delta):

    super.produceDelta(delta)
    
    if elapsed >= recipe.time:

        var p = findPosForPlant()
        if p:
            var t = chooseFruitType()
            addFruitAtPos(p, t)

func chooseFruitType():
    
    if seeds.size():
        var seed = seeds.pop_front()
        if recipe.seed.has(seed):
            return recipe.seed[seed]
    
    var r = randf_range(0.0, recipe.out[0][1] + recipe.out[0][3])
    if r < recipe.out[0][1]: return recipe.out[0][0]
    return recipe.out[0][2]

func addFruitAtPos(p, t):
    
    if bdg:
        var module = fruitModule(p, t)
        bdg.modules.push_back(module)
        bdg.update()
        
    fruits[p] = t
    fab.addFruitAtPos(p, t)
    
func newBuilding():
    
    bdg = super.newBuilding()
    if not fruits.is_empty():
        for fp in fruits:
            bdg.modules.push_back(fruitModule(fp, fruits[fp]))
        bdg.update()
    return bdg
    
func fruitModule(p : Vector2i, t : Item.Type):
    
    var module   = Module.Inst.new(pos)
    module.pos   = Vector3(p.x - pos.x, 1.0, p.y - pos.y)
    module.kind  = Module.Kind.DECO
    module.type  = Module.typeForItemType(t)
    module.basis = Mach.scaleForItemType(t)
    module.color = Item.colorForType(t)
    return module
        
func findPosForPlant():
    
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
    
