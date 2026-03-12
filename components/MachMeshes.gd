@tool
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

func box(st : SurfaceTool, w : float, h: float, d: float):
    
    quad3(st, Vector3(-w,  h, -d),  Vector3(-w, -h, -d), Vector3( w, -h, -d)) # rear 
    quad3(st, Vector3(-w,  h,  d),  Vector3(-w,  h, -d), Vector3( w,  h, -d)) # top 
    quad3(st, Vector3( w,  h, -d),  Vector3( w, -h, -d), Vector3( w, -h,  d)) # right 
    quad3(st, Vector3(-w, -h,  d),  Vector3(-w, -h, -d), Vector3(-w,  h, -d)) # left
    quad3(st, Vector3( w, -h, -d),  Vector3(-w, -h, -d), Vector3(-w, -h,  d)) # bottom  
    quad3(st, Vector3(-w,  h,  d),  Vector3( w,  h,  d), Vector3( w, -h,  d)) # front

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
    
func tunnelBox(width, height, depth, thickness, chamfer):    
    
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
    
    var mh = 0
    var mt = 0
    var ml = 0
    
    if chamfer > 0:
        cw = w - thickness * chamfer
        ch = h - thickness * chamfer
        cd = d - thickness * chamfer
        
        mt = thickness * chamfer

        #quad3(st, Vector3( cw,  h, -cd), Vector3(-cw,  h, -cd), Vector3(-cw,  ch, -d)) # rear top
        quad3(st, Vector3( cw,  mt, -cd), Vector3(-cw,  mt, -cd), Vector3(-cw,  ml, -d)) # rear top
        quad3(st, Vector3( cw, -ch, -d), Vector3( w, -ch, -cd), Vector3( w,  ml, -cd)) # rear right
        quad3(st, Vector3(-cw,  ml, -d), Vector3(-w,  ml, -cd), Vector3(-w, -ch, -cd)) # rear left
        quad3(st, Vector3(-cw, -h, -cd), Vector3( cw, -h, -cd), Vector3( cw, -ch, -d)) # rear bottom

        quad3(st, Vector3(-cw,  ch,  d), Vector3(-cw,  h,  cd), Vector3( cw,  h,  cd)) # front top
        quad3(st, Vector3( w,  ch,  cd), Vector3( w, -ch,  cd), Vector3( cw, -ch,  d)) # front right
        quad3(st, Vector3(-w, -ch,  cd), Vector3(-w,  ch,  cd), Vector3(-cw,  ch,  d)) # front left
        quad3(st, Vector3( cw, -ch,  d), Vector3( cw, -h,  cd), Vector3(-cw, -h,  cd)) # front bottom
        
        quad3(st, Vector3(-cw,  h,  cd), Vector3(-w,  ch, cd), Vector3( -w,  ml, -cd)) # top left
        quad3(st, Vector3( w,  ml, -cd), Vector3( w,  ch, cd), Vector3( cw,   h,  cd)) # top right
        quad3(st, Vector3(-w, -ch, -cd), Vector3(-w, -ch, cd), Vector3(-cw,  -h,  cd)) # bottom left
        quad3(st, Vector3( cw, -h,  cd), Vector3( w, -ch, cd), Vector3(  w, -ch, -cd)) # bottom right
        
        tri(st, Vector3(-cw,  ch,  d), Vector3(-w,  ch,  cd), Vector3(-cw,  h,  cd)) # top left front
        tri(st, Vector3( cw,  ch,  d), Vector3(cw,   h,  cd), Vector3( w,  ch,  cd)) # top right front
        tri(st, Vector3(-cw,  mt, -cd), Vector3(-w,  ml, -cd), Vector3(-cw,  ml, -d)) # top left  rear
        tri(st, Vector3( w,  ml, -cd), Vector3(cw,   mt, -cd), Vector3( cw,  ml, -d)) # top right rear

        tri(st, Vector3(-cw,  -h, cd), Vector3(-w, -ch,  cd), Vector3(-cw, -ch,  d)) # bottom left front
        tri(st, Vector3( w,  -ch, cd), Vector3(cw,  -h,  cd), Vector3( cw, -ch,  d)) # bottom right front
        tri(st, Vector3(-cw, -ch, -d), Vector3(-w, -ch, -cd), Vector3(-cw,  -h,-cd)) # bottom left  rear
        tri(st, Vector3( cw, -ch, -d), Vector3(cw,  -h, -cd), Vector3( w,  -ch,-cd)) # bottom right rear
    
    # outer box
    quad3(st, Vector3(-cw,  mh, -d),  Vector3(-cw, -ch, -d), Vector3( cw, -ch, -d)) # rear 
    quad3(st, Vector3(-cw,  h,  cd),  Vector3(-cw,  mt, -cd), Vector3( cw,  mt, -cd)) # top 
    quad (st, Vector3( w,  ml, -cd),  Vector3( w, -ch, -cd), Vector3( w, -ch,  cd), Vector3( w,  ch,  cd)) # right 
    quad (st, Vector3(-w, -ch,  cd),  Vector3(-w, -ch, -cd), Vector3(-w,  ml, -cd), Vector3(-w,  ch,  cd)) # left
    quad3(st, Vector3( cw, -h, -cd),  Vector3(-cw, -h, -cd), Vector3(-cw, -h,  cd)) # bottom  

    # outer front frame
    quad(st, Vector3(-cw, ch, d), Vector3( cw,  ch, d), Vector3( iw,  ih, d), Vector3(-iw,  ih, d)) # top
    quad(st, Vector3(-cw, ch, d), Vector3(-iw,  ih, d), Vector3(-iw, -ih, d), Vector3(-cw, -ch, d)) # left
    quad(st, Vector3( cw, ch, d), Vector3( cw, -ch, d), Vector3( iw, -ih, d), Vector3( iw,  ih, d)) # right
    quad(st, Vector3(-cw,-ch, d), Vector3(-iw, -ih, d), Vector3( iw, -ih, d), Vector3( cw, -ch, d)) # bottom

    # inner box
    
    quad3(st, Vector3( iw, -ih, -id),  Vector3(-iw, -ih, -id), Vector3(-iw,  mh, -id)) # rear 
    quad3(st, Vector3( iw,  ml, -id),  Vector3(-iw,  ml, -id), Vector3(-iw,  ih,   d)) # top 
    quad (st, Vector3( iw, -ih,   d),  Vector3( iw, -ih, -id), Vector3( iw,  ml, -id), Vector3(iw, ih, d)) # right 
    quad (st, Vector3(-iw,  ml, -id),  Vector3(-iw, -ih, -id), Vector3(-iw, -ih,   d), Vector3(-iw, ih, d)) # left
    quad3(st, Vector3(-iw, -ih,   d),  Vector3(-iw, -ih, -id), Vector3( iw, -ih, -id)) # bottom  
        
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
    
