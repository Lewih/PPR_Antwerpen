# Julia Examples

Examples for the Parallel Computing Course.
University of Antwerp.

Use Julia >= 1.11.x

To the students: Feel free to do the exercises indicated in the comments by (!).

## Prime
Start exploring the prime.jl example. This little example ships both shared and distributed memory parallelism via julia macros.
Follow the comments and read the links.

## Mandelbrot
<img src="https://github.com/user-attachments/assets/c9de94ce-d44a-45a3-b1a1-3e7113cf3a70" width="130" align="right">

Use the knowledge acquired to explore the Mandelbrot example.
Install the necessary packages if needed.
The code is old and relies on Distributed computing machinery(the only available at the time), hence no shared memory parallelism is in place.
It creates a list of small subproblems and assigns them dynamically to the workes reducing idle time ('load balancing': the domain of the set does not have constant computational cost). Atlhough, this approach makes the codebase more complex.
How could it be improved? Sketch your ideas and read the documentation; is your design feasible?
Try to use multithreding.

## Openmp
Try out the openmp example and consider the limitiations of using a multi-language codebase. Is it worth it for the proposed use-case?
Try to optimise the provided C code or use a function provided by an external C library.

## MPI
**[MPI.jl](https://juliaparallel.org/MPI.jl/latest/)** is the Julia wrapper for MPI. It requires careful [configuration](https://juliaparallel.org/MPI.jl/latest/configuration/#using_jll_mpi) and [setup](https://juliaparallel.org/MPI.jl/latest/usage/#Julia-wrapper-for-mpiexec).
MPI.jl can be linked to different MPI implementations which will probably differ between your own machine and the cluster.
Be sure you are able to run `MPI/MPI_hello.jl` then explore [other examples](https://juliaparallel.org/MPI.jl/latest/examples/02-broadcast/). 