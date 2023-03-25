FILLET="FILLET";
CHAMFER="CHAMFER";

function fillet(point, r) = [FILLET, point, r];
function chamfer(point, r) = [CHAMFER, point, r];

function _isSpecial(x) = is_list(x) && len(x) == 3;
function _isFillet(x) = _isSpecial(x) && x[0] == FILLET;
function _isChamfer(x) = _isSpecial(x) && x[0] == CHAMFER;

function _fa(r) = $fn > 3 ? 360 / $fn : $fa; // TODO: involve $fs

function _point(x) = _isSpecial(x) ? x[1] : x;

function _addVec(v1, v2) = [v1.x + v2.x, v1.y + v2.y];

function _rotatePoint(p, a) = [[cos(a), -sin(a)], [sin(a), cos(a)]] * p;

function _vec(p1, p2) = _addVec(-p1, p2) / norm(_addVec(-p1,p2));

function _alpha(p0, p, p2) = (360 + (atan2(p.y-p2.y, p.x-p2.x) - atan2(p.y-p0.y, p.x-p0.x))) % 360;

function _isLeftCorner(p0, p, p2) = (360 + _alpha(p0, p, p2)) % 360 >= 180;

function _offsetPoint(p, p2, d) = _addVec(p, (_vec(p, p2) * d));

function _filletEnd(pp, f, pn) = _offsetPoint(_point(f), pp, abs(f[2] / tan(abs(_alpha(pp, _point(f), pn) / 2))));
function _filletCenter(pp, f, pn) = _filletEnd(pp, f, pn) + _rotatePoint(_vec(_point(f), pp) * f[2], _isLeftCorner(pp, _point(f), pn) ? -90 : 90);

function _filletCurveAngle(pp, f, pn) = _alpha(pp, _point(f), pn) > 180 ? _alpha(pp, _point(f), pn) - 180 : 180 - _alpha(pp, _point(f), pn);

function _filletPoint(pp, f, pn, angle) = _filletCenter(pp, f, pn) + _rotatePoint(_vec(pp, _point(f)) * f[2], _isLeftCorner(pp, _point(f), pn) ? angle - 90 : 90 - angle);

function _expandFillet(pp, fillet, pn) = [
  _filletEnd(pp, fillet, pn),
  each [ for (a = [ 0 : _fa(fillet[2]) : _filletCurveAngle(pp, fillet, pn)]) _filletPoint(pp, fillet, pn, a) ],
  _filletEnd(pn, fillet, pp),
];

function _expandChamfer(pp, c, pn) = [ _offsetPoint(_point(c), pp, c[2]), _offsetPoint(_point(c), pn, c[2]) ];

function _expand(pp, x, pn) = _isFillet(x) ? _expandFillet(pp, x, pn) : _isChamfer(x) ? _expandChamfer(pp, x, pn) : [x];


module poly(points) {
  actualPoints = [ for (i = [0: len(points)-1]) each _expand( _point(points[(i-1+len(points)) % len(points)]), points[i], _point(points[(i+1) % len(points)])) ];

  polygon(actualPoints);
}
