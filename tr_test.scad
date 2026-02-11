use <tr.scad>

multmatrix(r(40,60,110))cube(10);
#rotate([40,60,110])cube(10);

translate([100,0,0]){
  multmatrix(t(10,20,30))cube(10);
  #translate([10,20,30])cube(10);
}

translate([-100,0,0]){
  multmatrix(s(2,3,4))cube(10);
  #scale([2,3,4])cube(10);
}

multmatrix(rz(30)*tx(50))cube(10);
#rotate([0,0,30])translate([50,0,0])cube(10);
