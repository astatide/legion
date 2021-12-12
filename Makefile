NUMPY:=`python3 -c 'import numpy.distutils.misc_util as m; print(m.get_numpy_include_dirs()[0])'`
PYTHONC:=`python3-config --cflags`
PYTHONL:=`python3-config --ldflags`
BLAS:=-I /usr/include/x86_64-linux-gnu -L /usr/lib/x86_64-linux-gnu -lblas
MODULES:=-M src -M src/topology -M src/forge -M src/legionTypes
LEGDIR:=`pwd`
FILES:=$(LEGDIR)/src/legion.chpl $(LEGDIR)/src/topology/topology.chpl $(LEGDIR)/src/legionTypes/types.chpl $(LEGDIR)/src/forge/forge.chpl $(LEGDIR)/src/sin/sin.chpl $(LEGDIR)/src/dynamics/dynamics.chpl $(LEGDIR)/src/legionTypes/legionFunctions.chpl

all:
	make legion

clean:
	rm legion

legion:
	chpl -o legion -L /usr/local/lib -I /usr/local/include $(BLAS) $(MODULES) $(FILES) $(LEGDIR)/main.chpl --ccflags "-w -lpthread -I $(NUMPY) $(PYTHONC)" --ldflags "-lpthread -v $(PYTHONL)"

legionNoPy:
	chpl -o legion -L /usr/local/lib -I /usr/local/include $(BLAS) $(MODULES) $(FILES) $(LEGDIR)/main.chpl

test:
	start_test -compopts "$(BLAS) $(MODULES) $(FILES)" src/test/