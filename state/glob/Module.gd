extends Node
# singleton Module

enum Type { 
    BOX, 
    TUNNEL_BOX, 
    FRAME, 
    ARROW, 
    STORAGE, 
    GEAR, 
    TREE_BRANCH,
    TREE_CANOPY,
    TORUS_QUARTER,
    CUBE, 
    CYLINDER, 
    SPHERE, 
    TORUS, 
    CUBECROSS, 
    TUBECROSS, 
    CUBECULE, 
    MOLECULE,
    ICOSAEDER, 
    DODECAEDER, 
    }
    
enum Kind { NONE, SLIT, SLOT, ARROW_IN, ARROW_OUT, DECO }

class Inst:
    
    var type  : Type
    var kind  : Kind = Kind.NONE
    var basis : Basis
    var trans : Transform3D
    var color : Color
    var index : int = -1
    var bpos  : Vector2i
    var pos   : Vector3
    
    func _init(p : Vector2i): bpos = p
    
func colorsForType(type : Type, isGhost : bool):
    
    if isGhost:
        var cw = Color.WHITE
        match type:
            Module.Type.CUBECROSS, \
            Module.Type.TUBECROSS: return [cw, cw, cw]
            Module.Type.CUBECULE, \
            Module.Type.MOLECULE:  return [cw, cw, cw, cw]
    else: 
        match type:  
            Module.Type.CUBECROSS: return [COLOR.ITEM_RED,   COLOR.ITEM_GREEN, COLOR.ITEM_BLUE]
            Module.Type.TUBECROSS: return [COLOR.ITEM_GREEN, COLOR.ITEM_BLUE,  COLOR.ITEM_RED]
            Module.Type.CUBECULE:  return [COLOR.ITEM_BLACK, COLOR.ITEM_WHITE, COLOR.ITEM_WHITE, COLOR.ITEM_WHITE]
            Module.Type.MOLECULE:  return [COLOR.ITEM_BLACK, COLOR.ITEM_RED,   COLOR.ITEM_GREEN, COLOR.ITEM_BLUE]
        
func meshForType(type : Type, isGhost : bool):
    
    var mesh
    match type:
        Module.Type.BOX:                mesh = MachMeshes.regal(1.0, 1.0, 1.0, 0.2, 0.5)
        Module.Type.FRAME:              mesh = MachMeshes.frame(1.0, 1.0, 1.0, 0.2, 0.5)
        Module.Type.TUNNEL_BOX:         mesh = MachMeshes.tunnelBox(1.0, 1.0, 1.0, 0.2, 0.5)
        Module.Type.ARROW:              mesh = MachMeshes.arrow(0.4, 0.2, 0.5)
        Module.Type.GEAR:               mesh = MachMeshes.gear(0.4, 0.1, 0.2, 7, 0.5, 0.5, false)
        Module.Type.STORAGE:            mesh = MachMeshes.storage(0.8, 0.5) 
        Module.Type.TREE_BRANCH:        mesh = MachMeshes.treeBranch(0.5, 1, 0.5, 0.5)
        Module.Type.TREE_CANOPY:        mesh = MachMeshes.treeCanopy(1.6, 0.8, 0.6) 
        Module.Type.CUBE:               mesh = BoxMesh.new()
        Module.Type.TORUS:              mesh = TorusMesh.new(); mesh.outer_radius = 0.5; mesh.inner_radius = 0.2; mesh.ring_segments = 12; mesh.rings = 24
        Module.Type.SPHERE:             mesh = SphereMesh.new(); mesh.radial_segments = 24; mesh.rings = 12
        Module.Type.CYLINDER:           mesh = CylinderMesh.new(); mesh.height = 1.0; mesh.rings = 1; mesh.radial_segments = 24
        Module.Type.CUBECROSS:          mesh = MachMeshes.cubeCross(1.0,           colorsForType(type, isGhost))
        Module.Type.TUBECROSS:          mesh = MachMeshes.cylinderCross(1.0, 0.25, colorsForType(type, isGhost))
        Module.Type.CUBECULE:           mesh = MachMeshes.cubecule(1.0, 0.3,  0.3, colorsForType(type, isGhost))
        Module.Type.MOLECULE:           mesh = MachMeshes.molecule(1.0, 0.1, 0.21, colorsForType(type, isGhost))
        Module.Type.ICOSAEDER:          mesh = Polyhedron.icosahedron(0.5)
        Module.Type.DODECAEDER:         mesh = Polyhedron.dodecahedron(0.5)
        Module.Type.TORUS_QUARTER:      mesh = MachMeshes.torus(0.5, 0.4, 24, 8, 0, 6)
    return mesh
    
func multiMeshForType(type : Type, isGhost : bool):
    
    var mm = MultiMeshInstance3D.new()
    mm.name = stringForType(type)
    mm.multimesh = MultiMesh.new()
    mm.multimesh.mesh = meshForType(type, isGhost)
    assert(mm.multimesh.mesh)
    
    if isGhost:
        mm.material_override = preload("uid://cqpqvcb8usfl0")
    else:
        match type:
            Module.Type.STORAGE, \
            Module.Type.FRAME, \
            Module.Type.TUNNEL_BOX, \
            Module.Type.TREE_BRANCH, \
            Module.Type.TORUS_QUARTER, \
            Module.Type.BOX:          mm.material_override =  preload("uid://ci4cvsq2gbob7")       
            Module.Type.ARROW:        mm.material_override =  preload("uid://dc38ipveu0heb")
            Module.Type.TREE_CANOPY:  mm.material_override =  preload("uid://bw6ugjcrosrkd")
            _:                        mm.material_override =  preload("uid://bi5n2lthhnyix")
        
    mm.multimesh.transform_format = MultiMesh.TRANSFORM_3D
    match type:
        Module.Type.CUBECROSS, \
        Module.Type.TUBECROSS, \
        Module.Type.CUBECULE, \
        Module.Type.MOLECULE: 
            mm.multimesh.use_colors = isGhost
        _ : mm.multimesh.use_colors = true

    return mm   
    
func typeForItemType(itemType):
    
    var shape = Item.shapeForType(itemType)
    return Type.CUBE + shape
    
func stringForType(t):
    for key in Type:
        if Type[key] == t: return key
    return "???"
    
func stringForKind(t):
    for key in Kind:
        if Kind[key] == t: return key
    return "???"

func stringForModule(m : Module.Inst):
    return stringForKind(m.kind) + " " + stringForType(m.type) + " " + String.num_int64(m.index)
