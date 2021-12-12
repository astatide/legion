use List;

private use Legion.Types.TupleCore as LinAlg;

record Atom {
  var name: string;
  var mass: real;
  var pos: vector = new LinAlg.vector(shape=(3,));
  var vel: vector = new LinAlg.vector(shape=(3,));
  var UUID: string;
  var positionInMolecule: int;
  var parentMoleculeUUID: string;
  var globalIndex: int;
}


