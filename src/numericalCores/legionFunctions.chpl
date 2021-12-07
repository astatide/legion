module LegionFunctions {
  use List;
  use Numerical.RecordCore as LinAlg;
  use Topology.Particles as Particles;

  enum FunctionalOperators {
    R
  }

  union functionCachedResult {
    var i: int;
    var r: real;
    var vec: LinAlg.vector;
    var atom: Particles.Atom;
  }

  record wrappedUnionFunctionCachedResult {
    var setField: int = -1;
    var cachedResult: functionCachedResult = new functionCachedResult();

    proc init() {}

    proc init(a: int) {
      setField = 0;
      this.complete();
      cachedResult.i = a;
    }
    proc init(a: real) {
      setField = 1;
      this.complete();
      cachedResult.r = a;
    }
    proc init(a: LinAlg.vector) {
      setField = 2;
      this.complete();
      cachedResult.vec = a;
    }
    proc init(a: Particles.Atom) {
      setField = 3;
      this.complete();
      cachedResult.atom = a;
    }
  }

  operator :(from: wrappedUnionFunctionCachedResult, type toType: int) {
    select from.setField {
      when 0 do return from.cachedResult.i;
      otherwise return 0; // TODO: We should _frankly_ throw an exception here.  Should be compile time, _unless_ we know we're compatible with the underlying data type.
    }
  }
  operator :(from: wrappedUnionFunctionCachedResult, type toType: real) {
    select from.setField {
      when 1 do return from.cachedResult.r;
      otherwise return 0.1; // TODO: We should _frankly_ throw an exception here.  Should be compile time, _unless_ we know we're compatible with the underlying data type.
    }
  }
  operator :(from: wrappedUnionFunctionCachedResult, type toType: LinAlg.vector) {
    select from.setField {
      when 2 do return from.cachedResult.vec;
      otherwise return new owned LinAlg.vector(); // TODO: We should _frankly_ throw an exception here.  Should be compile time, _unless_ we know we're compatible with the underlying data type.
    }
  }
  operator :(from: wrappedUnionFunctionCachedResult, type toType: Particles.Atom) {
    select from.setField {
      when 3 do return from.cachedResult.atom;
      otherwise return new owned Particles.Atom(); // TODO: We should _frankly_ throw an exception here.  Should be compile time, _unless_ we know we're compatible with the underlying data type.
    }  
  }

  class functionBase {
    var cachedResult: wrappedUnionFunctionCachedResult; // = new wrappedUnionFunctionCachedResult(1);
    var applicableOperators: list(FunctionalOperators);
    proc __internal__(args...?n) {
      return 0;
    }
    proc this(args...?n) {
      return this.__internal__((...args));
    }
  }

  operator *(a: FunctionalOperators, b: functionBase) {
    use FunctionalOperators;
    select a {
      when R {
        writeln("a wee tiny test!");
      }
    }
    return b.cachedResult;
  }

}