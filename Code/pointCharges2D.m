function [X, Y, Ex, Ey, E] = pointCharges(x, y, Q, epsR) 
% Calculate E field in 2D
% This function takes in an arbitrary point charge distriubtion and finds
% the electric field everywehre using the princirple of superposition

%=============
% DEFINITIONS
%=============
% work in a cartesian coordinate system
% x = x coordinates of point charges
% y = y coordinates of point charges
% Q = size of each charge in Coloumbs
% n = number of electric point charges
% E = Total electric field
% Ex = x component of electric Field
% Ey = y component of electric Field
% eps_r = Relative permittivity (charges in a dielectric medium)
% ex = unit vector for x-component electric field
% ey = unit vector for y-component electric field
% r = distance between a selected point and the location of charge

%=================
% Initialisation
%=================

% Constant 1/(4*pi*epsilon_0) = 9*10^9
k = 9E9;

% Enter the Relative permittivity
eps_r = epsR;

% update the constant to for dielectric 
k_rel = k / eps_r;

% Enter the dimensions for the xy plane to contain the charges 
xMin = min(x) - 5; 
xMax = max(x) + 5;
yMin = min(y) - 5;
yMax = max(y) + 5;

% choose an appropriate step size so that the plot looks reasonable
% step size depends on how far apart the point charges are
% bear in mind that the E field will be calculated at each step
if xMax > 10 && xMax <= 30
    dx = 2;
    dy = 2;
elseif xMax >= 30
    % for larger plots use a bigger step size
    dx = 3;
    dy = 3;
else 
    dx = 1;
    dy = 1;
end
% Enter the number of charges.
n = length(Q);

% create mesh grid. the step size needs some work
[X, Y] = meshgrid(xMin:dx:xMax, yMin:dy:yMax);

% Initialise the field matrices that store the vector field data to the same size
% as the meshgrid we created
E = zeros(size(X, 1), size(Y, 2));
Ex = E;
Ey = E;
Econt = E;
% Repeat for the vector matrices
ex = E;
ey = E;
r = E;

%============================
% Compute Electric Field (2D)
%============================
threshold = 10^-1;
% for systems with a large number of charges the integration will be slow
% so include a progress bar
if n > 1000
    wb = waitbar(0,'Integrating, please wait...');
end
% for each of the point charges
for k = 1:n
    
    % get the coloumb charge
    q = Q(k);
    
    % compute the unit vectors at each point
    for i = 1:size(X, 1)
        for j = 1:size(Y, 2)
            % find the separation from the point charge
            r(i, j) = sqrt((X(i, j)-x(k))^2 + (Y(i,j)-y(k))^2);
            
            % E field reaches a dirac delta function at the charge itself
            % so just set the field here to NaN, will deal with shortly
             if abs(r(i, j)) <= threshold;
                 r(i, j) = NaN;
             end
            % and to the x and y unit vector by finding cosine of the angle
            ex(i, j) = (X(i, j)-x(k))/r(i, j);
            ey(i, j) = (Y(i,j)-y(k))/r(i, j);
        end
    end
     
    % update the wait bar with proress
    if n > 1000, waitbar(k/n); end;
    
    % calculate the electric field component
    Econt = (k_rel.*q)./((r).^2);

    if q < 0 
        % this is non-physical but it allows continuity of the surf plot
        % for negative charges set the field at r=0 to the minimum E value 
        Econt(isnan(Econt(:))) = min(Econt(:));
    else 
        % for positive charges set the field at r=0 to the maximum E value
        Econt(isnan(Econt(:))) = max(Econt(:));
    end
    
    % compute the electric field components everywhere
    
    Ex = Ex + Econt.*ex; % add to the x component of the E field
    Ey = Ey + Econt.*ey; % add to the y component of the E field
    E = E + Econt; % add to the total E field
    
    % now repeat for the next charges and use superposition
end
% close the progress bar, the integration is complete
if n > 1000, close(wb); end;

