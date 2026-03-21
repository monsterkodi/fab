@tool
class_name TetraTree
extends Node3D

@export var points : PackedVector3Array:
    set(v): points = v; generate()
    
@export var material : Material:
    set(v): material = v; generate()
    
func _ready():
    
    generate()
    
func generate():
    
    var innerPoints : PackedVector3Array = []
    var hullPoints  : PackedVector3Array = []
    
    for p in points:
        var l = p.length()
        var n = p.normalized()
        var o = 1.0
        while o < l:
            innerPoints.push_back(n*o)
            hullPoints.push_back(n*o + Vector3(0.15, 0.0, 0.0))
            hullPoints.push_back(n*o + Vector3(-0.15, 0.0, 0.0))
            hullPoints.push_back(n*o + Vector3(0.0, 0.15, 0.0))
            hullPoints.push_back(n*o + Vector3(0.0,-0.15, 0.0))
            hullPoints.push_back(n*o + Vector3(0.0, 0.0,  0.15))
            hullPoints.push_back(n*o + Vector3(0.0, 0.0, -0.15))
            o += 1.0
    
    var innerIndex = points.size() + innerPoints.size() + 1
    var allPoints : PackedVector3Array = points + innerPoints + PackedVector3Array([Vector3.ZERO]) + hullPoints
    var tetras : PackedInt32Array = Geometry3D.tetrahedralize_delaunay(allPoints)
    Log.log(innerIndex, innerPoints, tetras)
    
    var trias : PackedVector3Array
    var norms : PackedVector3Array
    
    for index in range(0, tetras.size(), 4):
        for p in points:

            var p1 = allPoints[tetras[index]]
            var p2 = allPoints[tetras[index+1]]
            var p3 = allPoints[tetras[index+2]]
            var p4 = allPoints[tetras[index+3]]

            var tetraCenter = (p1+p2+p3+p4)/4.0
            var closest = Geometry3D.get_closest_point_to_segment(tetraCenter, Vector3.ZERO, p)
            
            if (closest-tetraCenter).length() < 0.1:
                Log.log(index, p, (closest-tetraCenter).length())
                var toCenter = ((p1-closest) + (p2-closest) + (p3-closest)).normalized()
                var cross = (p2 - p1).cross(p3 - p1)
                var dot = cross.dot(toCenter)

                norms.push_back(toCenter)
                norms.push_back(toCenter)
                norms.push_back(toCenter)
                if dot > 0:
                    trias.push_back(p1)
                    trias.push_back(p3)
                    trias.push_back(p2)
                else:
                    trias.push_back(p1)
                    trias.push_back(p2)
                    trias.push_back(p3)

    var mesh := ArrayMesh.new()
    Log.log("trias", trias.size(), norms.size())
    var arrays = Array()
    arrays.resize(Mesh.ArrayType.ARRAY_MAX)
    arrays[Mesh.ArrayType.ARRAY_VERTEX] = trias
    arrays[Mesh.ArrayType.ARRAY_NORMAL] = norms
    mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    var mi = MeshInstance3D.new()    
    mi.mesh = mesh
    mi.mesh.surface_set_material(0, material)
    mi.transform = Transform3D.IDENTITY
    
    if get_child_count():
        get_child(0).free()
    
    add_child(mi)
