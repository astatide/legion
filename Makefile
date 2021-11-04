NUMPY:=`python3 -c 'import numpy.distutils.misc_util as m; print(m.get_numpy_include_dirs()[0])'`
PYTHONC:=`python3-config --cflags`
PYTHONL:=`python3-config --ldflags`

all:
	make legion

clean:
	rm legion

legion:
	chpl -o legion -L /usr/local/lib -I /usr/local/include -M src/ main.chpl --ccflags "-w -lpthread -I $(NUMPY) $(PYTHONC)" --ldflags "-lpthread -v $(PYTHONL)"

legionNoPy:
	chpl -o legion -L /usr/local/lib -I /usr/local/include -M src/ main.chpl


