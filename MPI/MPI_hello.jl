
#(!) Read: https://juliaparallel.org/MPI.jl/latest/
#(!) Focus on Configuaration then on Usage:
#(!) 1 -> Correctly configure MPI.jl on your machine (using jll is easier). Use MPIPreferences if needed.
#(!) 2 -> Install mpiexecjl and add it to PATH
#(!) Check everything is working by executing: mpiexecjl -n 4 julia  MPI_hello.jl


using MPI
MPI.Init()

comm = MPI.COMM_WORLD
print("Hello world! I am rank $(MPI.Comm_rank(comm)). We are $(MPI.Comm_size(comm)) in total!\n")
sleep(4)
if MPI.Comm_rank(comm) == 0
    print("Here it is rank 0! Bye-bye\n")
end
MPI.Barrier(comm)

# MPI.Finalize() is called automatically when Julia closes.
# You are free to add it at the end of you program, but it will 
