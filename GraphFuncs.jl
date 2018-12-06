# plot n-many of a provided function (found in CONFIGURATION section)

# ----------BEGIN CONFIGURATION----------

# get the provided function for a certain value of 'n'
getProvFunc(nVal) = (x) -> exp((x^2) / 2) * getHermite(nVal)(x);

# -----------END CONFIGURATION-----------

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

# print instructions for running the program and exit 
function usage()
    println("USAGE: julia GraphFuncs.jl <number of function iterations (Int)>
            <domain (range object) <range (range object)");  
    exit(); 
end

# recursively derive 'func' 'amt' number of times
function derivMany(func, amt)
    if (amt == 0) 
        return func;
    end
    derivMany(derivative(func), amt-1);
end

# the exponent within the calculation for the Hermite polynomial
hermExp = (x) -> exp(-(x^2));

# get the n-th Hermite polynomial
getHermite(n) = (x) -> (-1)^n * exp(x^2) * derivMany(hermExp, n)(x);

# evaluate a function across a range
mkFuncPts(func, range) = [func(ii) for ii in range];

# create a scatter to be added to a plot
mkScatter(xVals, yVals) = scatter(x=xVals, y=yVals);

# generate list of scatters to be plotted across a shared axis
## domain: the shared x values of the plot (range obj)
## range: the values at which the functions are to be evaluated (range obj)
## funcGen: generator of the nth iteration of the provided function
## amt: number of functions to be generated (plots to be created) (range obj)
mkSharedScatters(domain, range, funcGen, amt) = 
    [mkScatter(domain, mkFuncPts(funcGen(ii), range)) for ii in amt];

# ----------BEGIN INPUT----------

# parse a range object
function parseRange(rangeStr)
    
    rangePartsStr = split(rangeStr, ":");
    rangeParts = map((x) -> parse(Float64, x), rangePartsStr);

    # error check length underflow
    if (length(rangeParts) < 2)
        println("ERR: too few elements in range object (use x:y or x:y:z)");
        usage();
        return -1;
    end
    
    # error check length overflow
    if (length(rangeParts) > 3)
        println("ERR: too many elements in range object (use x:y or x:y:z)");
        usage();
        return -1;
    end

    # error check order of range parts (rangeParts should be sorted)
    if (foldl(<,rangeParts) != true)
        println("ERR: the parts of the range object must be in ascending
    order");
        usage();
        return -1;
    end

    # if no iterator
    if (length(rangeParts) == 2)
        return rangeParts[1]:rangeParts[2];
    end
        
    # if iterator exists
    if (length(rangeParts) == 3)
        return rangeParts[1]:rangeParts[2]:rangeParts[3];
    end

end

# error check for proper number of command line arguments
if (length(ARGS) != 3)
    println("ERR: only 3 command line arguments allowed");
    usage();
    exit();
end

# the number of plots to be made of the provided function
numPlots = 0:parse(Int, ARGS[1]);

# the domain of the plot
domain = parseRange(ARGS[2]);

# the range of the plot
range = parseRange(ARGS[3]);

# -----------END INPUT-----------

data = mkSharedScatters(domain, range, getProvFunc, numPlots);
savefig(plot(data), "output.pdf");
