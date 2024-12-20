function layer_height(layer) = is_num(layer) ? layer : layer[1];
function layer_label(layer) = is_list(layer) ? layer[0] : undef;

function sum(l, start=0, end=undef) = let(last = is_undef(end) ? len(l) : end) start == last ? 0 : layer_height(l[start]) + sum(l, start+1, end);

module stack(layers=[]) {
  for($layer_index=[0:len(layers)-1]) {
    translate([0,0,sum(layers, end=$layer_index)]){
      let(
        layer = layers[$layer_index], 
        height = is_num(layer) ? layer : layer[1], 
        $layer_label = is_list(layer) ? layer[0] : undef
      ){
        assert(
          is_num(layer) 
          || is_list(layer) && len(layer) == 2 && is_string(layer[0]) && is_num(layer[1]), 
          "layers must be either <height> or [<label>, <height>]"
        );
        linear_extrude(height) children();
      }
    }
  }
}

function layer_active(layer) = layer == $layer_index || layer == $layer_label;

function any_layer_active(layers) = is_list(layers)
  ? search($layer_index, layers) != [] || search([$layer_label], layers) != [[]]
  : layer_active(layers);

module layer(layers) {
  assert(!is_undef($layer_index), "layer must be nested in stack");

  if(any_layer_active(layers)) {
    children();
  }
}
