use fileParser;

proc main {
  var l = new owned fileParser.Loader();
  var s = l.loadXYZ("pyridine.xyz");
  writeln(s.coords);
  writeln(s.atoms);
}