func frame(width, height, depth, thickness, chamfer):

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
    quad3(st, Vector3(-cw,  h,  cd),  Vector3(-cw,  h, -cd), Vector3( cw,  h, -cd)) # top 
    quad3(st, Vector3( cw, -h, -cd),  Vector3(-cw, -h, -cd), Vector3(-cw, -h,  cd)) # bottom  

    # outer front frame
    quad(st, Vector3(-cw, ch, d), Vector3( cw,  ch, d), Vector3( iw,  ih, d), Vector3(-iw,  ih, d)) # top
    quad(st, Vector3(-cw, ch, d), Vector3(-iw,  ih, d), Vector3(-iw, -ih, d), Vector3(-cw, -ch, d)) # left
    quad(st, Vector3( cw, ch, d), Vector3( cw, -ch, d), Vector3( iw, -ih, d), Vector3( iw,  ih, d)) # right
    quad(st, Vector3(-cw,-ch, d), Vector3(-iw, -ih, d), Vector3( iw, -ih, d), Vector3( cw, -ch, d)) # bottom

    # outer rear frame
    quad(st, Vector3(-cw, ch, -d), Vector3(-iw,  ih, -d), Vector3( iw,  ih, -d), Vector3( cw,  ch, -d)) # top
    quad(st, Vector3(-cw, ch, -d), Vector3(-cw, -ch, -d), Vector3(-iw, -ih, -d), Vector3(-iw,  ih, -d)) # left
    quad(st, Vector3( cw, ch, -d), Vector3( iw,  ih, -d), Vector3( iw, -ih, -d), Vector3( cw, -ch, -d)) # right
    quad(st, Vector3(-cw,-ch, -d), Vector3( cw, -ch, -d), Vector3( iw, -ih, -d), Vector3(-iw, -ih, -d)) # bottom

    # outer left frame
    quad(st, Vector3(-w,  ch, -cd), Vector3(-w, ch, cd), Vector3(-w,  ih, id), Vector3(-w,  ih, -id)) # top
    quad(st, Vector3(-w, -ih, id), Vector3(-w, ih, id), Vector3(-w, ch, cd), Vector3(-w,  -ch, cd)) # front
    quad(st, Vector3(-w, -ih, -id), Vector3(-w,  -ch, -cd), Vector3(-w, ch, -cd), Vector3(-w, ih, -id)) # back
    quad(st, Vector3(-w, -ch, cd), Vector3(-w, -ch, -cd), Vector3(-w, -ih, -id), Vector3(-w, -ih, id)) # bottom

    # outer right frame
    quad(st, Vector3(w,  ch, -cd), Vector3(w,  ih, -id), Vector3(w,  ih, id),  Vector3(w, ch, cd)) 
    quad(st, Vector3(w, -ih, id),  Vector3(w,  -ch, cd), Vector3(w, ch, cd),   Vector3(w, ih, id)) 
    quad(st, Vector3(w, -ih, -id), Vector3(w, ih, -id),  Vector3(w, ch, -cd),  Vector3(w,-ch,-cd)) 
    quad(st, Vector3(w, -ch, cd),  Vector3(w, -ih, id),  Vector3(w, -ih, -id), Vector3(w,-ch,-cd)) 

    # inner vertical sides
    
    quad3(st, Vector3( -iw, -ih, id),  Vector3(-iw, -ih, d),  Vector3(-iw, ih, d))   # front left
    quad3(st, Vector3(  iw, -ih, id),  Vector3( iw, ih, id),  Vector3( iw, ih, d))   # front right
    quad3(st, Vector3( -iw, -ih, -id), Vector3(-iw, ih, -id), Vector3(-iw, ih, -d))  # back left    
    quad3(st, Vector3(  iw, -ih, -id), Vector3( iw, -ih, -d), Vector3( iw, ih, -d))  # back right
    
    quad3(st, Vector3( -w, -ih, id),  Vector3(-iw, -ih, id),  Vector3(-iw, ih, id)) # left front 
    quad3(st, Vector3( -w, -ih, -id),  Vector3(-w, ih, -id),  Vector3(-iw, ih, -id)) # left back

    quad3(st, Vector3( iw, -ih, id),  Vector3(  w, -ih, id),  Vector3(  w, ih, id)) # right front 
    quad3(st, Vector3( iw, -ih, -id),  Vector3(iw, ih, -id),  Vector3( w, ih, -id)) # right back
    
    # inner bottom
    
    quad3(st, Vector3(w, -ih, id), Vector3(-w, -ih, id), Vector3(-w, -ih, -id))
    quad3(st, Vector3(iw, -ih, d), Vector3(-iw, -ih, d), Vector3(-iw, -ih, id))
    quad3(st, Vector3(iw, -ih, -id), Vector3(-iw, -ih, -id), Vector3(-iw, -ih, -d))
        
    # inner top
    
    quad3(st, Vector3(w,  ih, id), Vector3(w,  ih, -id), Vector3(-w, ih, -id))
    quad3(st, Vector3(iw, ih, d), Vector3(iw,  ih, -d), Vector3(-iw, ih, -d))

    st.index()
    st.generate_normals()
    
    return st.commit()    
    
