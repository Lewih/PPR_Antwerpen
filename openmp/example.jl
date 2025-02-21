## Call a C rountine embedding OMP pragmas
# This showcase a simple example of C call in Julia.
# The C code uses openmp.

# https://docs.julialang.org/en/v1/manual/calling-c-and-fortran-code/

lib = "./matrixlib.dylib" 

@ccall lib.say_y(5::Cint)::Cvoid
