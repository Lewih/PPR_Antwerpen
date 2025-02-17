# Julia Examples

Examples for the Parallel Computing Course.
University of Antwerp.

Use Julia 1.11.x

## Prime
Start exploring the prime.jl example. This little example ships both shared and distributed memory parallelism via julia macros.
Follow the comments and read the links.

## Mandelbrot
Use the knowledge acquired to explore the Mandelbrot example.
Install the necessary packages if needed.
The code is old and relies on Distributed computing machinery(the only available at the time), hence no shared memory parallelism is in place.
It creates a list of small subproblems and assigns them dynamically to the workes reducing idle time (the domain of the set does not have constant computational cost). Atlhough, this approach makes the codebase more complex.
How could it be improved? Sketch your ideas and read the documentation, finding out whether your conjectures are feasible.
Try to use multithreding 

![Colored](https://github.com/user-attachments/assets/c9de94ce-d44a-45a3-b1a1-3e7113cf3a70)
