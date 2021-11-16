use List;
use Topology.System;
use Numerical.RecordCore as LinAlg;

record NEWTopology {
  var n: int;
  var atomMass: [1..n] real;
  var bondedForces: [1..n,1..n] owned forceParameters;
}


class forceParameters {
  var coefficients: list(real);
  proc calculate(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return A;
  }
}

class distance : forceParameters {
  override proc calculate(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return 0.5*this.coefficients[0]*(A-B)**2;
  }
}