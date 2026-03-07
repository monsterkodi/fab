extends Node
# singleton MachMeshes

func tri(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3):

    st.add_vertex(p1)
    st.add_vertex(p2)
    st.add_vertex(p3)
    
func quad(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3, p4 : Vector3):

    tri(st, p1, p2, p3)
    tri(st, p1, p3, p4)

func quad3(st : SurfaceTool, p1 : Vector3, p2 : Vector3, p3 : Vector3):
    
    quad(st, p1, p2, p3, p3 + (p1-p2))

func arrow(width, height, thickness):

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    
    var w  = width/2
    var h  = height/2
    
    st.set_smooth_group(-1) # flat shading
    
    var s  = width * thickness
    var sh = s/2
    var cf = Vector3( 0, h,  0)
    var cb = Vector3( 0, h, -s)
    var rf = Vector3( w, h, -w)
    var lf = Vector3(-w, h, -w)
    var rb = Vector3( w-sh, h, -w-sh)
    var lb = Vector3(-w+sh, h, -w-sh)
    
    quad(st, cf, cb, rb, rf)
    quad(st, cb, cf, lf, lb)
    
    if height > 0:
        
        var bcf = Vector3( 0,    -h,  0)
        var bcb = Vector3( 0,    -h, -s)
        var brf = Vector3( w,    -h, -w)
        var blf = Vector3(-w,    -h, -w)
        var brb = Vector3( w-sh, -h, -w-sh)
        var blb = Vector3(-w+sh, -h, -w-sh)
        
        quad3(st, bcf, cf, rf)
        quad3(st, cf, bcf, blf)

        quad3(st, rf, rb, brb)
        quad3(st, brb, rb, cb)

        quad3(st, lf, blf, blb)
        quad3(st, lb, blb, bcb)
        
        quad(st, brb, bcb, bcf, brf)
        quad(st, blf, bcf, bcb, blb)
        
    st.index()
    st.generate_normals()
    
    return st.commit()
    
