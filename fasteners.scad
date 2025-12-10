BIG=1000000;

module screwhole_profile_m3(){
  circle(d=3.4);
}

module nut_profile_m3(){
  let($fn=6){
    circle(d=6.5);
  }
}

module sunken_screw_m3(l, l_head=BIG, up=false){
  scale([1,1, up ? -1 : 1]){
    scale([1,1,-1])linear_extrude(l) screwhole_profile_m3();
    linear_extrude(l_head) circle(d=7);
  }
}

module sunken_nut_m3(l_head=BIG, up=false){
  scale([1,1,up ? 1 : -1])linear_extrude(l_head)nut_profile_m3();
}

