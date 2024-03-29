use <poly.scad>

poly([ [0,0], chamfer([100,0], 20), [100, 100], fillet([0,100], 20) ]); 

translate([100,0,0])
poly([ 
  [20,0], [20,60], [40,60], [40,0],
  [0,20], [60,20], [60,40], [60,0],
], [
  [0,1,fillet(2, 10),3],
  [chamfer(4, 10), 5, 6, 7], 
]);
