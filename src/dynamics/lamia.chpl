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
    var integrate = new owned integrator(dt = dt);
    var applyDamping = new owned dampingForce();
    fp.startTrajectoryFile(this.system, "trajectory");
    for i in 0..steps-1 {
      for mol in this.system.molecules {
        for atom in mol.atoms {
          var forces: list(LinAlg.vector, parSafe=true);
          for otherMol in this.system.molecules {
            for Otheratom in otherMol.atoms {
              forces.append(f(atom.pos, Otheratom.pos));
            }
          }
          var sumForces: LinAlg.vector = new vector(shape=(3,));
          for i in forces {
            sumForces += i;
          }
          integrate(atom, sumForces);
          applyDamping(atom);
        }
      }
      //fp.exportSystemToXYZ(this.system, i : string);
      this.system.center(0);
      fp.writeSystemToOpenFile(this.system);
      if (i % 40 == 0) {
        writeln(i);
      }
    }
    fp.closeTrajectoryFile();
  }
}

class integrator : functionBase {
  var dt: real;
  proc __internal__(ref atom: Particles.Atom, acc: LinAlg.vector) {
    atom.pos += (atom.vel*dt) + (0.5*acc*dt**2);
    atom.vel += (acc*dt*0.5);
  }
}

class dampingForce : functionBase {
  var dampingStrength: real = 0.2;
  proc __internal__(ref atom: Particles.Atom) {
    atom.vel *= dampingStrength;
  }
}
