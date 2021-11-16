use List;
use Numerical.RecordCore as LinAlg;
use Topology.Particles as Particles;
use Topology.System as SystemMod;
use SinFF.Parameters as SIn;
use fileParser;

class SingleCore {
  var dt: real = 0.002;
  var system: SystemMod.System;

  proc run(steps: int, f: borrowed SIn.forceParameters) {
    var fp = new owned fileParser.fileLoader();
    fp.startTrajectoryFile(this.system, "trajectory");
    for i in 0..steps-1 {
      for mol in this.system.molecules {
        for atom in mol.atoms {
          for otherMol in this.system.molecules {
            for Otheratom in otherMol.atoms {
              this.integrate(atom, f.calculate(atom.pos, Otheratom.pos));
            }
          }
        }
      }
      //fp.exportSystemToXYZ(this.system, i : string);
      this.system.center(0);
      fp.writeSystemToOpenFile(this.system);
    }
    fp.closeTrajectoryFile();
  }

  proc integrate(ref atom: Particles.Atom, acc: LinAlg.vector) {
    atom.pos += (atom.vel*dt) + (0.5*acc*dt**2);
    atom.vel += (acc*dt*0.5);
  }
}