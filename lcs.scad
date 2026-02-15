use <origins.scad>
use <tr.scad>

$debug = false;

$lcs_stack = [];

UNIT_4 = [
  [1,0,0,0],
  [0,1,0,0],
  [0,0,1,0],
  [0,0,0,1],
];

module lcs_debug_marker(){
  let($fn=6){
    color("#f00")yzx()cylinder(d=1,h=20);
    color("#0f0")xzy()cylinder(d=1,h=20);
    color("#00f")cylinder(d=1,h=20);
  }
}

module lcs_debug_link(transformation){
  echo(transformation);
  #let(
    v=[transformation[0][3],transformation[1][3],transformation[2][3]], 
    rx=atan2(norm([v.x,v.y]),v.z), 
    rz=atan2(-v.x,v.y),
    $fn=6,
  ){
    rotate([-rx,0,rz])cylinder(d=1,h=norm(v));
  }
}

module lcs(transformation, label=undef, debug=$debug) {
  if(debug){
    lcs_debug_link(transformation);
  }
  tr(transformation) let($lcs_stack = is_undef($lcs_stack) ? [[label, transformation]] : [each $lcs_stack, [label, transformation]]){
    children();
    if(debug){
      lcs_debug_marker();
      if(is_string(label)){
        rotate([90,0,0])translate([5,5])text(label,size=7);
      }
    }
  }
}

function mult_list(l, i_start = 0, swap=false) = i_start>=len(l) ? 1 : swap ? mult_list(l, i_start+1) * l[i_start] : l[i_start] * mult_list(l, i_start+1);

function lcs_stack_index(target_frame) = is_undef($lcs_stack) 
  ? -1
  : is_num(target_frame) 
  ? (
    target_frame < 0 ? len($lcs_stack) + target_frame : target_frame
  ): let(
    indices = [for (i = [0:len($lcs_stack)-1]) if ($lcs_stack[i][0] == target_frame) i+1]
  ) len(indices) == 0 
    ? -1 
    : indices[len(indices)-1];

function reverse_stack(target_frame) = let(
  s = [ for ( i=[lcs_stack_index(target_frame):len($lcs_stack)-1]) inv_mat_aff($lcs_stack[i][1]) ],
) mult_list(s, swap=true);

function mat_transp_3(m) = [
  [m[0][0], m[1][0], m[2][0]],
  [m[0][1], m[1][1], m[2][1]],
  [m[0][2], m[1][2], m[2][2]],
];

function inv_mat_3(m) = [
  [m[1][1]*m[2][2]-m[1][2]*m[2][1],  m[0][2]*m[2][1]-m[0][1]*m[2][2],  m[0][1]*m[1][2]-m[0][2]*m[1][1]],
  [m[1][2]*m[2][0]-m[1][0]*m[2][2],  m[0][0]*m[2][2]-m[0][2]*m[2][0],  m[0][2]*m[1][0]-m[0][0]*m[1][2]],
  [m[1][0]*m[2][1]-m[1][1]*m[2][0],  m[0][1]*m[2][0]-m[0][0]*m[2][1],  m[0][0]*m[1][1]-m[0][1]*m[1][0]],
] / (
  m[0][0] * (m[1][1]*m[2][2] - m[1][2]*m[2][1])
  -m[0][1] * (m[1][0]*m[2][2] - m[1][2]*m[2][0])
  +m[0][2] * (m[1][0]*m[2][1] - m[1][1]*m[2][0])
);

function inv_mat_aff(m) = let(inv3 = mat_transp_3(m), inv_pos = -inv3 * [m[0][3], m[1][3], m[2][3]]) [
  [inv3[0][0], inv3[0][1], inv3[0][2], inv_pos.x],
  [inv3[1][0], inv3[1][1], inv3[1][2], inv_pos.y],
  [inv3[2][0], inv3[2][1], inv3[2][2], inv_pos.z],
  [0,          0,          0,          1        ],
];

