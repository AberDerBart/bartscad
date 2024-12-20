# bartscad
OpenSCAD utility library

## wrap_cylinder
```
use <bartscad/wrap.scad>

wrap_cylinder(r, h, depth, center=false, range=[0,360]);
```

`wrap_cylinder` takes 2D objecs as children and "wraps" them around a cylinder with radius `r` and height `h`. 
The parameter `depth` determines the thickness of the wrapped object, going inwards from radius `r`.
The `center` parameter behaves like in the `cylinder` build-in module.
If only part of a cylinder shall be wrapped, `range` can be specified as `[<starting angle>, <end angle>]`, reducing the angle improves performance.
`wrap_cylinder` takes the special variable `$fa` or `$fn` into account (`$fs` is not supported yet, pull requests are welcome).
The area wrapped around the cylinder is the rectangle (0, 0) to (`h`, `2 * PI * r`), with smaller width depending on `range`.

For an example, see [test.scad](test.scad).

## poly
```
use <bartscad/poly.scad>

poly([ [0,0], chamfer([100,0], 20), [100, 100], fillet([0,100], 20) ]);
poly([ 
  [20,0], [20,60], [40,60], [40,0],
  [0,20], [60,20], [60,40], [60,0],
], [
  [0,1,fillet(2, 10),3],
  [chamfer(4, 10), 5, 6, 7],
]);
```

`poly` is a drop-in replacement for the builtin module `polygon` with support for chamfers and fillets.
If specifying only points, just replace a point with a `chamfer` or `fillet` function with the point and radius or distance to corner as parameters to apply it to that corner. 
When working with paths, provide the points as usual and use the `chamfer` and `fillet` functions on the point indices provided in the `paths` parameter.

## stack
```
use <bartscad/stack.scad>

stack([10,["center", 3], ["top", 10]]){
  difference(){
    circle(d=10);
    layer([0,"top"]) circle(d=5);
  }
}
```

`stack` `linear_extrude`s its children in multiple layers stacked on top of each other.
As an argument, an array containing the layers (from bottom to top) must be provided.
Layers are specified as `<height>` or `[<label>, <height>]`.
Children can be limited to specific layers by wrapping them in the `layer` module which takes a layer index, a layer label or an array of indices and or labels as argument.
The above example renders a cylinder with circular indents on either end.
