// this is a set of functions for basic linalg operations
// lots of stuff like applying a matrix rotation and such.
// it's pretty specific to what we're doing here, so.

record atomVector {
  var whichAtom: int = 3;
  var coords: [1..3] real;
}

record rotMatrix {
  // formality
  var n: int = 3;
  var coords: [1..3,1..3] real;
}

record atomMatrix {
  var nAtoms: int;
  var coords: [1..nAtoms] atomVector;

  proc init(n: int) {
    this.nAtoms = n;
  }

  proc this(i) {
    return this.coords[i];
  }
}

record atom {
  // https://en.wikipedia.org/wiki/Verlet_integration
  // super fucking handy!
  var pos: atomVector;
  var vel: atomVector;
  var acc: atomVector;
  var dt: real = 0.002;

  // so, this is velocity Verlet, apparently.
  proc update() {
    pos += (vel*dt) + (acc*dt*dt*0.5);
    vel += (acc+grav())*(dt*0.5);
    acc = grav();
  }

  proc grav() {
    var a: atomVector;
    return a + [0, 0, -9.8];
  }
}

proc +(a: atomMatrix, b: atomMatrix) {
  var c = new atomMatrix(a.nAtoms);
  for i in 1..a.nAtoms {
    var aX = a.coords[i,1], aY = a.coords[i,2], aZ = a.coords[i,3];
    var bX = b.coords[i,1], bY = b.coords[i,2], bZ = b.coords[i,3];
    c.coords[i,1] = aX + bX;
    c.coords[i,2] = aY + bY;
    c.coords[i,3] = aZ + bZ;
  }
  return c;
}

proc *(a: atomVector, b: real) {
  var c = new atomVector;
  c.coords[1] = a.coords[1] * b;
  c.coords[2] = a.coords[2] * b;
  c.coords[3] = a.coords[3] * b;
  return c;
}

proc +=(ref a: atomMatrix, b: atomMatrix) {
  for i in 1..a.nAtoms {
    var bX = b.coords[i,1], bY = b.coords[i,2], bZ = b.coords[i,3];
    a.coords[i,1] += bX;
    a.coords[i,2] += bY;
    a.coords[i,3] += bZ;
  }
}

proc -=(ref a: atomMatrix, b: atomMatrix) {
  for i in 1..a.nAtoms {
    var bX = b.coords[i,1], bY = b.coords[i,2], bZ = b.coords[i,3];
    a.coords[i,1] -= bX;
    a.coords[i,2] -= bY;
    a.coords[i,3] -= bZ;
  }
}

proc +=(ref a: atomVector, b: atomVector) {
  var bX = b.coords[1], bY = b.coords[2], bZ = b.coords[3];
  a.coords[1] += bX;
  a.coords[2] += bY;
  a.coords[3] += bZ;
}

proc -=(ref a: atomVector, b: atomVector) {
  var bX = b.coords[1], bY = b.coords[2], bZ = b.coords[3];
  a.coords[1] -= bX;
  a.coords[2] -= bY;
  a.coords[3] -= bZ;
}

proc +=(ref a: atomVector, b: [1..3]) {
  var bX = b[1], bY = b[2], bZ = b[3];
  a.coords[1] += bX;
  a.coords[2] += bY;
  a.coords[3] += bZ;
}
