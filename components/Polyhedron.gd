@tool
extends Node
# singleton Polyhedron

func tri(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3):

    st.add_vertex(p1)
    st.add_vertex(p3)
    st.add_vertex(p2)
    
func quad(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3, p4 : Vector3):

    tri(st, p1, p2, p3)
    tri(st, p1, p3, p4)
    
func vec(p : Array, basis : Basis) -> Vector3: return basis * Vector3(p[0], p[1], p[2])

func generateMesh(st: SurfaceTool, faces, vertices, basis : Basis):
    
    for face in faces:
        if face.size() == 3:
            tri(st, vec(vertices[face[0]], basis), vec(vertices[face[1]], basis), vec(vertices[face[2]], basis))
        elif face.size() == 4:
            quad(st, vec(vertices[face[0]], basis), vec(vertices[face[1]], basis), vec(vertices[face[2]], basis), vec(vertices[face[3]], basis))
        elif face.size() == 5:
            quad(st, vec(vertices[face[0]], basis), vec(vertices[face[1]], basis), vec(vertices[face[2]], basis), vec(vertices[face[3]], basis))
            tri(st, vec(vertices[face[3]], basis), vec(vertices[face[4]], basis), vec(vertices[face[0]], basis))

func generate(faces, vertices, scale = Basis.IDENTITY):
    
    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1)
    generateMesh(st, faces, vertices, scale)
    st.index()
    st.generate_normals()
    
    return st.commit()        
    
func twinTetrahedron(scale : float, colors : Array):

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1)
    st.set_color(colors[0])
    var basis = Basis.from_scale(Vector3(scale, scale, scale))
    generateMesh(st, TETRA_INDEX, TETRA_VERTEX, basis)
    st.set_color(colors[1])
    generateMesh(st, TETRA_INDEX, TETRA_VERTEX, basis.rotated(Vector3.UP, deg_to_rad(90)))
    st.index()
    st.generate_normals()
    
    return st.commit()  
    
func twinDodecahedron(scale : float, colors : Array):

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1)
    st.set_color(colors[0])
    var basis = Basis.from_scale(Vector3(scale, scale, scale))
    generateMesh(st, DODECA_INDEX, DODECA_VERTEX, basis)
    st.set_color(colors[1])
    generateMesh(st, ICOSA_INDEX, ICOSA_VERTEX, basis.rotated(Vector3.UP, deg_to_rad(80)))
    st.index()
    st.generate_normals()
    
    return st.commit()      
    
func twinOctahedron(scale : float, colors : Array):

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1)
    st.set_color(colors[0])
    var basis = Basis.from_scale(Vector3(scale, scale, scale))
    generateMesh(st, OCTA_INDEX, OCTA_VERTEX, basis)
    st.set_color(colors[1])
    generateMesh(st, CUBE_INDEX, CUBE_VERTEX, basis.rotated(Vector3.UP, deg_to_rad(90)))
    st.index()
    st.generate_normals()
    
    return st.commit()      
    
const CUBE_INDEX   = [ [3,0,1,2], [3,4,5,0], [0,5,6,1], [1,6,7,2], [2,7,4,3], [5,4,7,6] ]
const CUBE_VERTEX  = [ [0.707,0.707,0.707], [-0.707,0.707,0.707], [-0.707,-0.707,0.707], [0.707,-0.707,0.707], [0.707,-0.707,-0.707], [0.707,0.707,-0.707], [-0.707,0.707,-0.707], [-0.707,-0.707,-0.707] ]
    
const TETRA_INDEX  = [ [0,1,2], [0,2,3], [0,3,1], [1,3,2] ] 
const TETRA_VERTEX = [ [1.0,1.0,1.0], [1.0,-1.0,-1.0], [-1.0,1.0,-1.0], [-1.0,-1.0,1.0] ]     

const OCTA_INDEX  = [ [0,1,2], [0,2,3], [0,3,4], [0,4,1], [1,4,5], [1,5,2], [2,5,3], [3,5,4] ]
const OCTA_VERTEX = [ [0,0,1.414], [1.414,0,0], [0,1.414,0], [-1.414,0,0], [0,-1.414,0], [0,0,-1.414] ]

const ICOSA_INDEX = [ 
            [0,1,2], [0,2,3], [0,3,4], [0,4,5],
            [0,5,1], [1,5,7], [1,7,6], [1,6,2],
            [2,6,8], [2,8,3], [3,8,9], [3,9,4],
            [4,9,10], [4,10,5], [5,10,7], [6,7,11],
            [6,11,8], [7,10,11], [8,11,9], [9,11,10] ]
            
const ICOSA_VERTEX = [ 
            [0,0,1.176], [1.051,0,0.526],
            [0.324,1.0,0.525], [-0.851,0.618,0.526],
            [-0.851,-0.618,0.526], [0.325,-1.0,0.526],
            [0.851,0.618,-0.526], [0.851,-0.618,-0.526],
            [-0.325,1.0,-0.526], [-1.051,0,-0.526],
            [-0.325,-1.0,-0.526], [0,0,-1.176] ]
        
const DODECA_INDEX = [ 
            [0,1,4,7,2], [0,2,6,9,3], [0,3,8,5,1],
            [1,5,11,10,4], [2,7,13,12,6], [3,9,15,14,8],
            [4,10,16,13,7], [5,8,14,17,11], [6,12,18,15,9],
            [10,11,17,19,16], [12,13,16,19,18], [14,15,18,19,17] ]
        
const DODECA_VERTEX = [
            [0,0,1.07047], [0.713644,0,0.797878],
            [-0.356822,0.618,0.797878], [-0.356822,-0.618,0.797878],
            [0.797878,0.618034,0.356822], [0.797878,-0.618,0.356822],
            [-0.934172,0.381966,0.356822], [0.136294,1.0,0.356822],
            [0.136294,-1.0,0.356822], [-0.934172,-0.381966,0.356822],
            [0.934172,0.381966,-0.356822], [0.934172,-0.381966,-0.356822],
            [-0.797878,0.618,-0.356822], [-0.136294,1.0,-0.356822],
            [-0.136294,-1.0,-0.356822], [-0.797878,-0.618034,-0.356822],
            [0.356822,0.618,-0.797878], [0.356822,-0.618,-0.797878],
            [-0.713644,0,-0.797878], [0,0,-1.07047] ]

func cube():                      return generate(CUBE_INDEX,   CUBE_VERTEX)
func tetrahedron(scale : float):  return generate(TETRA_INDEX,  TETRA_VERTEX,  Basis.from_scale(Vector3(scale, scale, scale)))
func octahedron(scale : float):   return generate(OCTA_INDEX,   OCTA_VERTEX,   Basis.from_scale(Vector3(scale, scale, scale)))
func icosahedron(scale : float):  return generate(ICOSA_INDEX,  ICOSA_VERTEX,  Basis.from_scale(Vector3(scale, scale, scale)))
func dodecahedron(scale : float): return generate(DODECA_INDEX, DODECA_VERTEX, Basis.from_scale(Vector3(scale, scale, scale)))


    
