
// this is used for basic I/O, such as loading up files.
// right now, it'll just load XYZ files.

use IO;
use particles as Particles;
use recordCore;
use groupings as Groupings;
use List;

class fileLoader {
  // we shouldn't need to init anything, yeah?
  var coordFileName: string;
  var coordFileType: string;
  var nAtoms: int;
  var x: list(real);
  var y: list(real);
  var z: list(real);
  var atoms: list(Particles.Atom);
  var atomNames: list(string);
  var name: string;
  var n: int;
  var molecules: list(Groupings.molecule);
  var nMolecules: int;

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
          writeln(i,s);
          select i {
            when 1 do {atomNames.append(s);}
            when 2 do {x.append(s : real);}
            when 3 do {y.append(s : real);}
            when 4 do {z.append(s : real);}
          }
        }
        
        var a = new Particles.Atom(name=atomNames[n]);
        a.pos = [x[n],y[n],z[n]];
        a.positionInMolecule = n;
        atoms.append(a);
        n += 1;
      }
    }
    writeln(this.x);
    if n != givenN {
      writeln("Hey, your atoms don't match.");
    }
    this.nAtoms = n;
    var m = new Groupings.molecule();
    m.name = name;
    // just set to the number of atoms.  They're the same numbers.
    var mA: [1..n] int;
    for i in 1..n {
      mA[i] = i;
    }
    //m.setAtoms(mA);
    for i in 0..n-1 {
      m += atoms[i];
    }
    this.molecules.append(m);
    writeln(m);
    this.nMolecules = 1;
  }
}
