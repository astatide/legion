module LegionFunctions {
  use List;

  enum FunctionalOperators {
    R
  }

  union functionCachedResult {
    var i: int;
    var r: real;
  }

  class functionBase {
    var cachedResult: functionCachedResult;
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