function sum(l, start=0, end=undef) = let(last = is_undef(end) ? len(l) : end) start == last ? 0 : l[start] + sum(l, start+1, end);

module stack(slices=[]) {
  for($layer_index=[0:len(slices)-1]) {
    translate([0,0,sum(slices, end=$layer_index)]){
      linear_extrude(slices[$layer_index]) children();
    }
  }
}

module layer(layers) {
  assert(!is_undef($layer_index), "layer must be nested in stack");

  if(layers == $layer_index || search($layer_index, layers) != []) {
    children();
  }
}
