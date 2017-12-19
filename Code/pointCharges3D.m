function [X, Y, Z, Ex, Ey, Ez, E] = pointCharges3D(x, y, z, Q, epsR)
% Calculate E field in 3D
% This function takes in an arbitrary point charge distriubtion and finds
% the electric field everywehre using the princirple of superposition

%=============
% DEFINITIONS
%=============
% definitions of constant, similar for the B Field
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
zMin = min(z) - 5;
zMax = max(z) + 5;

% choose an appropriate step size so that the plot looks reasonable
% step size depends on how far apart the point charges are
if xMax <= 4
    dx = 0.5;
    dy = 0.5;
    dz = 0.5;
elseif xMax >= 30
    % for larger plots use a bigger step size
    dx = 3;
    dy = 3;
    dz = 3;
else 
    dx = 1;
    dy = 1;
    dz = 1;
end

% Enter the number of charges.
n = length(Q);

% create mesh grid. the step size needs some work
[X, Y, Z] = meshgrid(xMin:dx:xMax, yMin:dy:yMax, zMin:dz:zMax);

% Initialise the field matrices that store the vector field data to the same size
% as the meshgrid we created
E = zeros(size(X, 1), size(Y, 2), size(Z, 3)); %  total E field 
Ex = E; % x component of E
Ey = E; % y componet of E
Ez = E; % z componet of E

% Repeat for the vector matrices
ex = E; % x-hat unit vector everywhere
ey = E; % y-hat unit vector
ez = E; % z-hat unit vector
r = E; % separation vector

%============================
% Compute Electric Field (3D)
%============================

threshold = 10^-1;
% for each of the point charges
for k = 1:n
    % get the coloumb charge
    q = Q(k);
   
    % compute the unit vectors at each point
    for l = 1:size(X, 1)
        for j = 1:size(Y, 2)
            for i = 1:size(Z, 3)
                
             % find the separation from the point charge
               r(l, j, i) = sqrt((X(l,j,i)-x(k))^2 + (Y(l,j,i)-y(k))^2 ...
                 + (Z(l,j,i)-z(k))^2);

             % E field reaches a dirac delta function at the charge itself
             % so just set the field here to NaN, will deal with shortly
               if abs(r(l, j, i)) <= threshold;
                   r(l, j, i) = NaN;
               end
               
                % and to the x and y unit vector by finding cosine of the angle
                ex(l, j, i) = (X(l, j, i)-x(k))/r(l, j, i);
                ey(l, j, i) = (Y(l, j, i)-y(k))/r(l, j, i);
                ez(l, j, i) = (Z(l, j, i)-z(k))/r(l, j, i);
        
            end          
        end
    end
    % find the electric field contribution from this point charge   
    Econt = (k_rel.*q)./((r).^2);
  
    if q < 0 
        % this is non-physical but it allows continuity of the surf plot
        % for negative charges set the field at r=0 to the minimum E value 
        Econt(isnan(Econt(:))) = min(Econt(:));
    else 
        % for positive charges set the field at r=0 to the maximum E value
        Econt(isnan(Econt(:))) = max(Econt(:));
    end
    
    % add the electric field contribution  
    Ex = Ex + Econt.*ex; % add the x component of E
    Ey = Ey + Econt.*ey; % add the y component of E
    Ez = Ez + Econt.*ez; % add the z component of E
    E = E + Econt; % add to the magnitude of E

    % now repeat for the next charges and use superposition
end
