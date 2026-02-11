include <rotex.scad>

f = function(a) [[100,10*sin(5*a)],[100,10+10*sin(5*a)],[110,10 * sin(5*a)]];

rotex_open(f, 0,360, 360);

