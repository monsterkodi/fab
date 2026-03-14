class_name MachState
extends Node3D

@export var isGhost : bool = false

class Module:
    
    enum Type { BOX, ARROW, CUBE, TORUS, SPHERE, CYLINDER, STORAGE, GEAR, FRAME, CUBE_CROSS, CYLINDER_CROSS, TUNNEL_BOX, CUBECULE, MOLECULE }
    enum Kind { NONE, SLIT, SLOT }
    
    func _init(p : Vector2i): 
        bpos = p
    
    var trans : Transform3D
    var color : Color
    var type  : int
    var index : int = -1
    var bpos  : Vector2i
    var kind  : int = Module.Kind.NONE
    
    static func stringForType(t):
        for key in Type:
            if Type[key] == t: return key
        return "???"
    
class Building:
    
    var modules : Array[Module]
    var basis   : Basis
    var type    : Mach.Type
    var pos     : Vector2i
    
    func _init(t : Mach.Type, p : Vector2i, b : Basis):
        
        basis = b
        type = t
        pos = p
        
        var module
        
        for slit in Mach.slitsForType(type):
            module = Module.new(pos)
            module.color = COLOR.BUILDING
            if slit.has("color"):
                module.color = slit.color
            if slit.has("type"):
                module.type  = slit.type
            else:
                module.type  = Module.Type.BOX
            modules.push_back(module)
            
            if module.type != MachState.Module.Type.TUNNEL_BOX:
                module = Module.new(pos)
                module.color = COLOR.ARROW
                module.type  = Module.Type.ARROW
                module.kind  = Module.Kind.SLIT
                modules.push_back(module)
            
        for slot in Mach.slotsForType(type):
            module = Module.new(pos)
            module.color = COLOR.BUILDING
            if slot.has("color"):
                module.color = slot.color
            if slot.has("type"):
                module.type  = slot.type
            else:
                module.type  = Module.Type.BOX
            modules.push_back(module)

            if module.type != MachState.Module.Type.TUNNEL_BOX:
                module = Module.new(pos)
                module.color = COLOR.ARROW
                module.type  = Module.Type.ARROW
                module.kind  = Module.Kind.SLOT
                modules.push_back(module)
            
        for deco in Mach.decosForType(type):
            if deco.has("type"):
                module = Module.new(pos)
                module.type  = deco.type
                if deco.has("color"):
                    module.color = deco.color
                if deco.has("basis"):
                    module.trans = Transform3D(deco.basis, Vector3.ZERO)
                modules.push_back(module)
            
        update()
        
    func update():
        
        var i = 0
        for slit in Mach.slitsForType(type):
            var p = basis * Vector3(slit.pos.x, 0, slit.pos.y)
            modules[i].trans = Mach.boxTrans(slit, p + Vector3(pos.x, 0.5, pos.y), basis)
            if modules[i].type != MachState.Module.Type.TUNNEL_BOX:
                i += 1
                modules[i].trans = Mach.slitArrowTrans(slit, p + Vector3(pos.x, 0.0, pos.y), basis)
            i += 1

        for slot in Mach.slotsForType(type):
            var p = basis * Vector3(slot.pos.x, 0, slot.pos.y)
            modules[i].trans = Mach.boxTrans(slot, p + Vector3(pos.x, 0.5, pos.y), basis)
            if modules[i].type != MachState.Module.Type.TUNNEL_BOX:
                i += 1
                modules[i].trans = Mach.slotArrowTrans(slot, p + Vector3(pos.x, 0.0, pos.y), basis)
            i += 1
            
        for deco in Mach.decosForType(type):
            if deco.has("type"):
                var b = basis
                if deco.has("basis"):
                    b = basis * deco.basis
                modules[i].trans = Transform3D(b, basis * deco.pos + Vector3(pos.x, 0.0, pos.y))
                i += 1
        
    func setPos(p : Vector2i):
        
        pos = p
        for module in modules:
            module.bpos = pos
        update()
                
    func rotate():
        
        basis = basis.rotated(Vector3.UP, deg_to_rad(-90))
        update()
            
