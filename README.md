Legion 
------

README First Public Draft

Legion is a heavily-work-in-progress MD/Brownian simulation engine / framework package.  The design goal is to be scalable, modifiable, and most of all, easy to read; an experienced programmer, lacking knowledge of chemistry, should _reasonably_ be able to run an MD simulation.  Conversely, a non-programmer who knows chemistry should be able to infer what is happening merely by reading source code, relying instead on their knowledge of math.  Finally, an experienced programmer/chem-aware individual should be able to create/play around with experimental/educational simulation cores to determine where and why something is done in a simulation.

Extensibility / correctness is an important design goal; ML integration via an embedded Python interpreter is planned (ala a SmartSim integration).

Much of the groundwork is laid, but there's still more to do.  Overall, the lower level work is to enable a high-level API that can be easily re-arranged to create custom simulation algorithms/routines/cores.  Therefore, heavy use of operator overrides and functions ala functional programming (mimicking the style of function one might use in an equation) are utilized.  

Note that literally everything is under heavy construction and is not yet at the alpha stage.

Dynamics Cores
--------------

There are currently plans for 3 built-in dynamics cores:
1. LAMIA, a Linear Atomic/Molecular Integration Algorithm: the basic, "correct" integrator that does not utilize any parallel speedups (except for those which Chapel provides natively).  This dynamics core prioritizes readability, simplicity, and correctness above all else, and will serve as the benchmark against which other cores should be judged.  It is in progress, and will support ML/Python integration for online analysis/experimentation/visualization.  Yes, the acronym meaning is a backronym.
2. UNNAMED: single-node performant dynamics core.  This will not be multi-node, but will prioritize performance over readability (while still ensuring that any data transformations done from a high level API are explicitly noted).  Lamia may ultimately fit this bill, meaning it may never exist.
3. BEHEMOTH, a massively scalable dynamics core: this is designed to be performant in the _scaling_ sense, with the goal to serve Incredibly Large Simulations (cell scale?  Multi-protein?) for educational or research purposes.  Not yet started.

Force Fields
------------

In addition, Legion has an (in-progress) built in force field and force field API, named SIn/SInFF (you may stylize however you see fit): the Sorta-Inaccurate Force Field.  Sin serves two purposes:
1. An example of the internal force field interface.
2. A template for training of _any_ sort, whether that's ML guided or otherwise.  Python integration and exposure of active forces/parameters are planned, allowing this to be modified online so that a simulation may be tuned on-the-fly and in real time.  This may include ML training or 'mimickry' of existing but not data-format compatible force fields (example: mimic an existing force field, then add more parameters).
3. A 'reasonable' baseline, with the caveat pre-1.0 versions of SInFF have the goal of "not blowing the simulation up".  Note that this is a _goal_.

Future versions of SInFF are expected to be more reasonable starting points for simulation work, and possibly even accurate.

Legion is done in my spare time and as such is as profane and metaphor heavy as I wish (Legion is named for the planned scalable/modifiable functionality).  "Demons" are the metaphor in use here.  

First Class Functions / Functional Programming / Vectors
--------------------------------------------------------

Where possible (such as in creating integrator functions and force field functions), "first class functions" are in use; these allow us to use generators/functions to specify large sets of functions.  In addition, it enables the use of operator overloads; one such (planned) operator is the reverse operator/function, which will allow us to write code similar to

`R*f(A,B) == f(B,A)`

given that

`f(A,B) != f(B,A)`

It also allows us to do weird stuff like utilize multiple integrator functions, or add damping forces simply by creating a new function, etc.

Vectors are essentially wrappers around tuples; given Chapel's performance characteristics, this will allow us to easily distribute atoms/particles across nodes while allowing a lot of math-type operations (matrix application, dot products, etc).


System Builder
--------------
Currently hardcoded, but creates a system instance off of a pyridine.xyz file, then starts instantiating all of the necessary bits to create a system suitable for production.  Can currently load XYZ files.

More to come on atoms (particles) and molecules (internally, a set of particles that may or may not have pairwise forces).


TRY ME!
-------

The easiest way to try Legion is to use Docker and VS Code.  Simply load the workspace, use the remote-containers functionality to open your workspace inside the container, then open the integrated terminal.  From there, run:

`make legionNoPy`
`./legion`

It'll produce a silly little trajectory.xyz file, which in no way conforms to _anything_ realistic, dynamics or otherwise.  Please do not draw any conclusions about pyridine based on this.