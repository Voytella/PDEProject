function mat4bvp

lambda = 15;
solinit = bvpinit(linspace(-10,10),@mat4init,lambda);
sol = bvp4c(@mat4ode,@mat4bc,solinit);

fprintf('The fourth eigenvalue is approximately %7.3f.\n',...
        sol.parameters)

xint = linspace(-10,10);
Sxint = deval(sol,xint);
plot(xint,Sxint(1,:))
axis([-10 10 -10 10])
title('Eigenfunction of Hermite polynomial.') 
xlabel('x')
ylabel('solution y')
% ------------------------------------------------------------
function dydx = mat4ode(x,y,lambda)
dydx = [  y(2) + (-(lambda - (x^2)) * y(1)) ];
% ------------------------------------------------------------
function res = mat4bc(ya,yb,lambda)
res = [  ya(2) 
         yb(2) ];
% ------------------------------------------------------------
function yinit = mat4init(x)
yinit = [ 0 ];
      
