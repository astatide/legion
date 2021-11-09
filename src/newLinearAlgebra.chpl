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
}

record matrix {
    var rank: int = 2;
    var degree: int = 3;
    var shape: (int,int) = (3,3);
    var data: [0..shape[0]-1,0..shape[1]-1] real;
}

// Now, the operator overrides

// Vectors!

operator +(a: vector, b: vector) {
  var c = new vector(shape = a.shape);
  //for i in 0..a.shape[0]-1 {
  //    c.data[i] = a.data[i] + b.data[i];
  //}
  c.data = a.data + b.data;
  return c;
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