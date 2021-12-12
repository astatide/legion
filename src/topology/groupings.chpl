use List;

private use Legion.Topology.Particles as Particles;

// these are simply called groups; they _may_ be molecules, but they are also non bonded groups of atoms
// it's a calculation convenience in a lot of ways; it'll give us a 'window' of atoms.

record molecule {
  var name: string;
  var mass: real;
  var UUID: string;
  var globalMoleculeIndex: int;
  var atoms: list(Particles.Atom);
  var _bonds: domain((int, int));
  var bonds: [_bonds] string;

  proc init() {
    this.complete();
  }

  proc init(a: Particles.Atom) {
    this.complete();
    add(a);
  }

  proc add(ref a: Particles.Atom) {
    a.positionInMolecule = atoms.size;
    a.parentMoleculeUUID = '12'; //UUID;
    atoms.append(a);
  }
}

operator +=(ref mol: molecule, ref a: Particles.Atom) {
  mol.add(a);
}

operator +(ref mol: molecule, a: Particles.Atom) {
  var newMol: molecule = mol;
  var newAtom: Particles.Atom = a;
  // why do we need explicit copies of this record?  Hmmmm.  Odd.
  // oh, maybe cause... try it now, Audrey.
  newMol.add(a);
  return newMol;
}