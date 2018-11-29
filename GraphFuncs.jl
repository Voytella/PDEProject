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

# print instructions for running the program and exit
function usage()
    println("placeholder");
    exit();
end

# recursively derive 'func' 'amt' number of times
function derivMany(func, amt)
    if (amt == 0) 
        return func;
    end
    derivMany(derivative(func), amt-1);
end

# return the n^{th} Hermite polynomial
function getHermite(n)

    # explicitly define e^{-(x^2)} (necessary to make the Calculus pkg behave!)
    hermExp = (x) -> exp(-(x^2));
    
    return (x) -> (-1)^n * exp(x^2) * derivMany(hermExp, n)(x);
end

# evaluate a function across a range
function mkFuncPts(func, range)
    vals = [];
    for ii in range
        append!(vals, func(ii))
    end
    return vals;
end

# create a scatter to be added to a plot
function mkScatter(xVals, yVals)
    return scatter(x=xVals, y=yVals);
end

# generate list of scatters to be plotted across a shared axis
## domain:  the shared x values of the plot (range obj)
## range:   the values at which the functions are to be evaluated (range obj)
## funcGen: generator of the nth iteration of the provided function
## amt:     number of functions to be generated (plots to be created) (Int)
function mkSharedScatters(domain, range, funcGen, amt)
    
    # list of scatters to be plotted
    #scatters = [];

    # generate scatters for the given number, 'amt', of functions
    #for ii in amt
        # problem is appending "scatters" doesn't work (they work as expected
        # inside an array, though, 'append' just doesn't know how to handle them)
    #    append!(scatters, mkScatter(domain, mkFuncPts(funcGen(ii), range)));
    #end

    #return scatters;

    return [mkScatter(domain, mkFuncPts(funcGen(ii), range)) for ii in amt];
end

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

# the number of plots to be made of the provided function
numPlots = 0:parse(Int, ARGS[1]);

# the domain of the plot
domain = parseRange(ARGS[2]);

# the range of the plot
range = parseRange(ARGS[3]);

# -----------END INPUT-----------

# ----------BEGIN CONFIGURATION----------

# get the provided function for a certain value of 'n'
function getProvFunc(nVal)
    return (x) -> exp((x^2) / 2) * getHermite(nVal)(x);
end

# -----------END CONFIGURATION-----------

data = mkSharedScatters(domain, range, getProvFunc, numPlots);
savefig(plot(data), "output.pdf");

# get both 'x' and 'n' from the command line
#xIn = parse(Float64, ARGS[1]);
#nIn = parse(Int, ARGS[2]);

# evaluate and print the found Hermite function
#println(getHermite(nIn)(xIn))
