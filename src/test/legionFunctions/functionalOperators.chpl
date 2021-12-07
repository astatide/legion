
use UnitTest;
use LegionFunctions;
use FunctionalOperators;

proc main() {
    var test: functionBase = new owned functionBase();
    var initialResult = test(0);
    var blah = R*test;
    writeln(blah : int);
}