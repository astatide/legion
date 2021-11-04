use fileParser;
use systemBuilder;
use Time;

record aTest {
  var coords: [1..3] real;
}

proc +=(ref a: aTest, b: int) {
  a.coords[1..3] += b;
}

proc main {
  var b = new owned systemBuilder.Build();
  var s = b.build();
  writeln(s);
  var n: int = 500000;
  var basicArray: [1..n,1..3] real;
  var atomArray: [1..n] aTest;
  var it: real;
  var ft: real;
  writeln("testing basic write");
  it = getCurrentTime();
  for i in 1..n {
    basicArray[i,1..3] += i;
  }
  ft = getCurrentTime() - it;
  writeln("basic write took ", ft);
  writeln("testing record write");
  it = getCurrentTime();
  for i in 1..n {
    atomArray[i] += i;
  }
  ft = getCurrentTime() - it;
  writeln("atom write took ", ft);
  writeln("testing vector write");
  it = getCurrentTime();
  // almost never going to do this, however
  basicArray[1..n,1..3] += 1;
  ft = getCurrentTime() - it;
  writeln("vector write took ", ft);
}
