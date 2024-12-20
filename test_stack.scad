use <stack.scad>

stack([["base", 2],["rim", 3],10]) {
  difference(){
    layer(["base","rim"]) circle(d=20);
    layer("rim") circle(d=18);
  }
  circle(d=4);
}
