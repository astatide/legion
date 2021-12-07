use List;
use Topology.System;
use Numerical.RecordCore as LinAlg;
use Random;

record NEWTopology {
  var n: int;
  var atomMass: [1..n] real;
  var bondedForces: [1..n,1..n] owned forceParameters;
}

class functionBase {
  proc __internal__(args...?n) {
    return 0;
  }

  proc this(args...?n) {
    return this.__internal__((...args));
  }
}

class forceParameters : functionBase {
  var coefficients: list(real);
  proc __internal__(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return new LinAlg.vector(shape=(3,));
  }

  proc this(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return this.__internal__(A, B);
  }
}

class distance : forceParameters {
  override proc __internal__(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return 0.5*this.coefficients[0]*(A-B)**2;
  }
}

class brownianFakeDistance : forceParameters {
  override proc __internal__(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    var r = [0.1, 0.1, 0.1];
    fillRandom(r);
    r *= 200;
    //writeln(r);
    return 0.5*this.coefficients[0]*(A-B)**2+(new LinAlg.vector(r));
  }
}
