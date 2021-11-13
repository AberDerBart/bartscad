
function deg_to_rad(a) = a * PI / 180;
function rad_to_deg(a) = a * 180 / PI;

module wrap_cylinder(r, h, depth, center=false, range=[0, 360]) {
  $effective_fa = ($fn != 0) ? 360/$fn : $fa;

  $step = deg_to_rad($effective_fa);
  $r = r * cos($effective_fa / 2);
  $r_i = (r-depth) * cos($effective_fa / 2);

  $strip_width = r * sin($effective_fa / 2) * 2;
  echo(strip_width=$strip_width);

  module strip(a) {
    translate([-a * $strip_width/$step - $strip_width/2,0,0]) intersection(){
      children();
      translate([a * $strip_width/$step, center ? -h/2 : 0,0]) square([$strip_width, h]);
    }
  }
  
  for($a=[deg_to_rad(range[0]) : $step : deg_to_rad(range[1]) - $step]) {
    rotate([90, 0, 90 + rad_to_deg($a + $step/2)])
      translate([0,0,$r])
      mirror([0,0,1])
      linear_extrude(depth, scale=[$r_i / $r, 1])
      strip($a)
      children();
  }
}
