use fileParser;
use systemBuilder;

proc main {
  var b = new owned systemBuilder.Build();
  var s = b.build();
  writeln(s);
}
