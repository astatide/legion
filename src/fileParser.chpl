// this is used for basic I/O, such as loading up files.
// right now, it'll just load XYZ files.

use IO;
use topology;

class fileLoader {
  // we shouldn't need to init anything, yeah?
  var coordFileName: string;
  var coordFileType: string;
  var nAtoms: int;
  var x: [1..0] real;
  var y: [1..0] real;
  var z: [1..0] real;
  var atoms: [1..0] string;
  var name: string;
  var n: int;
  var molecules: [1..0] topology.molecule;
  var nMolecules: int;

  proc center(c: int = 1) {
    // n is for which atom to center on.
    var iX = x[c], iY = y[c], iZ = z[c];
    for i in 1..nAtoms {
      x[i] -= iX;
      y[i] -= iY;
      z[i] -= iZ;
    }
  }

  proc loadXYZ(fileName: string) {
    // first, we'll load up the file... we should catch the error.
    var style: iostyle;
    var f = open(fileName, iomode.r, hints=IOHINT_SEQUENTIAL);
    var r = f.reader();
    n = -2;
    var givenN: int;
    var coord: [1..3] real;
    var lastMolecule: string;
    // iterate through the lines
    for line in f.lines() {
      // first line is a comment, second is the number of atoms we _think_ are there.
      // we don't have to take that as gospel.
      if n == -2 {
        name = line;
        n += 1;
      } else if n == -1 {
        givenN = line: int;
        n += 1;
      } else {
        var lineArray: [1..0] string;
        for (i,s) in zip(1.., line.split()) {
          select i {
            when 1 do atoms.push_back(s);
            when 2 do x.push_back(s : real);
            when 3 do y.push_back(s : real);
            when 4 do z.push_back(s : real);
          }
        }
        n += 1;
      }
    }
    if n != givenN {
      writeln("Hey, your atoms don't match.");
    }
    this.nAtoms = n;
    var m = new topology.molecule();
    m.name = name;
    // just set to the number of atoms.  They're the same numbers.
    var mA: [1..n] int;
    for i in 1..n {
      mA[i] = i;
    }
    m.setAtoms(mA);
    this.molecules.push_back(m);
    this.nMolecules = 1;
  }
}
