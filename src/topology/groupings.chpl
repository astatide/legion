use List;

module AtomGroups {
    // these are simply called groups; they _may_ be molecules, but they are also non bonded groups of atoms
    // it's a calculation convenience in a lot of ways; it'll give us a 'window' of atoms.

  record molecule {
    var name: string;
    var nAtoms: int;
    var startingAtom: int;

    iter atoms {
      // this will yield our atoms.
      for i in startingAtom..startingAtom+nAtoms-1 {
        yield i;
      }
    }
    proc setAtoms(a: [] int) {
      this.nAtoms = a.size;
      // remember, this is Chapel, so things start with 1 by default yay.
      this.startingAtom = a[1];
    }
  }
}