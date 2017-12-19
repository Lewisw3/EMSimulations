function [X, Y, Ex, Ey, E, Vplot] = fieldFromPotential(V)
% Calculate the E field from arbitrary V(x,y)
% Function takes in a string equation for V and calculates the electric
% field by taking the gradient. Only works for electrostatics as it does
% not take into account the magnetic vector potential A


%==================
% INITIALISATION
%==================

% define x and y as symbolic variables to perform calculus
syms x y
% set the maximum range of the plot and the step size
xMax = 5;
yMax = 5;
dx = 0.5;

% define grid of points on xy domain
[X, Y] = meshgrid(-xMax:dx:xMax, -yMax:dx:yMax);

% Input validation for V would be incredibly challenging. We adopt (a poor)
% practice of attempting to calculate E and if we run into any trouble it
% stops and returns a general error. This could be improved upon from more
% advanced error checking if I had more time, but for now it stops a huge
% range of incorrect input. Some user knowledge of EM is assumed throughout
% this program

%===================
% CALCULATE E FIELD
%===================

% attempt to do the following calculations and return if anything happens
try 
    % convert the string V into a symbol
    V = sym(V);
    % take derivatives w.r.t. x and y
    delX = diff(V, x);
    delY = diff(V, y);
    % calculate the electric field using the formula E = -grad(V)
    Ex = zeros(size(X, 1));
    Ey = zeros(size(Y, 1));
    Vplot = zeros(size(X, 1));
    % find components of electric field by creating functions from symbols
    Ex_func = matlabFunction(-1*delX);
    Ey_func = matlabFunction(-1*delY);
    V_func = matlabFunction(V);
catch
    % bad practice, but we'll return anything that causes a problem 
    return
end

if delX == 0 && delY == 0
   % if it manages to differentiate ok but the expressions for V did not
   % contain any x or y's or if it was a scalar then E = 0 so throw error
    return
end


% we need to evaluate the electric field everywhere depending on the 
% functional dependence of the x and y component of the electric field 
% we evaluate the field everywhere by evaluating the matlab function  that
% we made from the symbolic expression over all points given by meshgrid

if length(symvar(delX)) == 2
    % if Ex equation is a function of x and y
    Ex = arrayfun(Ex_func, X, Y);
elseif symvar(delX) == x
    % if Ex equation is just a function of x
    Ex = arrayfun(Ex_func, X);
elseif symvar(delX) == y
    % if Ex equation is just a function of y
    Ex = arrayfun(Ex_func, Y);
else
    % if Ex equation is a scalar
    Ex(:) = Ex_func();
end

if length(symvar(delY)) == 2
    % if Ey equation is a function of x and y
    Ey = arrayfun(Ey_func, X, Y);
elseif symvar(delY) == x
    % if Ey equation is a function of x
    Ey = arrayfun(Ey_func, X);
elseif symvar(delY) == y
    % if Ey equation is a function of y
    Ey = arrayfun(Ey_func, Y);
else
    % if Ey equation is a scalar
    Ey(:) = Ey_func();
end

if length(symvar(V)) == 2
    % if equation for V is a function of x and y
    Vplot = arrayfun(V_func, X, Y);
elseif symvar(V) == x
    % if equation for V is a function of x
    Vplot = arrayfun(V_func, X);
elseif symvar(V) == y
    % if equation for V is a function of y
    Vplot = arrayfun(V_func, Y);
else
    % if equation for V is a scalar
    Vplot(:) = V_func();
end

% determine the magnitude of the electric field
E = (Ex.^2 + Ey.^2).^(1/2);
% normalize the field components
Ex = Ex ./ E;
Ey = Ey ./ E;

end