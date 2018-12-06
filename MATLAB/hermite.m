% declare symbol to be used in function
syms x;

% calculate hermite polynomials
h = hermiteH([0,1,2,3],x);

% calculate the functions to be plotted
y=exp((x^2)/2) * h;

% plot the functions
fplot(y)
