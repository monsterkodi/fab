extends Node
# singleton Module

enum Type { 
    BOX, 
    ARROW, 
    CUBE, 
    TORUS, 
    SPHERE, 
    CYLINDER, 
    STORAGE, 
    GEAR, 
    FRAME, 
    CUBE_CROSS, 
    CYLINDER_CROSS, 
    TUNNEL_BOX, 
    CUBECULE, 
    MOLECULE, 
    TREE_BRANCH,
    TREE_CANOPY 
    }
    
enum Kind { NONE, SLIT, SLOT, DECO }

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
        
func meshForType(type : Type):
    
    var mesh
    match type:
        Module.Type.BOX:                mesh = MachMeshes.regal(1.0, 1.0, 1.0, 0.2, 0.5)
        Module.Type.ARROW:              mesh = MachMeshes.arrow(0.4, 0.2, 0.5)
        Module.Type.CUBE:               mesh = BoxMesh.new()
        Module.Type.TORUS:              mesh = TorusMesh.new(); mesh.outer_radius = 0.5; mesh.inner_radius = 0.2; mesh.ring_segments = 12; mesh.rings = 24
        Module.Type.SPHERE:             mesh = SphereMesh.new(); mesh.radial_segments = 24; mesh.rings = 12
        Module.Type.CYLINDER:           mesh = CylinderMesh.new(); mesh.height = 1.0; mesh.rings = 1; mesh.radial_segments = 24
        Module.Type.STORAGE:            mesh = MachMeshes.storage(0.8, 0.5) 
        Module.Type.GEAR:               mesh = MachMeshes.gear(0.4, 0.1, 0.2, 7, 0.5, 0.5, false)
        Module.Type.FRAME:              mesh = MachMeshes.frame(1.0, 1.0, 1.0, 0.2, 0.5)
        Module.Type.CUBE_CROSS:         mesh = MachMeshes.cubeCross(0.6, [COLOR.ITEM_RED, COLOR.ITEM_GREEN, COLOR.ITEM_BLUE])
        Module.Type.CYLINDER_CROSS:     mesh = MachMeshes.cylinderCross(0.6, 0.15, [COLOR.ITEM_GREEN, COLOR.ITEM_BLUE, COLOR.ITEM_RED])
        Module.Type.TUNNEL_BOX:         mesh = MachMeshes.tunnelBox(1.0, 1.0, 1.0, 0.2, 0.5)
        Module.Type.CUBECULE:           mesh = MachMeshes.cubecule(0.6, 0.2,  0.2, [COLOR.ITEM_BLACK, COLOR.ITEM_WHITE, COLOR.ITEM_WHITE, COLOR.ITEM_WHITE])
        Module.Type.MOLECULE:           mesh = MachMeshes.molecule(0.7, 0.07, 0.14, [COLOR.ITEM_BLACK, COLOR.ITEM_RED,   COLOR.ITEM_GREEN, COLOR.ITEM_BLUE])
        Module.Type.TREE_BRANCH:        mesh = MachMeshes.treeBranch(0.5, 1, 0.5, 0.5)
        Module.Type.TREE_CANOPY:        mesh = MachMeshes.treeCanopy(1.6, 0.8, 0.6) 
    return mesh
    
func multiMeshForType(type : Type, isGhost = false):
    
    var mm = MultiMeshInstance3D.new()
    mm.name = stringForType(type)
    mm.multimesh = MultiMesh.new()
    mm.multimesh.mesh = meshForType(type)
    assert(mm.multimesh.mesh)
    
    if isGhost:
        mm.material_override = preload("uid://cqpqvcb8usfl0")
    else:
        match type:
            Module.Type.STORAGE, \
            Module.Type.FRAME, \
            Module.Type.TUNNEL_BOX, \
            Module.Type.TREE_BRANCH, \
            Module.Type.BOX:          mm.material_override =  preload("uid://ci4cvsq2gbob7")       
            Module.Type.ARROW:        mm.material_override =  preload("uid://dc38ipveu0heb")
            Module.Type.TREE_CANOPY:  mm.material_override =  preload("uid://bw6ugjcrosrkd")
            _:                        mm.material_override =  preload("uid://bi5n2lthhnyix")
        
    mm.multimesh.transform_format = MultiMesh.TRANSFORM_3D
    match type:
        Module.Type.CUBE_CROSS, \
        Module.Type.CYLINDER_CROSS, \
        Module.Type.CUBECULE, \
        Module.Type.MOLECULE: 
            mm.multimesh.use_colors = false
        _ : mm.multimesh.use_colors = true

    return mm    
    
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
