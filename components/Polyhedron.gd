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
    
func vec(p : Array, scale : float) -> Vector3: return Vector3(p[0] * scale, p[1] * scale, p[2] * scale)

func generateMesh(st: SurfaceTool, faces, vertices, scale = 1.0):
    
    for face in faces:
        if face.size() == 3:
            tri(st, vec(vertices[face[0]], scale), vec(vertices[face[1]], scale), vec(vertices[face[2]], scale))
        elif face.size() == 4:
            quad(st, vec(vertices[face[0]], scale), vec(vertices[face[1]], scale), vec(vertices[face[2]], scale), vec(vertices[face[3]], scale))
        elif face.size() == 5:
            quad(st, vec(vertices[face[0]], scale), vec(vertices[face[1]], scale), vec(vertices[face[2]], scale), vec(vertices[face[3]], scale))
            tri(st, vec(vertices[face[3]], scale), vec(vertices[face[4]], scale), vec(vertices[face[0]], scale))

func generate(faces, vertices, scale = 1.0):
    
    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1)
    generateMesh(st, faces, vertices, scale)
    st.index()
    st.generate_normals()
    
    return st.commit()        

func tetrahedron(scale : float):
    return generate([ [0,1,2], [0,2,3], [0,3,1], [1,3,2] ], [ [1.0,1.0,1.0], [1.0,-1.0,-1.0], [-1.0,1.0,-1.0], [-1.0,-1.0,1.0] ], scale)

func cube():
    return generate([ [3,0,1,2], [3,4,5,0], [0,5,6,1], [1,6,7,2], [2,7,4,3], [5,4,7,6] ], [ [0.707,0.707,0.707], [-0.707,0.707,0.707], [-0.707,-0.707,0.707], [0.707,-0.707,0.707], [0.707,-0.707,-0.707], [0.707,0.707,-0.707], [-0.707,0.707,-0.707], [-0.707,-0.707,-0.707] ])

func octahedron(scale : float):
    return generate([ [0,1,2], [0,2,3], [0,3,4], [0,4,1], [1,4,5], [1,5,2], [2,5,3], [3,5,4] ], [ [0,0,1.414], [1.414,0,0], [0,1.414,0], [-1.414,0,0], [0,-1.414,0], [0,0,-1.414] ], scale)

func icosahedron(scale : float):
    return generate([ 
            [0,1,2], [0,2,3], [0,3,4], [0,4,5],
            [0,5,1], [1,5,7], [1,7,6], [1,6,2],
            [2,6,8], [2,8,3], [3,8,9], [3,9,4],
            [4,9,10], [4,10,5], [5,10,7], [6,7,11],
            [6,11,8], [7,10,11], [8,11,9], [9,11,10] 
        ],[ 
            [0,0,1.176], [1.051,0,0.526],
            [0.324,1.0,0.525], [-0.851,0.618,0.526],
            [-0.851,-0.618,0.526], [0.325,-1.0,0.526],
            [0.851,0.618,-0.526], [0.851,-0.618,-0.526],
            [-0.325,1.0,-0.526], [-1.051,0,-0.526],
            [-0.325,-1.0,-0.526], [0,0,-1.176] ],
        scale)

func dodecahedron(scale : float):
    return generate([ 
            [0,1,4,7,2], [0,2,6,9,3], [0,3,8,5,1],
            [1,5,11,10,4], [2,7,13,12,6], [3,9,15,14,8],
            [4,10,16,13,7], [5,8,14,17,11], [6,12,18,15,9],
            [10,11,17,19,16], [12,13,16,19,18], [14,15,18,19,17],
        ],[
            [0,0,1.07047], [0.713644,0,0.797878],
            [-0.356822,0.618,0.797878], [-0.356822,-0.618,0.797878],
            [0.797878,0.618034,0.356822], [0.797878,-0.618,0.356822],
            [-0.934172,0.381966,0.356822], [0.136294,1.0,0.356822],
            [0.136294,-1.0,0.356822], [-0.934172,-0.381966,0.356822],
            [0.934172,0.381966,-0.356822], [0.934172,-0.381966,-0.356822],
            [-0.797878,0.618,-0.356822], [-0.136294,1.0,-0.356822],
            [-0.136294,-1.0,-0.356822], [-0.797878,-0.618034,-0.356822],
            [0.356822,0.618,-0.797878], [0.356822,-0.618,-0.797878],
            [-0.713644,0,-0.797878], [0,0,-1.07047] ], 
        scale)


    
