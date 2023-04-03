FILLET="FILLET";
CHAMFER="CHAMFER";

function fillet(point, r) = [expand_fillet, point, [r]];
function chamfer(point, r) = [expand_chamfer, point, [r]];

function _is_expandable(x) = is_list(x) && len(x) == 3;

function _fa(r) = $fn > 3 ? 360 / $fn : $fa; // TODO: involve $fs

function _point(x) = _is_expandable(x) ? x[1] : x;

function _addVec(v1, v2) = [v1.x + v2.x, v1.y + v2.y];

function _rotatePoint(p, a) = [[cos(a), -sin(a)], [sin(a), cos(a)]] * p;

function _vec(p1, p2) = _addVec(-p1, p2) / norm(_addVec(-p1,p2));

function _alpha(p0, p, p2) = (360 + (atan2(p.y-p2.y, p.x-p2.x) - atan2(p.y-p0.y, p.x-p0.x))) % 360;

function _isLeftCorner(p0, p, p2) = (360 + _alpha(p0, p, p2)) % 360 >= 180;

function _offsetPoint(p, p2, d) = _addVec(p, (_vec(p, p2) * d));

function _filletEnd(pp, p, pn, r) = _offsetPoint(p, pp, abs(r / tan(abs(_alpha(pp, p, pn) / 2))));
function _filletCenter(pp, p, pn, r) = _filletEnd(pp, p, pn, r) + _rotatePoint(_vec(p, pp) * r, _isLeftCorner(pp, p, pn) ? -90 : 90);

function _filletCurveAngle(pp, p, pn) = _alpha(pp, p, pn) > 180 ? _alpha(pp, p, pn) - 180 : 180 - _alpha(pp, p, pn);

function _filletPoint(pp, p, pn, r, angle) = _filletCenter(pp, p, pn, r) + _rotatePoint(_vec(pp, p) * r, _isLeftCorner(pp, p, pn) ? angle - 90 : 90 - angle);

function _expandFillet(p0, p, p2, r) = [
  _filletEnd(p0, p, p2, r),
  each [ for (a = [ _fa(r) : _fa(r) : _filletCurveAngle(p0, p,  p2) ]) _filletPoint(p0, p, p2, r, a) ],
  _filletEnd(p2, p, p0, r),
];

expand_fillet = function (p0, p, p2, params) _expandFillet(p0, p, p2, params[0]);

expand_chamfer = function (p0, p, p2, params) [ _offsetPoint(p, p0, params[0]), _offsetPoint(p, p2, params[0]) ];

function _expand(pp, x, pn) = is_function(x[0]) ? x[0](_point(pp), x[1], _point(pn), x[2]) : [x];


module poly(points, paths = undef, convexity = undef) {
  module basic(ps) {
    actualPoints = [ for (i = [0: len(ps)-1]) each _expand( _point(ps[(i-1+len(ps)) % len(ps)]), ps[i], _point(ps[(i+1) % len(ps)])) ];
    polygon(actualPoints, paths=undef, convexity = convexity);
  }

  module intersect() {
    difference(){
      children(0);
      children(1);
    }
    difference(){
      children(1);
      children(0);
    }
  }

  function path_points(points, path) = [ for (i = path) _is_expandable(i) ? [ i[0], points[i[1]], i[2] ] : points[i] ];

  if (is_undef(paths)) {
    basic(points);
  } else {
    assert(is_list(paths), "paths must be a list");
    for(p = points) {
      assert(is_list(p) && len(p) >=2 && is_num(p.x) && is_num(p.y), "if paths are specified, all points must be vecs");
    }

    if (len(paths) == 1) {
      assert(is_list(paths[0]), "every path must be a list");
      basic(path_points(points, paths[0]));
    } else if (len(paths) > 1) {
      intersect() {
        basic(path_points(points, paths[0]));
        poly(points, [ for (i = [1:1:len(paths)-1]) paths[i] ], convexity);
      }
    }
  }
}
