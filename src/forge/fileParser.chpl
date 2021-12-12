
// this is used for basic I/O, such as loading up files.
// right now, it'll just load XYZ files.

use IO;
use List;

private use Legion.Topology.Particles as Particles;
private use Legion.Types.RecordCore;
private use Legion.Topology.System as SystemMod;
private use Legion.Topology.Groups as Groupings;

class fileLoader {
  // we shouldn't need to init anything, yeah?
  var coordFileName: string;
  var coordFileType: string;
  var nAtoms: int;
  var atoms: list(Particles.Atom);
  var atomNames: list(string);
  var name: string;
  var n: int;
  var molecules: list(Groupings.molecule);
  var nMolecules: int;
  var f: file;
  var offset: int;

  proc loadXYZ(fileName: string) {
    // first, we'll load up the file... we should catch the error.
    var style: iostyle;
    var f = open(fileName, iomode.r, hints=IOHINT_SEQUENTIAL);
    var r = f.reader();
    var givenN: int;
    // iterate through the lines
    for (n, line) in zip(-2.., f.lines()) {
      // first line is a comment, second is the number of atoms we _think_ are there.
      // we don't have to take that as gospel.
      if n == -2 {
        name = line;
      } else if n == -1 {
        givenN = line: int;
      } else {
        var lineArray = line.split();
        var a = this.atomFromXYZ(lineArray, n);
        writeln(a);
        atoms.append(a);
      }
      this.nAtoms = n;
    }
    if this.nAtoms != givenN {
      writeln("Hey, your atoms don't match.");
    }
    var m = new Groupings.molecule();
    m.name = name;
    // just set to the number of atoms.  They're the same numbers.
    var mA: [1..this.nAtoms] int;
    for i in 1..this.nAtoms {
      mA[i] = i;
    }
    //m.setAtoms(mA);
    for i in 0..this.nAtoms-1 {
      m += atoms[i];
    }
    this.molecules.append(m);
    writeln(m);
    this.nMolecules = 1;
  }

  proc atomFromXYZ(lineArray: [] string, positionInMolecule: int = 0): Particles.Atom {
    var newAtom = new Particles.Atom(name=lineArray[0]);
    newAtom.pos = [lineArray[1]: real, lineArray[2]: real, lineArray[3]: real];
    newAtom.positionInMolecule = positionInMolecule;
    return newAtom;
  }

  iter yieldAtomsFromXYZ(fileName: string) ref : Particles.Atom {
    // first, we'll load up the file... we should catch the error.
    var style: iostyle;
    var f = open(fileName, iomode.r, hints=IOHINT_SEQUENTIAL);
    var r = f.reader();
    // iterate through the lines
    for (n, line) in zip(-2.., f.lines()) {
      // first line is a comment, second is the number of atoms we _think_ are there.
      // we don't have to take that as gospel.
      if n == -2 {
        //name = line;
      } else if n == -1 {
        //givenN = line: int;
      } else {
        var lineArray = line.split();
        this.nAtoms = n;
        yield this.atomFromXYZ(lineArray, n);
      }
    }
    r.close();
    f.close();
  }

  proc startTrajectoryFile(system: SystemMod.System, fileName: string) {
    this.f = open(fileName + '.xyz', iomode.cw, hints=IOHINT_SEQUENTIAL);
    var w = this.f.writer();
    w.writeln(system.molecules[0].name);
    w.writeln(system.nAtoms);
    this.offset = w.offset();
    w.close();
  }

    proc writeSystemToOpenFile(system: SystemMod.System) {
    var w = this.f.writer(start=this.offset);
    for mol in system.molecules {
      for atom in mol.atoms {
        w.writeln(atom.name, ' ', atom.pos[0], ' ', atom.pos[1], ' ', atom.pos[2]);
      }
    }
    this.offset = w.offset();
    w.close();
  }

  proc closeTrajectoryFile() {
    this.f.close();
  }

  proc exportSystemToXYZ(system: SystemMod.System, fileName: string) {
    //var style: iostyle;
    var f = open(fileName + '.xyz', iomode.cw, hints=IOHINT_SEQUENTIAL);
    var w = f.writer();
    w.writeln(system.molecules[0].name);
    w.writeln(system.nAtoms);
    for mol in system.molecules {
      for atom in mol.atoms {
        w.writeln(atom.name, ' ', atom.pos[0], ' ', atom.pos[1], ' ', atom.pos[2]);
      }
    }
    w.close();
    f.close();
  }
}
