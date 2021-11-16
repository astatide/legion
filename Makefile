NUMPY:=`python3 -c 'import numpy.distutils.misc_util as m; print(m.get_numpy_include_dirs()[0])'`
PYTHONC:=`python3-config --cflags`
PYTHONL:=`python3-config --ldflags`
BLAS:=-I /usr/include/x86_64-linux-gnu -L /usr/lib/x86_64-linux-gnu -lblas
MODULES:=-M src -M src/topology -M src/forge -M src/numericalCores
FILES:=main.chpl src/topology/topology.chpl src/numericalCores/numerical.chpl src/forge/forge.chpl src/sin/sin.chpl src/dynamics/dynamics.chpl #src/forge/fileParser.chpl src/forge/systemBuilder.chpl src/topology/atom.chpl src/topology/groupings.chpl src/topology/system.chpl

all:
	make legion

clean:
	rm legion

legion:
	chpl -o legion -L /usr/local/lib -I /usr/local/include $(BLAS) $(MODULES) $(FILES) --ccflags "-w -lpthread -I $(NUMPY) $(PYTHONC)" --ldflags "-lpthread -v $(PYTHONL)"

legionNoPy:
	chpl -o legion -L /usr/local/lib -I /usr/local/include $(BLAS) $(MODULES) $(FILES)


