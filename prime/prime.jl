# Simple example of bruteforce prime numbers search
# to run interactive session -> julia -p n -t m -i prime.jl
# or copy paste the code in the repl


# using the packages and install BenchmarkTools if not installed
using Distributed
try
    using BenchmarkTools
catch
    using Pkg
    Pkg.add("BenchmarkTools")
    using BenchmarkTools
end


# prime function
function prime(n=100000)
    @sync begin # necessary @sync for the workers
        @distributed for x = 2:n # split evenly among workers
            flag = 0
            @sync begin # not necessary, @threads syncs automatically
                Threads.@threads for div = 2:x-1 # evenly spread
                    if x % div == 0 || flag == 1
                        flag = 1 # flag is shared variable among threads
                        break
                    end
                end
            end
            if flag == 0
            # write a single core version of this code and profile it
            # println(x, " is prime") # printing is expensive, try to profile it
            end
        end
    end
end

# run once to compile
prime(10)
@info "Code has been executed once"
# or use BenchmarkTools @btime prime() to benchmark


## https://www.julia-vscode.org/docs/stable/userguide/profiler/
# Try to see in the profiling if you can see something interesting or whether the @sync, @distributed and @threads macros are obscuring everything.
# If so, which processes are used to compute (workers)? Are you profiling a "Master" process which is not computing?
## https://docs.julialang.org/en/v1/manual/distributed-computing/
# stacktrace profiling
@profview prime()
# allocation profiling
@profview_allocs prime()
# try to think about the difference between workers and master process


## alternative text based profiling (done hiddenly in @@profview)
# using profile
# @profile prime()
# Profile.print()
