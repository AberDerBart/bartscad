use <poly.scad>
use <sweep.scad>

POLY=[
  [0,0],
  [30,0],
  [30,30],
  [0,30],
  [0,0],
];

sweep(POLY){
  poly([
    [0,0],
    fillet([10,0],10),
    [10,20],
    [0,20],
  ]);
}

//linear_extrude(20)poly(POLY);
