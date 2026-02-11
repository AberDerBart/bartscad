use <ex.scad>

module rotex_open(f, start, angle, segments) {
  let(
    layers = [for (a=[start:angle/segments:start+angle]) 
      [for (p=f(a)) [p.x * cos(a), p.x*sin(a), p.y]],
    ],
  ){
    ex(layers);
    for (l=layers) echo(l);
  }
}

