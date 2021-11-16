use fileParser;
use Topology.System as SystemMod;
use Topology.Particles as Particles;
use Topology.Groups as Groupings;


// we assume everything in the XYZ is one molecule, for the moment.
// we can ultimately put in some logic about bond length or an END
// statement, but that's more PDB.
// just set to the number of atoms.  They're the same numbers.

class Build {
  // this is responsible for construction of a system.
  // it loads up the files we tell it to, and then goes from there.
  proc oldbuild() {
    // look, just load up pyridine a few times and have it go.
    var nFiles: int = 5;
    var parsedFiles: [1..nFiles] unmanaged fileParser.fileLoader?;
    var nAtoms: int;
    var nMolecules: int;
    for i in 1..nFiles {
      parsedFiles[i] = new unmanaged fileParser.fileLoader();
      parsedFiles[i]!.loadXYZ("pyridine.xyz");
      //parsedFiles[i].center();
      nAtoms += parsedFiles[i]!.nAtoms;
      nMolecules += parsedFiles[i]!.nMolecules;
    }
    // hooray we have loaded the files yay
    var system = new shared SystemMod.System(nAtoms, nMolecules);
    for i in 1..nFiles {
      //var x = parsedFiles[i]!.x;
      //var y = parsedFiles[i]!.y;
      //var z = parsedFiles[i]!.z;
      var m = parsedFiles[i]!.molecules;
      var a = parsedFiles[i]!.atoms;
      //writeln("Here's our x!");
      //writeln(x);
      writeln(parsedFiles[i]!);
      //system.addCoords(x,y,z);
      //system.addAtoms(a);
      //system.addMolecules(m);
      system.currentAtoms += parsedFiles[i]!.nAtoms;
      system.currentMolecules += parsedFiles[i]!.nMolecules;
    }
    system.center();
    return system;
  }

  proc build() {
    var sys = new SystemMod.System(buildMoleculeFromXYZ());
    sys.center(0);
    sys.addMolecules(buildMoleculeFromXYZ());
    return sys;
  }

  proc buildMoleculeFromXYZ() {
    // look, just load up pyridine a few times and have it go.
    //var parsedFiles: owned fileParser.fileLoader?;
    var nAtoms: int;
    var nMolecules: int;
    var parsedFiles = new owned fileParser.fileLoader();
    var newMolecule: Groupings.molecule = new Groupings.molecule();
    for atom in parsedFiles.yieldAtomsFromXYZ('pyridine.xyz') {
      newMolecule += atom;
    }
    return newMolecule;
  }
}
