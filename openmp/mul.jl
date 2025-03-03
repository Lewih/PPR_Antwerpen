## Call a more complex C routine.

using BenchmarkTools

lib = "./matrixlib.dylib" 

function matrix_mul(A::Matrix{Float64}, B::Matrix{Float64})
    m = size(A, 1); p = size(B, 2)
    C = zeros(Float64, m, p)  # Output matrix

    if size(A, 2) == size(B, 1)
        n = size(A, 2)
    else
        throw(DomainError(A, "A and B must be compatible")) 
    end

    # Call the C function. Feed the arrays as pointers to double.
    #(!) Explore the Julia documentation, how do arrays appear in memory?
    @ccall lib.mymul(A::Ptr{Float64}, 
                    B::Ptr{Float64}, 
                    C::Ptr{Float64}, 
                    m::Cint, n::Cint, p::Cint)::Cvoid
    return C
end

function matrix_mul!(A::Matrix{Float64}, B::Matrix{Float64}, C::Matrix{Float64})
    # In-place variant of the function. Matrix C is preallocated.
    m = size(A, 1); p = size(B, 2)

    if size(A, 2) == size(B, 1)
        n = size(A, 2)
    else
        throw(DomainError(A, "A and B must be compatible")) 
    end

    @ccall lib.mymul(A::Ptr{Float64}, 
                    B::Ptr{Float64}, 
                    C::Ptr{Float64}, 
                    m::Cint, n::Cint, p::Cint)::Cvoid
    return C
end

#Performance metrics
# C code, dynamically allocated
A = ones(1000, 5000); B = ones(5000, 1003);
@btime C = matrix_mul(A, B);

# C code, pre-allocated
m = size(A, 1); p = size(B, 2);
C = zeros(Float64, m, p);  # Output matrix
@btime C = matrix_mul!(A, B, C);

# Julia
@btime C = A*B;

# Julia, in-place
@btime  mul!(C, A, B)

#(!) Which implementation is faster? 
#(!) Do memory allocation and GC play a role in performance?
#(!) Is it worth using bespoke C code in this case?
#(!) Can you find a pre-exisitng high performance LinAlg C library?
#(!) If so, can you call a C function from that library using Julia?
#(!) Which routine mul! calls? What is it, a BLAS call?
