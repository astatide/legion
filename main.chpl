use fileParser;
use systemBuilder;
use Time;
use List;
use recordCore;
use SinFF.Parameters as SIn;
use Dynamics.Lamia as Lamia;

record aTest {
  var coords: [1..3] real;
}

operator +=(ref a: aTest, b: int) {
  a.coords[1..3] += b;
}

proc main {
  var b = new owned systemBuilder.Build();
  var s = b.build();
  writeln(s);
  // go like potential or something.
  var bonded : SIn.distance = new SIn.distance(coefficients = new list([0.1]));
  var nonBonded : SIn.distance = new SIn.distance(coefficients = new list([0.001]));
  var lamia = new Lamia.SingleCore(0.002, s);
  writeln(lamia.system.molecules[0].atoms[0].pos);
  writeln("STARTING RUN!");
  lamia.run(400, bonded : SIn.forceParameters);
  //writeln(lamia.system);
  writeln(lamia.system.molecules[0].atoms[0].pos);
}

proc oldTests {
  var b = new owned systemBuilder.Build();
  var s = b.build();
  writeln(s);
  var n: int = 500000;
  var basicArray: [1..n,1..3] real;
  var testArray: [1..n,1..3] real;
  var atomArray: [1..n] aTest;
  var it: real;
  var ft: real;
  writeln("testing basic write");
  it = getCurrentTime();
  forall i in 1..n {
    basicArray[i,1..3] += i;
  }
  ft = getCurrentTime() - it;
  writeln("basic write took ", ft);
  writeln("testing record write");
  it = getCurrentTime();
  forall i in 1..n {
    atomArray[i] += 1;
  }
  ft = getCurrentTime() - it;
  writeln("atom write took ", ft);
  writeln("testing vector write");
  it = getCurrentTime();
  // almost never going to do this, however
  testArray[1..n,1..3] += basicArray;
  ft = getCurrentTime() - it;
  writeln("vector write took ", ft);

  writeln("NEW TEST!");

  var x: vector = new vector();
  var y: vector = new vector();

  x.data = [1.0,2.0,3.0];
  y.data = [4.0,5.0,6.0];
  writeln(x+y);

  var j: matrix = new matrix();
  var k: matrix = new matrix();

  j.data = 1;
  k.data = 2;
  writeln(j+k);

  var newArray: matrix = new matrix(shape = (n, 3));
  var twoArray: matrix = new matrix(shape = (n, 3));
  twoArray.data += 12;
  twoArray.data[10,..] = 4;
  twoArray.data[100..10000,1] = 5; 

  writeln("testing matrix write");
  it = getCurrentTime();
  // almost never going to do this, however
  newArray += basicArray;
  ft = getCurrentTime() - it;
  writeln("vector write took ", ft);

    writeln("testing matrix write");
  it = getCurrentTime();
  // almost never going to do this, however
  basicArray += basicArray;
  ft = getCurrentTime() - it;
  writeln("vector write took ", ft);
  writeln(basicArray.size);

  writeln(x[1]);

  //var vec = Vector(3, eltType=int) + 1;
  //var mat = Matrix(3, 3, eltType=int) + 2;
  //writeln(vec);
  //writeln("Mat!");
  //writeln(mat);
  //writeln(dot(mat, vec));

  //writeln(dot(j.data, x.data));

  
}