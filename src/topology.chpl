// this stores our coordinates and our topology

class System {
  var n: int;
  var coords: [0..n-1, 0..2] real;
  var atoms: [0..n-1] string;

  proc init(n: int) {
    // set the number of atoms.
    this.n = n;
  }

  proc setCoords(x: [0..n-1] real, y: [0..n-1] real, z: [0..n-1] real) {
    for i in 0..n-1 {
      coords[i,0] = x[i];
      coords[i,1] = y[i];
      coords[i,2] = z[i];
    }
  }

  proc setAtoms(a: [] string) {
    for i in 0..n-1 {
      atoms[i] = a[i];
    }
  }
}
