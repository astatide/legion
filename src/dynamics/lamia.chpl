use List;

private use Legion.Types.TupleCore as LinAlg;
private use Legion.Types.Functions;
private use Legion.Topology.Particles as Particles;
private use Legion.Topology.System as SystemMod;
private use Legion.SIn.Parameters as SIn;
private use Legion.Forge.FileParser;

class SingleCore {
  var dt: real = 0.002;
  var system: SystemMod.System;

  proc run(steps: int, f: borrowed SIn.forceParameters) {
    var fp = new owned fileParser.fileLoader();
    var integrate = new owned integrator(dt = dt);
    var applyDamping = new owned dampingForce();
    fp.startTrajectoryFile(this.system, "trajectory");
    for i in 0..steps-1 {
      var sumForcesList: list(LinAlg.vector, parSafe=true);
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
          sumForcesList.append(sumForces);
        }
      }
      var c: int = 0;
      for mol in this.system.molecules {
        for atom in mol.atoms {
          // HUGE assumption that these iterate the same; just a quick hack to fix it.
          integrate(atom, sumForcesList[c]);
          applyDamping(atom);
          c += 1;
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
  proc this(ref atom: Particles.Atom, acc: LinAlg.vector) {
    // leapfrog / verlet
    atom.pos += (atom.vel*dt) + (0.5*acc*dt**2);
    atom.vel += (acc*dt*0.5);
  }
  // uggghhhhh _apparently_ if we don't use this, it calls the superclass method, regardless of the arguments.  Blagh.
  //proc this(ref atom: Particles.Atom, acc: LinAlg.vector) { this.__internal__(atom, acc); }
}

class dampingForce : functionBase {
  var dampingStrength: real = 0.5;
  proc this(ref atom: Particles.Atom) {
    // bullshit damping force.
    atom.vel *= dampingStrength;
  }
}
