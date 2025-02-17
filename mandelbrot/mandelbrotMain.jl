#(!) Run me inside vs code or copy me in the repl
using Distributed

# Creating workers
if(nworkers() < 8)
    addprocs(8)
end

# everywhere 
@everywhere using SharedArrays
using Images, PNGFiles, ImageIO, ImageMagick, QuartzImageIO, BenchmarkTools
@everywhere include("mandelbrotProcesses.jl")
include("imageHandling.jl")

function start(k, iter)
    # real axis [-2, +1], lateral axis [-1, 1]
    # actual value is xpixel - 2*k and ypixel - 1*k
    # SharedArray is a distributed memory array
    mySharedArray = SharedArray{Int32}((2*k + 1*k, 2*k))

    # creating communication channels
    results = RemoteChannel(()->Channel{Tuple}(128));
    jobs = RemoteChannel(()->Channel{Tuple}(128));

    @info "Init processes"
    # dispatching tasks
    dispatcher(jobs, results, mySharedArray, k, iter)

    # returning pointer
    return mySharedArray;
end

# first run includes compilation!
k = 100; iter = 10
out = start(k, iter)
#(!) when uncommenting following line you will see a black plot. 
#(!) the master process does not wait for the processes to finish, why?
#applyColormap(out, 25)
#(!) run this line once computation is over, apply color and save
#(!) run in the repl


##(!) run the program in single process mode using the pixel function
##(!) try to profile it, follow the stacktrace and check the allocations
##(!) how does it scale if you use larger k and iter?
##(!) can you modify the pixel function in order to achieve shared memory parallelism?
myArray = zeros(Int32, 2*k + 1*k, 2*k)
args = (k, iter, (1, (size(myArray)[1])), size(myArray)[2], 2*k + 1, 1*k + 1, myArray)
@btime pixel(args...)