func cross(width : float, height : float, thickness : float):
    
    var st = SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1) # flat shading
    
    var w  = width/2
    var h  = height/2
    var d  = w * thickness
    
    quad3(st, Vector3(-w,  h, -d),  Vector3(-w, -h, -d), Vector3( w, -h, -d)) # rear 
    quad3(st, Vector3(-w,  h,  d),  Vector3(-w,  h, -d), Vector3( w,  h, -d)) # top 
    quad3(st, Vector3( w,  h, -d),  Vector3( w, -h, -d), Vector3( w, -h,  d)) # right 
    quad3(st, Vector3(-w, -h,  d),  Vector3(-w, -h, -d), Vector3(-w,  h, -d)) # left
    quad3(st, Vector3( w, -h, -d),  Vector3(-w, -h, -d), Vector3(-w, -h,  d)) # bottom  
    quad3(st, Vector3(-w,  h,  d),  Vector3( w,  h,  d), Vector3( w, -h,  d)) # front

    w  = w * thickness
    h  = height/2
    d  = width/2

    quad3(st, Vector3(-w,  h, -d),  Vector3(-w, -h, -d), Vector3( w, -h, -d)) # rear 
    quad3(st, Vector3(-w,  h,  d),  Vector3(-w,  h, -d), Vector3( w,  h, -d)) # top 
    quad3(st, Vector3( w,  h, -d),  Vector3( w, -h, -d), Vector3( w, -h,  d)) # right 
    quad3(st, Vector3(-w, -h,  d),  Vector3(-w, -h, -d), Vector3(-w,  h, -d)) # left
    quad3(st, Vector3( w, -h, -d),  Vector3(-w, -h, -d), Vector3(-w, -h,  d)) # bottom  
    quad3(st, Vector3(-w,  h,  d),  Vector3( w,  h,  d), Vector3( w, -h,  d)) # front

    st.index()
    st.generate_normals()
    
    return st.commit()    
    
