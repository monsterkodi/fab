class_name MachState
extends Node3D

@export var isGhost : bool = false
    
class Building:
    
    var modules : Array[Module.Inst]
    var basis   : Basis
    var type    : Mach.Type
    var pos     : Vector2i
    
    func _init(t : Mach.Type, p : Vector2i, b : Basis):
        
        basis = b
        type = t
        pos = p
        
        for mod in Mach.Def[type].mods:
            
            var module = Module.Inst.new(pos)
            
            var isSlot = mod.has("in") or mod.has("out")
            
            if  mod.has("out"): module.kind = Module.Kind.SLOT; module.pos = Vector3(mod.out.x, 0.5, mod.out.y)
            elif mod.has("in"): module.kind = Module.Kind.SLIT; module.pos = Vector3(mod.in.x, 0.5, mod.in.y)
            else:               module.kind = Module.Kind.DECO; module.pos = mod.pos
            
            if mod.has("color"): module.color = mod.color
            elif isSlot:         module.color = COLOR.BUILDING
                
            if mod.has("type"):  module.type = mod.type
            elif isSlot:         module.type = Module.Type.BOX
            
            if mod.has("basis"):   module.basis = mod.basis
            elif mod.has("scale"): module.basis = Basis.from_scale(Vector3(mod.scale, mod.scale, mod.scale))
            elif isSlot:           module.basis = Basis.IDENTITY.rotated(Vector3.UP, deg_to_rad(-90*mod.dir))
            else:                  module.basis = Basis.IDENTITY
            
            modules.push_back(module)
                        
            if isSlot and module.type != Module.Type.TUNNEL_BOX:
                var arrow   = Module.Inst.new(pos)
                arrow.color = COLOR.ARROW
                arrow.type  = Module.Type.ARROW
                arrow.kind  = Module.Kind.ARROW
                if module.kind == Module.Kind.SLIT:
                    arrow.pos   = module.pos + Vector3(0.2, 0.401, 0.0).rotated(Vector3.UP, deg_to_rad(-90*mod.dir))
                    arrow.basis = Basis.IDENTITY.rotated(Vector3.UP, deg_to_rad([180, 90, 0, -90][mod.dir]))
                else:
                    arrow.pos   = module.pos + Vector3(0.5, 0.401, 0.0).rotated(Vector3.UP, deg_to_rad(-90*mod.dir))                    
                    arrow.basis = module.basis
                modules.push_back(arrow)
        
        update()
        
    func update():
        
        for module in modules:
            module.trans = Transform3D(basis * module.basis, Vector3(pos.x, 0.0, pos.y) + basis * module.pos)
                
    func setPos(p : Vector2i):
        
        pos = p
        for module in modules:
            module.bpos = pos
        update()
                
class ModMap:
    
    var map : Dictionary[Vector2i, Array] # building pos to module indices
    var ary : Array[Module.Inst] = []
    var msh : MultiMeshInstance3D
    var hdl
    
    func add(pos : Vector2i, module : Module.Inst):
        if map.has(pos):
            if module.index >= 0 and map[pos].find(module.index) >= 0:
                ary[module.index] = module
                assert(module.bpos == pos)
                hdl.aryChange(self, module)
                return
        module.index = ary.size()
        if not map.has(pos): map[pos] = []
        map[pos].push_back(module.index)
        ary.push_back(module)
        assert(msh.multimesh.visible_instance_count == module.index)
        msh.multimesh.visible_instance_count += 1
        assert(msh.multimesh.visible_instance_count == ary.size())
        hdl.aryChange(self, module)
            
    func del(pos : Vector2i):
        if not map.has(pos):
            return
        for i in range(map[pos].size()-1, -1, -1):
            var index = map[pos][i]
            var module = ary[index]
            assert(module.index == index)
            if module.index < ary.size()-1: # swap with last
                var lastModule = ary[-1]
                var li = map[lastModule.bpos].find(lastModule.index)
                assert(li >= 0)
                map[lastModule.bpos][li] = module.index
                lastModule.index = module.index
                ary.set(module.index, lastModule)
                hdl.aryChange(self, lastModule)
            ary.pop_back()
            msh.multimesh.visible_instance_count -= 1
            assert(ary.size() == msh.multimesh.visible_instance_count)
        assert(ary.size() == msh.multimesh.visible_instance_count)
        map.erase(pos)
            
    func clear():
        
        map = {}
        ary = []
        msh.multimesh.visible_instance_count = 0
        
var modMap : Array[ModMap] = []

@onready var fab: FabState = $"../FabState"

func _ready():
    
    for typeName in Module.Type:
        add_child(Module.multiMeshForType(Module.Type[typeName], isGhost))
    
    for child in get_children():
        child.multimesh.instance_count = 1000
        child.multimesh.visible_instance_count = 0
        var mm = ModMap.new()
        mm.msh = child
        mm.hdl = self
        modMap.push_back(mm) 
        
func add(building : Building):
    
    for module in building.modules:
        modMap[module.type].add(building.pos, module)
    
func del(building : Building):
    
    for module in building.modules:
        modMap[module.type].del(building.pos)
            
func clear():
    
    for mm in modMap:
        mm.clear()
            
func aryChange(mm : ModMap, module : Module.Inst): 
    
    if mm.msh.multimesh.use_colors:
        mm.msh.multimesh.set_instance_color(module.index, module.color)
    mm.msh.multimesh.set_instance_transform(module.index, module.trans)
    
func setBuildingPos(building, pos):
    
    del(building)
    building.setPos(pos)
    add(building)
    
