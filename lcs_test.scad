use <lcs.scad>
use <tr.scad>

lcs(t(-20,30,10),label="foo", debug=true){
  lcs(rx(20)*rz(30)*tx(10), debug=true, label="bar"){
    echo(len($lcs_stack));
    echo(index=lcs_stack_index("bar"));
    tr(reverse_stack("bar"))cube(10);
  echo(
    [
      for (
        i=[lcs_stack_index("bar"):len($lcs_stack)-1]
      ) $lcs_stack[i][1]
    ],
  );
  }
}

