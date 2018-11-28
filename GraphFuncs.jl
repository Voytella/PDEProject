# plot n-many of a provided function (found in CONFIGURATION section)

# ----------BEGIN IMPORTS----------

using Pkg;

# add the Calculus package
Pkg.add("Calculus");
using Calculus;

# add graphing utilities
Pkg.add("ORCA");
using ORCA;
Pkg.add("PlotlyJS");
using PlotlyJS;

# -----------END IMPORTS-----------

# recursively derive 'func' 'amt' number of times
function derivMany(func, amt)
    if (amt == 0) 
        return func;
    end
    derivMany(derivative(func), amt-1);
end

# return the nth Hermite polynomial
function getHermite(n)

    # explicitly define e^{-(x^2)} (necessary to make the Calculus pkg behave!)
    hermExp = (x) -> exp(-(x^2));
    
    return (x) -> (-1)^n * exp(x^2) * derivMany(hermExp, n)(x);
end

# evaluate a function across a range for graphing
function genFuncPts(func, range)
    vals = [];
    for ii in range
        append!(vals, func(ii))
    end
end

# create a scatter to be added to a plot
function genScatter(xVals, yVals)
    return scatter(x=xVals, y=yVals);
end

# generate list of scatters to be plotted

# the number of plots to be made of the provided function
numPlots = parse(Int, ARGS[1]);

# ----------BEGIN CONFIGURATION----------

# the function provided for plotting
provFunc = (x) -> exp((x^2) / 2) * getHermite(numPlots)(x);

# -----------END CONFIGURATION-----------

# get both 'x' and 'n' from the command line
#xIn = parse(Float64, ARGS[1]);
#nIn = parse(Int, ARGS[2]);

# evaluate and print the found Hermite function
#println(getHermite(nIn)(xIn))