func regal(width, height, depth, thickness, chamfer):

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1) # flat shading
    
    var w  = width/2
    var h  = height/2
    var d  = depth/2
    var cw = w
    var ch = h
    var cd = d
    var iw = w - thickness
    var ih = h - thickness
    var id = d - thickness
    
    if chamfer > 0:
        cw = w - thickness * chamfer
        ch = h - thickness * chamfer
        cd = d - thickness * chamfer

        quad3(st, Vector3( cw,  h, -cd), Vector3(-cw,  h, -cd), Vector3(-cw,  ch, -d)) # rear top
        quad3(st, Vector3( cw, -ch, -d), Vector3( w, -ch, -cd), Vector3( w,  ch, -cd)) # rear right
        quad3(st, Vector3(-cw,  ch, -d), Vector3(-w,  ch, -cd), Vector3(-w, -ch, -cd)) # rear left
        quad3(st, Vector3(-cw, -h, -cd), Vector3( cw, -h, -cd), Vector3( cw, -ch, -d)) # rear bottom

        quad3(st, Vector3(-cw,  ch,  d), Vector3(-cw,  h,  cd), Vector3( cw,  h,  cd)) # front top
        quad3(st, Vector3( w,  ch,  cd), Vector3( w, -ch,  cd), Vector3( cw, -ch,  d)) # front right
        quad3(st, Vector3(-w, -ch,  cd), Vector3(-w,  ch,  cd), Vector3(-cw,  ch,  d)) # front left
        quad3(st, Vector3( cw, -ch,  d), Vector3( cw, -h,  cd), Vector3(-cw, -h,  cd)) # front bottom
        
        quad3(st, Vector3(-cw,  h,  cd), Vector3(-w,  ch, cd), Vector3( -w,  ch, -cd)) # top left
        quad3(st, Vector3( w,  ch, -cd), Vector3( w,  ch, cd), Vector3( cw,   h,  cd)) # top right
        quad3(st, Vector3(-w, -ch, -cd), Vector3(-w, -ch, cd), Vector3(-cw,  -h,  cd)) # bottom left
        quad3(st, Vector3( cw, -h,  cd), Vector3( w, -ch, cd), Vector3(  w, -ch, -cd)) # bottom right
        
        tri(st, Vector3(-cw,  ch,  d), Vector3(-w,  ch,  cd), Vector3(-cw,  h,  cd)) # top left front
        tri(st, Vector3( cw,  ch,  d), Vector3(cw,   h,  cd), Vector3( w,  ch,  cd)) # top right front
        tri(st, Vector3(-cw,  h, -cd), Vector3(-w,  ch, -cd), Vector3(-cw,  ch, -d)) # top left  rear
        tri(st, Vector3( w,  ch, -cd), Vector3(cw,   h, -cd), Vector3( cw,  ch, -d)) # top right rear

        tri(st, Vector3(-cw,  -h, cd), Vector3(-w, -ch,  cd), Vector3(-cw, -ch,  d)) # bottom left front
        tri(st, Vector3( w,  -ch, cd), Vector3(cw,  -h,  cd), Vector3( cw, -ch,  d)) # bottom right front
        tri(st, Vector3(-cw, -ch, -d), Vector3(-w, -ch, -cd), Vector3(-cw,  -h,-cd)) # bottom left  rear
        tri(st, Vector3( cw, -ch, -d), Vector3(cw,  -h, -cd), Vector3( w,  -ch,-cd)) # bottom right rear
    
    # outer box
    quad3(st, Vector3(-cw,  ch, -d),  Vector3(-cw, -ch, -d), Vector3( cw, -ch, -d)) # rear 
    quad3(st, Vector3(-cw,  h,  cd),  Vector3(-cw,  h, -cd), Vector3( cw,  h, -cd)) # top 
    quad3(st, Vector3( w,  ch, -cd),  Vector3( w, -ch, -cd), Vector3( w, -ch,  cd)) # right 
    quad3(st, Vector3(-w, -ch,  cd),  Vector3(-w, -ch, -cd), Vector3(-w,  ch, -cd)) # left
    quad3(st, Vector3( cw, -h, -cd),  Vector3(-cw, -h, -cd), Vector3(-cw, -h,  cd)) # bottom  

    # outer front frame
    quad(st, Vector3(-cw, ch, d), Vector3( cw,  ch, d), Vector3( iw,  ih, d), Vector3(-iw,  ih, d)) # top
    quad(st, Vector3(-cw, ch, d), Vector3(-iw,  ih, d), Vector3(-iw, -ih, d), Vector3(-cw, -ch, d)) # left
    quad(st, Vector3( cw, ch, d), Vector3( cw, -ch, d), Vector3( iw, -ih, d), Vector3( iw,  ih, d)) # right
    quad(st, Vector3(-cw,-ch, d), Vector3(-iw, -ih, d), Vector3( iw, -ih, d), Vector3( cw, -ch, d)) # bottom

    # inner box
    
    quad3(st, Vector3( iw, -ih, -id),  Vector3(-iw, -ih, -id), Vector3(-iw,  ih, -id)) # rear 
    quad3(st, Vector3( iw,  ih, -id),  Vector3(-iw,  ih, -id), Vector3(-iw,  ih,   d)) # top 
    quad3(st, Vector3( iw, -ih,   d),  Vector3( iw, -ih, -id), Vector3( iw,  ih, -id)) # right 
    quad3(st, Vector3(-iw,  ih, -id),  Vector3(-iw, -ih, -id), Vector3(-iw, -ih,   d)) # left
    quad3(st, Vector3(-iw, -ih,   d),  Vector3(-iw, -ih, -id), Vector3( iw, -ih, -id)) # bottom  
        
    st.index()
    st.generate_normals()
    
    return st.commit()    
