# ----------BEGIN IMPORTS----------

using Pkg;

# add MATLAB engine support
# setup instructions found at "https://juliaobserver.com/packages/MATLAB"
Pkg.add("MATLAB");
using MATLAB;

# -----------END IMPORTS-----------

# y''(x) = -(λ - x²) * y; -L <= x <= L
# y(-L) = y(L) = 0
# second order must be converted to system of first orders
# because y'(x)=0 (no y' in y''(x)), no changes need be made
# http://phaser.com/modules/elaydi/content/helptips/secondorderode.html

# the width of the domain
L = parse(Float64, ARGS[1]);
lambda = 15;

# the provided function solved for 0
origFunc(x, y, lambda) = [ y(2) + (-(lambda - (x^2)) * y(1)) ];

# initial guess for value of y (y = 0)
#MATyinit = mxarray([ 0 ]);
mat"MATyinit = @(x) [0];"

# NOTE: instead of passing functions to MATLAB, pass the arrays the functions
#       will generate (since that's what it's after anyway (I think))

solinit = mxcall(:bvpinit, 1, mxarray(-L:L), MATyinit, lambda);

#sol = mxcall(:bvp4c, 1, 

#mat"""
#    lambda = 15;
#    solinit = bvpinit(linspace(-100, 1.0, 100), $MATyinit, lambda)
#
#    
#"""

    #function dydx = origFunc(x,y,lambda)
    #dydx = [ y(2) + (-(lambda - (x^2)) * y(1)) ];
