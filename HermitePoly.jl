# calculates the n-th order Hermite polynomial

# add the Calculus package
using Pkg;
Pkg.add("Calculus");
using Calculus;

# recursively derive 'func' 'amt' number of times
function derivMany(func, amt)
    if (amt == 0) 
        return func;
    end
    derivMany(derivative(func), amt-1);
end

# return the nth Hermite function
function getHermite(n)

    # explicitly define e^{-(x^2)} (necessary to make the Calculus pkg behave!)
    hermExp = (x) -> exp(-(x^2));
    
    return (x) -> (-1)^n * exp(x^2) * derivMany(hermExp, n)(x);
end

# get both 'x' and 'n' from the command line
xIn = parse(Float64, ARGS[1]);
nIn = parse(Int, ARGS[2]);

# evaluate and print the found Hermite function
println(getHermite(nIn)(xIn))
