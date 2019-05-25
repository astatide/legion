// this stores our coordinates and our topology

record molecule {
  var name: string;
  var nAtoms: int;
  var startingAtom: int;

  iter atoms {
    // this will yield our atoms.
    for i in startingAtom..startingAtom+nAtoms-1 {
      yield i;
    }
  }

  proc setAtoms(a: [] int) {
    this.nAtoms = a.size;
    // remember, this is Chapel, so things start with 1 by default yay.
    this.startingAtom = a[1];
  }
}

class System {
  var n: int;
  var nMolecules: int;
  var coords: [0..n-1, 0..2] real;
  var atoms: [0..n-1] string;
  var molecules: [0..nMolecules-1] molecule;
  var currentAtoms: int;
  var currentMolecules: int;

  proc init(n: int, nMolecules: int) {
    // set the number of atoms.
    this.n = n;
    this.nMolecules = nMolecules;
  }

  proc setCoords(x: [0..n-1] real, y: [0..n-1] real, z: [0..n-1] real) {
    for i in 0..n-1 {
      coords[i,0] = x[i];
      coords[i,1] = y[i];
      coords[i,2] = z[i];
    }
    currentAtoms = n;
  }

  proc addCoords(x: [] real, y: [] real, z: [] real) {
    var j = currentAtoms;
    for i in 0..x.domain.size-1 {
      coords[i+j,0] = x[i];
      coords[i+j,1] = y[i];
      coords[i+j,2] = z[i];
    }
  }

  proc setAtoms(a: [] string) {
    for i in 0..n-1 {
      atoms[i] = a[i+1];
    }
    currentAtoms = n;
  }

  proc addAtoms(a: [] string) {
    var j = currentAtoms;
    for i in 0..a.domain.size-1 {
      atoms[i+j] = a[i];
    }
  }

  proc addMolecules(m: [] molecule) {
    var j = currentMolecules;
    for i in 0..m.domain.size-1 {
      molecules[i+j] = m[i];
      molecules[i+j].startingAtom += j;
    }
  }

  /*
  iter molecules {
    // give to us the molecules~
    // yesss
    for i in 0..nMolecules-1 {
      yield this.molecules[i];
    }
  }*/
}