func cubeCross(width : float, colors : Array):

    var st = SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1) # flat shading
    
    var w  = width/2
    var h  = width/6
    var d  = width/6
    
    st.set_color(colors[0])
    box(st, w, h, d)

    w  = width/6
    h  = width/2
    d  = width/6

    st.set_color(colors[1])
    box(st, w, h, d)

    w  = width/6
    h  = width/6
    d  = width/2

    st.set_color(colors[2])
    box(st, w, h, d)

    st.index()
    st.generate_normals()
    
    return st.commit()    
    
func perp(vec : Vector3) -> Vector3:
    
    var ax = absf(vec.x)
    var ay = absf(vec.y)
    var az = absf(vec.z)
    if  ax <= ay and ax <= az:
        return Vector3(0, -vec.z, vec.y)
    if ay <= ax and ay <= az:
        return Vector3(-vec.z, 0, vec.x)
    return Vector3(-vec.y, vec.x, 0)
    
func circle(st : SurfaceTool, center : Vector3, radius : float, normal : Vector3, segments : int = 18):
    
    var right = perp(normal).normalized() * radius
    for step in range(segments):
        var rotr = right.rotated(normal, TAU / segments)
        tri(st, center, center + right, center + rotr)
        right = rotr
        
func tube(st : SurfaceTool, bot : Vector3, top: Vector3, botRadius : float, topRadius : float, segments : int = 18):

    var normal   = (top - bot).normalized()
    var right    = perp(top - bot).normalized()
    var botRight = right * botRadius
    var topRight = right * topRadius
    for step in range(segments):
        var botRot = botRight.rotated(normal, TAU / segments)
        var topRot = topRight.rotated(normal, TAU / segments)
        quad(st, bot + botRight, top + topRight, top + topRot, bot + botRot)
        botRight = botRot
        topRight = topRot
    
func cylinder(st : SurfaceTool, botCenter : Vector3, topCenter : Vector3, botRadius : float, topRadius : float, segments : int = 18):
    
    st.set_smooth_group(-1) # flat shading
    var normal = (topCenter - botCenter).normalized()
    circle(st, botCenter, botRadius, normal,        segments)
    circle(st, topCenter, topRadius, normal * -1.0, segments)
    
    st.set_smooth_group(0) # smooth shading
    tube(st, botCenter, topCenter, botRadius, topRadius, segments)
    
