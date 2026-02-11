
function r(x=0,y=0,z=0) = [
  [cos(z)*cos(y), cos(z)*sin(y)*sin(x)-sin(z)*cos(x), cos(z)*sin(y)*cos(x)+sin(z)*sin(x), 0],
  [sin(z)*cos(y), sin(z)*sin(y)*sin(x)+cos(z)*cos(x), sin(z)*sin(y)*cos(x)-cos(z)*sin(x), 0],
  [-sin(y),       cos(y)*sin(x),                      cos(y)*cos(x),                      0],
  [0,             0,                                  0,                                  1],
];

function rx(x) = r(x=x);
function ry(y) = r(y=y);
function rz(z) = r(z=z);

function t(x=0,y=0,z=0) = [
  [1,0,0,x],
  [0,1,0,y],
  [0,0,1,z],
  [0,0,0,1],
];

function tx(x) = t(x=x);
function ty(y) = t(y=y);
function tz(z) = t(z=z);

function s(x=1, y=1, z=1) = [
  [x,0,0,0],
  [0,y,0,0],
  [0,0,z,0],
  [0,0,0,1],
];

function sx(x) = s(x=x);
function sy(y) = s(y=y);
function sz(z) = s(z=z);

module tr(m) {
  multmatrix(m) children();
}

function d2(p) = [p.x, p.y];
function d3(p) = [p.x, p.y, len(p) > 2 ? p.z : 0];
function d4(p) = [p.x, p.y, len(p) > 2 ? p.z : 0, 1];