class ModMap:
    
    var map : Dictionary[Vector2i, Array] # building pos to module indices
    var ary : Array[Module] = []
    var msh : MultiMeshInstance3D
    var hdl
    
    func add(pos : Vector2i, module : Module):
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
        var type = Module.Type[typeName]
        var mm = MultiMeshInstance3D.new()
        mm.name = typeName
        mm.multimesh = MultiMesh.new()
        var msh
        match type:
            Module.Type.BOX:                msh = MachMeshes.regal(1.0, 1.0, 1.0, 0.2, 0.5)
            Module.Type.ARROW:              msh = MachMeshes.arrow(0.4, 0.2, 0.5)
            Module.Type.CUBE:               msh = BoxMesh.new()
            Module.Type.TORUS:              msh = TorusMesh.new(); msh.outer_radius = 0.5; msh.inner_radius = 0.2; msh.ring_segments = 12; msh.rings = 24
            Module.Type.SPHERE:             msh = SphereMesh.new(); msh.radial_segments = 24; msh.rings = 12
            Module.Type.CYLINDER:           msh = CylinderMesh.new(); msh.height = 1.0; msh.rings = 1; msh.radial_segments = 24
            Module.Type.STORAGE:            msh = MachMeshes.storage(0.8, 0.5) 
            Module.Type.GEAR:               msh = MachMeshes.gear(0.4, 0.1, 0.2, 8, 0.5, 0.5, false)
            Module.Type.FRAME:              msh = MachMeshes.frame(1.0, 1.0, 1.0, 0.2, 0.5)
            Module.Type.CUBE_CROSS:         msh = MachMeshes.cubeCross(0.6, [COLOR.ITEM_RED, COLOR.ITEM_GREEN, COLOR.ITEM_BLUE])
            Module.Type.CYLINDER_CROSS:     msh = MachMeshes.cylinderCross(0.6, 0.15, [COLOR.ITEM_GREEN, COLOR.ITEM_BLUE, COLOR.ITEM_RED])
            Module.Type.TUNNEL_BOX:         msh = MachMeshes.tunnelBox(1.0, 1.0, 1.0, 0.2, 0.5)
            Module.Type.CUBECULE:           msh = MachMeshes.cubecule(0.6, 0.2,  0.2, [COLOR.ITEM_BLACK, COLOR.ITEM_WHITE, COLOR.ITEM_WHITE, COLOR.ITEM_WHITE])
            Module.Type.MOLECULE:           msh = MachMeshes.molecule(0.7, 0.07, 0.14, [COLOR.ITEM_BLACK, COLOR.ITEM_RED,   COLOR.ITEM_GREEN, COLOR.ITEM_BLUE])
        mm.multimesh.mesh = msh
        assert(mm.multimesh.mesh)
        
        if isGhost:
            mm.material_override = preload("uid://cqpqvcb8usfl0")
        else:
            match type:
                Module.Type.STORAGE, \
                Module.Type.FRAME, \
                Module.Type.TUNNEL_BOX, \
                Module.Type.BOX:                mm.material_override =  preload("uid://ci4cvsq2gbob7")       
                Module.Type.ARROW:              mm.material_override =  preload("uid://dc38ipveu0heb")
                _:                              mm.material_override =  preload("uid://bi5n2lthhnyix")
            
        mm.multimesh.transform_format = MultiMesh.TRANSFORM_3D
        match type:
            Module.Type.CUBE_CROSS, \
            Module.Type.CYLINDER_CROSS, \
            Module.Type.CUBECULE, \
            Module.Type.MOLECULE: 
                mm.multimesh.use_colors = false
            _ : mm.multimesh.use_colors = true
        add_child(mm)
    
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
            
func aryChange(mm : ModMap, module : Module): 
    
    if mm.msh.multimesh.use_colors:
        mm.msh.multimesh.set_instance_color(module.index, module.color)
    mm.msh.multimesh.set_instance_transform(module.index, module.trans)
    
func setBuildingPos(building, pos):
    
    del(building)
    building.setPos(pos)
    add(building)
    
func rotateBuilding(building):
    
    #del(building)
    building.rotate()
    add(building)
