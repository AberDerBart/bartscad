# bartscad
OpenSCAD utility library

## wrap_cylinder
```
wrap_cylinder(r, h, depth, center=false, range=[0,360])
```

`wrap_cylinder` takes 2D objecs as children and "wraps" them around a cylinder with radius `r` and height `h`. 
The parameter `depth` determines the thickness of the wrapped object, going inwards from radius `r`.
The `center` parameter behaves like in the `cylinder` build-in module.
If only part of a cylinder shall be wrapped, `range` can be specified as `[<starting angle>, <end angle>]`, reducing the angle improves performance.
`wrap_cylinder` takes the special variable `$fa` or `$fn` into account (`$fs` is not supported yet, pull requests are welcome).
The area wrapped around the cylinder is the rectangle (0, 0) to (`h`, `2 * PI * r`), with smaller width depending on `range`.
