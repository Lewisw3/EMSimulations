function [X, Z, Bx, Bz, B] = biotSavart2D(x, y, z, I)
% Calculate B field in 2D
% This function takes in an arbitrary current distriubtion and calculates
% the magnetic field everywehre using a numerical Biot-Savart law
% returns the view on the XZ plane (y=0)

%=================
% Initialisation
%=================

% definte the vacuum permeability
mu0 = 4*pi*1e-7;
% definte the constant in front of the biot-savart law
const = (mu0*I)/(4*pi);

% Enter the dimensions for the xy plane to contain the charges 
xMin = min(x) - 1; 
xMax = max(x) + 1;
zMin = min(z) - 1;
zMax = max(z) + 1;

% number of dl current elements 
n = length(x);

step = 0.2;
% create mesh grid, the step size is abritrary, chosen for good visulation 
[X, Z] = meshgrid(xMin:step:xMax, zMin:step:zMax);

% Initialise the field matrices that store the vector field data to the same size
% as the meshgrid we created
B = zeros(size(X, 1), size(Z, 2)); % magnitude of B field
Bx = B; % x component of B field
Bz = B; % y component of B girld

%============================
% Compute Magnetic Field (2D)
%============================

% Repeat for the vector matrices
threshold = 10^-1;

% for each point in space
for i = 1:size(X, 1)
    for j = 1:size(Z, 2)
            % for each of the current segments
            for l = 1:n-1
                % define the current segment along the wire
                dl = [x(l+1)-x(l), y(l+1) - y(l), z(l+1) - z(l)];
                 % define position as mid point of the segment
                dlpos = [x(l+1)+x(l), y(l+1)+y(l), z(l+1)+z(l)]./2;
                
                % calculate separation from point of interest (on xz plane)
                Rx = (X(i, j) - dlpos(1)); % x component of separation vector             
                Ry = (0 - dlpos(2)); % y component of separation vector
                Rz = (Z(i, j) - dlpos(3)); % z component of separation vector
                R = sqrt(Rx^2 + Ry^2 + Rz^2); % magnitude of separation vector

                if R <= threshold 
                    % if the separation is too small the set it to 1
                    % this helps for visualising the fields
                    R = 1;
                end
                
                % Calculate B field from biot savart law in 2D
                % (note the cross product is evaluated in cartesian coordinates 
                % for simplicity)       
                dBx = (const/(R^3))*(dl(2)*Rz - Ry*dl(3));
                dBz = (const/(R^3))*(dl(1)*Ry - Rx*dl(2));
       
                 % add the contribution from this segment to the total field 
                Bx(i, j) = Bx(i, j) + dBx;
                Bz(i, j) = Bz(i, j) + dBz; 
                       
            end
    end
end   

% define B as the magnitude matrix (used for normalization purposes)
B = (Bx.^2 + Bz.^2).^(1/2);
axis equal;