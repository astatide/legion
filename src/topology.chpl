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
  var coords: [1..n, 1..3] real;
  var atoms: [1..n] string;
  var molecules: [1..nMolecules] molecule;
  var currentAtoms: int;
  var currentMolecules: int;

  proc init(n: int, nMolecules: int) {
    // set the number of atoms.
    this.n = n;
    this.nMolecules = nMolecules;
  }

  proc setCoords(x: [1..n] real, y: [1..n] real, z: [1..n] real) {
    for i in 1..n {
      coords[i,1] = x[i];
      coords[i,2] = y[i];
      coords[i,3] = z[i];
    }
    currentAtoms = n;
  }

  proc addCoords(x: [] real, y: [] real, z: [] real) {
    var j = currentAtoms;
    for i in 1..x.domain.size {
      coords[i+j,1] = x[i];
      coords[i+j,2] = y[i];
      coords[i+j,3] = z[i];
    }
  }

  proc setAtoms(a: [] string) {
    for i in 1..n {
      atoms[i] = a[i];
    }
    currentAtoms = n;
  }

  proc addAtoms(a: [] string) {
    var j = currentAtoms;
    for i in 1..a.domain.size {
      atoms[i+j] = a[i];
    }
  }

  proc addMolecules(m: [] molecule) {
    var j = currentMolecules;
    for i in 1..m.domain.size {
      molecules[i+j] = m[i];
      molecules[i+j].startingAtom += currentAtoms;
    }
  }

  proc center(c: int = 1) {
    // n is for which atom to center on.
    // this centers the entire system on one.
    var iX = coords[c,1], iY = coords[c,2], iZ = coords[c,3];
    for i in 1..n {
      coords[i,1] -= iX;
      coords[i,2] -= iY;
      coords[i,3] -= iZ;
    }
  }

  proc center(sA: int = 1, m: molecule) {
    // n is for which atom to center on.
    // this centers just the molecule.
    var c = m.atoms[sA];
    var iX = coords[c,1], iY = coords[c,2], iZ = coords[c,3];
    for i in m.startingAtom..m.startingAtom+m.nAtoms {
      coords[i,1] -= iX;
      coords[i,2] -= iY;
      coords[i,3] -= iZ;
    }
  }
}
