use List;
use newLinearAlgebra;

record Atom {
  var name: string;
  var mass: real;
  var pos: vector = new vector(shape=(3,));
  var UUID: string;
  var positionInMolecule: int;
  var parentMoleculeUUID: string;
  var globalIndex: int;
}


