# calculates the n-th order Hermite polynomial

# add the Calculus package
using Pkg;
Pkg.add("Calculus");
using Calculus;

# ----------BEGIN HELPER FUNCTIONS----------

# recursively derive 'func' 'amt' number of times
function derivMany(func, arg, amt)
    if (amt == 0) 
        return func(arg);
    end
    derivMany(derivative(func), amt-1);
end

# -----------END HELPER FUNCTIONS-----------

# get both 'x' and 'n' from the command line
xIn = parse(Float64, ARGS[1]);
nIn = parse(Int, ARGS[2]);

# calculate the value of the Hermite polynomial for a given 'x' and 'n' 
function Hermite(x, n)
    return (-1)^n * exp(x^2) * derivMany(exp(-(x^2)), x, n);
end

println(Hermite(xIn,nIn))
