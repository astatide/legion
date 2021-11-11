use List;
use particles as Particles;

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
    a.parentMoleculeUUID = UUID;
    atoms.append(a);
  }
}

operator +=(ref mol: molecule, ref a: Particles.Atom) {
  mol.add(a);
}