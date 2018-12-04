# ----------BEGIN IMPORTS----------

using Pkg;

# ODE solver
Pkg.add("ODEInterface");
using ODEInterface;
@ODEInterface.import_huge;

# -----------END IMPORTS-----------

# y''(x) = -(λ - x²) * y; -L <= x <= L
# y(-L) = y(L) = 0
# second order must be converted to system of first orders
# because y'(x)=0 (no y' in y''(x)), no changes need be made
# http://phaser.com/modules/elaydi/content/helptips/secondorderode.html


# get the domain from the command line
L = parse(Float64, ARGS[1]);

# initialize bounds
Lower = -L
Upper = L

# declare precision constant
global ε = nothing;

# the right-hand-side of the differential equation divided by epsilon
function rhs(x, y, λ, f)
    f[1] = ( ( λ[1] - x^2 ) * y[1] ) / ε;
end

# the derivative of the rhs wrt both y and λ
function Drhs(x, y, λ, dfdy, dfdλ)
    dfdy[1,1] = (λ[1] - (x^2)) / ε;
    dfdλ[1,1] = y[1] / ε;
end 

# the boundary conditions of y
function boundCond(yLower, yUpper, λ, boundCondLower, boundCondUpper)
    boundCondLower[1] = yLower[1] - 0.0;
    boundCondLower[1] = yUpper[1] - 0.0;
end

# derive upper and lower boundary conditions wrt y and λ
function DboundCond(yLower, yUpper, dyLower, dyUpper, λ, dλLower, dλUpper)
    dyLower[1,1] = 0.0;
    dyUpper[1,1] = 0.0;
    dλLower[1,1] = 0.0;
    dλUpper[1,1] = 0.0;
end

# options for the boundary condition solver
#opt = OptionsODE("hermite",
#                 OPT_RTOL => 1e-6,
#                 OPT_METHODCHOICE => 4
#                 );

# initialize an array of domain points
domain = Lower:Upper;

# the initial guess of the solver
initGuess = Bvpm2();

# initialize the solver with the initial guess
bvpm2_init(initGuess, 1, 1, Lower:5.0:Upper, [0.5], [1.0]);

# initialize a blank solution
sol = nothing;

# initialize a blank previous solution
prevSol = nothing;

# initialize a blank previous precision constant
prevε = nothing;

# perform the calculations for different precision constants
for ε = [0.1, 0.05, 0.02, 0.01]
    
    # the guess for the current round of calculations is either the initial
    # solution or the previous solution
    guess = (prevSol != nothing) ? prevSol : initGuess;

    # solve the boundary value problem with the variables calculated above
    sol, retcode, stats = bvpm2_solve(guess, rhs, boundCond, Drhs=Drhs,
    Dbc=DboundCond); 

    # display the current precision constant and the exit code of the solver
    @printf("ε=%g, retcode=%i\n", ε, retcode);

    # ensure that the solver had not errored
    @assert retcode >= 0;

    # the solution of the solver evaluated at each point in 'domain'
    results = evalSolution(sol, domain);

    # store the old results in the proper place
    if (prevSol == nothing)
        prevResults = copy(results);
        prevResults[1,:] = 0.5;
    else
        prevResults = evalSolution(prevSol, domain);
        bvpm2_destroy(prevSol);
    end

    # store current information in preparation for next loop iteration
    prevSol = sol;
    prevε = ε;
end

# remove stale object (probably not necessary, but I'll leave it for now)
bvpm2_destroy(initGuess);
bvpm2_destroy(sol);
