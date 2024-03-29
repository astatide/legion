// this stores our coordinates and our topology
use List;

private use Legion.Topology.Particles as Particles;
private use Legion.Topology.Groups as Groups;
private use Legion.SIn.Parameters as SIn;
private use Legion.Types.TupleCore as LinAlg;


class SystemTopology {
  var n: int;
  var atomMass: [1..n] real;
  var pairwiseForcesDomain: domain((int, int));
  var bondedForces: [pairwiseForcesDomain] list(borrowed SIn.forceParameters);
  var nonBondedForces: list(borrowed SIn.forceParameters);

}

class System {
  var nMolecules: int = 0;
  var nAtoms: int = 0;
  var molecules: list(Groups.molecule);
  var topology: owned SystemTopology?; // nil it, because we don't know if/when/what it will be initialized.
  

  proc init(nMolecules: int) {
    // set the number of atoms.
    this.nMolecules = nMolecules;
  }

  proc init(molecules: list(Groups.molecule)) {
    this.molecules = molecules;
    this.complete();
    this.nMolecules = molecules.size;
    this.nAtoms = this.molecules.atoms.size;
  }

  proc init(mol: Groups.molecule) {
    this.complete(); // gotta do this or the list isn't finished being initialized.
    this.molecules.append(mol);
    this.nMolecules = 1;
  }

  proc addMolecules(molecules: list(Groups.molecule)) {
    this.molecules += molecules;
    this.nMolecules += molecules.size;
    this.nAtoms = this.molecules.atoms.size;
    return this.molecules.size;
  }

  proc addMolecules(mol: Groups.molecule) {
    this.molecules.append(mol);
    this.nMolecules += 1;
    this.nAtoms = lambda() { var a: int = 0; for mol in this.molecules.these() { a += mol.atoms.size; } return a; }();
    return this.nMolecules;
  }

  proc center(moleculeIndex: int, atomIndex: int = 0) {
  // n is for which atom to center on.
  // this centers the entire system on one.
  var moll= this.molecules[moleculeIndex];
  var atom = moll.atoms[atomIndex];
  var iX = atom.pos[0], iY = atom.pos[1], iZ = atom.pos[2];
  for mol in this.molecules {
    for atom in mol.atoms {
      atom.pos -= [iX, iY, iZ];
    }
  }
}

//proc center(sA: int = 1, m: molecule) {
  // n is for which atom to center on.
  // this centers just the molecule.
//  var c = m.atoms[sA];
//  var iX = coords[c,1], iY = coords[c,2], iZ = coords[c,3];
//  for i in m.startingAtom..m.startingAtom+m.nAtoms {
//    coords[i,1] -= iX;
//    coords[i,2] -= iY;
//    coords[i,3] -= iZ;
//  }
}

