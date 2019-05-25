// this is used for basic I/O, such as loading up files.
// right now, it'll just load XYZ files.

use IO;
use topology;

class Loader {
  // we shouldn't need to init anything, yeah?
  var coordFileName: string;
  var coordFileType: string;
  var nAtoms: int;
  var x: [0..-1] real;
  var y: [0..-1] real;
  var z: [0..-1] real;
  var atoms: [0..-1] string;
  var name: string;

  proc loadXYZ(fileName: string) {
    // first, we'll load up the file... we should catch the error.
    var style: iostyle;
    //style.string_format = 1;
    //style.str_style = stringStyleTerminated(10 : uint(8));
    //style = new iostyle(str_style = -256|0x10);
    var f = open(fileName, iomode.r, hints=IOHINT_SEQUENTIAL);
    var r = f.reader();
    var n: int = -2;
    var givenN: int;
    //var line: string;
    var coord: [0..2] real;
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
        var lineArray: [0..-1] string;
        for (i,s) in zip(0.., line.split()) {
          select i {
            when 0 do atoms.push_back(s);
            when 1 do x.push_back(s : real);
            when 2 do y.push_back(s : real);
            when 3 do z.push_back(s : real);
          }
        }
        n += 1;
      }
    }
    if n != givenN {
      writeln("Hey, your atoms don't match.");
    }
    var system = new shared topology.System(n);
    system.setCoords(x,y,z);
    system.setAtoms(atoms);
    return system;
  }
}
