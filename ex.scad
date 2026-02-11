
module ex(layers) {
  assert(
    is_list(layers) && len(layers) >=2 && is_list(layers[0]), 
    "layers must be a list of at least 2 lists of points",
  );
  assert(
    len([for (l=layers) if (len(l) != len(layers[0])) l]) == 0,
    "all layers must have the same number of points"
  );
  let(
    n_points = len(layers[0]),
    start_face = [for (i = [0:n_points-1]) i],
    end_face = [for (i = [0:n_points-1]) i + n_points * (len(layers)-1)],
    intermediate_faces = [for (l = [0:len(layers)-2]) each
      [for (i = [0:n_points-1]) 
        [
          l * n_points + i,
          l * n_points + (i + 1) % n_points,
          (l + 1) * n_points + (i + 1) % n_points,
          (l + 1) * n_points + i,
        ]
      ]
    ],
  ){
    polyhedron([each each layers], [start_face, each intermediate_faces, end_face]);
  }
}
