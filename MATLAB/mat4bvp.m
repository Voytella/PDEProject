function mat4bvp

lambda = 0;
solinit = bvpinit(linspace(-100,100),@mat4init,lambda);
sol = bvp4c(@mat4ode,@mat4bc,solinit);

fprintf('The fourth eigenvalue is approximately %7.3f.\n',...
        sol.parameters)

xint = linspace(-100,100);
Sxint = deval(sol,xint);
plot(xint,Sxint(1,:))
axis([-100 100 -100 100])
title('Eigenfunction of Hermite polynomial.') 
xlabel('x')
ylabel('solution y')
% ------------------------------------------------------------
function dydx = mat4ode(x,y,lambda)
dydx = [  y(2) 
          -(lambda - (x^2)) * y(1) ];
% ------------------------------------------------------------
function res = mat4bc(ya,yb,lambda)
res = [  ya(1) 
         yb(1) 
         0 ];
% ------------------------------------------------------------
function yinit = mat4init(x)
yinit = [ x
          1 ];
% singular Jacobian error is because guess is divergent
