
use UnitTest;

private use Legion.Types.Functions;
private use Legion.Types.Functions.FunctionalOperators;

proc main() {
    var test: functionBase = new owned functionBase();
    var initialResult = test(0);
    var blah = R*test;
    writeln(blah : int);
}