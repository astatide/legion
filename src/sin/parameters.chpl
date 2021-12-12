use List;
use Random;

private use Legion.Topology.System;
private use Legion.Types.RecordCore as LinAlg;
private use Legion.Types.Functions;

class forceParameters : functionBase {
  var coefficients: list(real);
  proc this(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return new LinAlg.vector(shape=(3,));
  }
}

class distance : forceParameters {
  override proc this(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    return 0.5*this.coefficients[0]*(A-B)**2;
  }
}

class brownianFakeDistance : forceParameters {
  override proc this(A: LinAlg.vector, B: LinAlg.vector): LinAlg.vector {
    var r = [0.1, 0.1, 0.1];
    fillRandom(r);
    r *= 200;
    //writeln(r);
    return 0.5*this.coefficients[0]*(A-B)**2+(new LinAlg.vector(r));
  }
}
