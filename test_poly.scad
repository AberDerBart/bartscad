use <poly.scad>

poly([
  chamfer([0, 0],20),
  [0, 100],
  [50, 100],
  fillet([50, 50], 20),
  [100, 50],
  [100, 0],
]);


