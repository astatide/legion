use LinearAlgebra;

record tensor {
    var rank: int = 0;
    var degree: int = 3;
    var shape: (int,) = (3,);
    var data: [0..shape[0]-1] real;
}

record vector {
    var rank: int = 1;
    var degree: int = 3;
    var shape: (int,) = (3,);
    var data: [0..shape[0]-1] real;

    proc init() {
      this.complete();
    }

    proc init(shape: (int,)) {
      this.shape = shape;
      this.complete();
    }

    proc init(data: [] real) {
      this.data = data;
      this.complete();
    }

    proc init=(data: [] real) {
      this.data = data;
      //this.complete();
    }

    proc init=(vec: vector) {
      this.complete();
      this = vec;
    }

    proc this(i: int) {
      return this.data[i];
    }
}

record matrix {
    var rank: int = 2;
    var degree: int = 3;
    var shape: (int,int) = (3,3);
    var data: [0..shape[0]-1,0..shape[1]-1] real;

    proc this(i: int) {
      return this.data[i];
    }
}

// Now, the operator overrides

// Vectors!

operator +(a: vector, b: vector) {
  var c = new vector(shape = a.shape);
  c.data = a.data + b.data;
  return c;
}

// This is _part_ of what is necessary for setting the internal array  from an array.
// check out the page on conversions here: https://chapel-lang.org/docs/language/spec/conversions.html
// it's where I stole basically all of this, so.

operator =(ref a:vector, b: [] real) {
  a.data = b;
}

// We require this cast operator for proper initialization / casting from an array.
// Currently we do _not_ check bounds.  So that's an issue for suuuuuuure that we'll need to fix.
// TODO: Shape checking!

operator :(from: [] real, type toType: vector) {
  var tmp: vector = from;
  return tmp;
}

// We require this because records are copied, not borrowed.  So whenever you append, etc, you're just making a new one.
// Ergo, there's an implicit = operation.

operator =(ref a:vector, b: vector) {
  a.rank = b.rank;
  a.degree = b.degree;
  a.shape = b.shape;
  a.data = b.data;
}

// Matrix!

operator +(a: matrix, b: matrix) {
  var c = new matrix(shape = a.shape);
    c.data = a.data + b.data;
  return c;
}

operator +=(ref a: matrix, b: matrix) {
  a.data[0..a.shape[0]-1,0..a.shape[1]-1] += b.data[0..a.shape[0]-1,0..a.shape[1]-1];
}

operator +=(ref a: matrix, b: real) {
  a.data[0..a.shape[0]-1,0..a.shape[1]-1] += b;
}

operator +=(ref a: matrix, b: [] real) {
    a.data += b;
}

// Matrix and Vectors!  Huge assumptions about shapes being compatible here.
// I'm _sure_ there's a better way to do this than by just doing it element wise, but hey, what do I know.

operator +(a: matrix, b: vector) {
  var c = new vector(shape = b.shape);
  c = dot(a.data, b.data);
  return c;
}