func cylinderCross(width : float, radius : float, colors : Array, segments : int = 18):

    var st = SurfaceTool.new()
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    
    var w  = width/2
    
    st.set_color(colors[0])
    cylinder(st, Vector3(-w, 0, 0), Vector3( w, 0, 0), radius, radius, segments)

    st.set_color(colors[1])
    cylinder(st, Vector3(0, -w, 0), Vector3( 0, w, 0), radius, radius, segments)

    st.set_color(colors[2])
    cylinder(st, Vector3(0, 0, -w), Vector3( 0, 0, w), radius, radius, segments)

    st.index()
    st.generate_normals()
    
    return st.commit()        
    
func gear(outerRadius, innerRadius, height, spokeCount, spokeWidthFactor, spokeLengthFactor, bottom):

    var st = SurfaceTool.new()
    
    st.begin(Mesh.PRIMITIVE_TRIANGLES)
    st.set_smooth_group(-1) # flat shading

    var h = height/2
    var spokeGapAngle = -deg_to_rad(360.0 / spokeCount)
    var spokeAngle    = spokeGapAngle * spokeWidthFactor
    var gapAngle      = spokeGapAngle * (1-spokeWidthFactor)
    var gapRadius     = innerRadius  + (outerRadius - innerRadius) * spokeLengthFactor
    
    for index in range(spokeCount):
        
        var startAngle = -deg_to_rad(index * 360.0 / spokeCount)
    
        var spokeInnerTopLeft  = Vector3(0, h, -innerRadius).rotated(Vector3.UP, startAngle)
        var spokeInnerTopRight = spokeInnerTopLeft.rotated(Vector3.UP, spokeAngle)

        var spokeOuterTopLeft  = Vector3(0, h, -outerRadius).rotated(Vector3.UP, startAngle)
        var spokeOuterTopRight = spokeOuterTopLeft.rotated(Vector3.UP, spokeAngle)

        var gapInnerTopLeft  = spokeInnerTopRight
        var gapInnerTopRight = gapInnerTopLeft.rotated(Vector3.UP, gapAngle)

        var gapOuterTopLeft  = Vector3(0, h, -gapRadius).rotated(Vector3.UP, spokeAngle + startAngle)
        var gapOuterTopRight = gapOuterTopLeft.rotated(Vector3.UP, gapAngle)
        
        quad(st, spokeOuterTopLeft, spokeOuterTopRight, spokeInnerTopRight, spokeInnerTopLeft)
        quad(st, gapOuterTopLeft, gapOuterTopRight, gapInnerTopRight, gapInnerTopLeft)
        
        var bot = Vector3(0,height,0)
        var spokeOuterBotLeft  = spokeOuterTopLeft  - bot
        var spokeOuterBotRight = spokeOuterTopRight - bot
        var spokeInnerBotRight = spokeInnerTopRight - bot
        var spokeInnerBotLeft  = spokeInnerTopLeft  - bot
        var gapOuterBotLeft    = gapOuterTopLeft    - bot
        var gapOuterBotRight   = gapOuterTopRight   - bot
        var gapInnerBotRight   = gapInnerTopRight   - bot
        var gapInnerBotLeft    = gapInnerTopLeft   - bot

        if bottom:        
            quad(st, spokeOuterBotLeft, spokeInnerBotLeft, spokeInnerBotRight, spokeOuterBotRight)
            quad(st, gapOuterBotLeft, gapInnerBotLeft, gapInnerBotRight, gapOuterBotRight)
        
        quad3(st, spokeOuterTopRight, spokeOuterTopLeft, spokeOuterBotLeft)
        quad3(st, spokeInnerTopLeft, spokeInnerTopRight, spokeInnerBotRight)
        quad3(st, gapOuterTopRight, gapOuterTopLeft, gapOuterBotLeft)
        quad3(st, gapInnerTopLeft, gapInnerTopRight, gapInnerBotRight)
        
        quad3(st, gapOuterTopLeft, spokeOuterTopRight, spokeOuterBotRight)
        quad3(st, gapOuterTopRight, gapOuterBotRight, spokeOuterBotLeft.rotated(Vector3.UP, spokeGapAngle))
    
    st.index()
    st.generate_normals()
    
    return st.commit()    
