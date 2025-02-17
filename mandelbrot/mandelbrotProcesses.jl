@everywhere include("mandelbrotFractal.jl")

function my_process(jobs, results)
    # computing process
    while true
        # fetching new job
        try
            arguments = take!(jobs) # it's a blocking call
            println("new Job is starting")
            println("job fetched")
            # start job
            timePassed = @elapsed pixel(arguments...)
            println("job completed")
            put!(results, (myid(), timePassed))
        # putting final Results
        catch
            # if jobs closed, take! fails
            println("No more jobs, turning idle")
            put!(results, (myid(), "completed"))
            break
        end
    end
end

function create_jobs(mySharedArray, k, iter, jobs)
    horizontal = fld(size(mySharedArray)[1], nworkers() * 5)
    counter = 1
    flag = true

    while flag == true
        pixelsx = (horizontal * (counter - 1) + 1, horizontal * counter)

        if pixelsx[2] >= size(mySharedArray)[1]
            pixelsx = (horizontal * (counter - 1) + 1, size(mySharedArray)[1])
            flag = false
        end

        put!(jobs, (k, iter, pixelsx, size(mySharedArray)[2], 2*k + 1, 1*k + 1, mySharedArray))
        counter += 1
    end

    return counter
end

function my_monitor(jobs, results, mySharedArray, k, iter)
    # waiting initialization of all processes
    sleep(1)
    println("Starting Timer")
    t = time()
    totalTime = 0 # sum of all computing processes
    idle = 0 # processes in idle

    # populating jobs remotechannel
    num_jobs = create_jobs(mySharedArray, k, iter, jobs)
    println(" Jobs created: $num_jobs")

    while idle < 7
        # serach for results
        if isready(results)
            time = take!(results)
            if time[2] == "completed" # if process is idle add 1
                idle += 1
                println("Idle status detected, process: ", time[1])
            else
                totalTime += time[2]
            end
        end
        # if no more jobs close the channel
        if !isready(jobs)
            close(jobs)
        end
    end
    println("Parallel computing composite cpu time: ", totalTime)
    println("Parallel computing time in seconds: ", time() - t)
    close(results)
    println("Closing Results channel")
    println("Computation is over")
end

function dispatcher(jobs, results, mySharedArray, k, iter)
    # dispatching tasks
    for process in workers()
        if process == 2
            # need one process to compute time in s, this is worker 2
            # process also creates jobs for others
            # monitors results channel and advance state
            @info "Dispatching monitor"
            remote_do(my_monitor, 2, jobs, results, mySharedArray, k, iter)
        else
            # computing processes
            # they execute the jobs stored in jobs remotechannel
            @info "Dispatching worker"
            remote_do(my_process, process, jobs, results)
        end
    end
end
