use <origins.scad>

module sweep(path){
  // straight sections
  for(i=[0:len(path)-2]) let(
    p1=path[i],
    p2=path[i+1],
    seg=p2-p1,
    rz=atan2(seg.y,seg.x),
    l=norm(p2-p1)
  ) {
    translate(p1)rotate([0,0,rz])yzx()linear_extrude(l)scale([-1,1])children();
    if (i < len(path)-2) {
      let(p3=path[i+2], seg2=p3-p2, rz_end=atan2(seg2.y,seg2.x),curve_angle=rz_end > rz ? rz_end-rz : rz_end-rz + 360) {
        translate(p2)rotate([0,0,0])rotate_extrude(angle=curve_angle, start=rz-90)children();
      }
    }
  }
}
