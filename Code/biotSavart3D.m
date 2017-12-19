function [X, Y, Z, Bx, By, Bz, B] = biotSavart3D(x, y, z, I)
% Calculate B field in 3D
% This function takes in an arbitrary current distriubtion and calculates
% the magnetic field everywehre using a numerical Biot-Savart law

%=================
% Initialisation
%=================

% definte the vacuum permeability
mu0 = 4*pi*1e-7;
% definte the constant in front of the biot-savart law
const = (mu0*I)/(4*pi);

% Enter the dimensions for the  to contain the charges 
xMin = min(x) - 0.5; 
xMax = max(x) + .5;
yMin = min(y) - .5;
yMax = max(y) + .5;
zMin = min(z) - .5;
zMax = max(z) + .5;

% number of dl current elements 
n = length(x);

step = 0.5;
% create mesh grid that defines each point in space 
[X, Y, Z] = meshgrid(xMin:step:xMax, yMin:step:yMax, zMin:step:zMax);

% Initialise the field matrices that store the vector field data to the same size
% as the meshgrid we created
B = zeros(size(X, 1), size(Y, 2), size(Z, 3)); %total B magnitude
Bx = B; % x component of B field
By = B; % y component of B field
Bz = B; % z component of B field

%============================
% Compute Magnetic Field (3D)
%============================

% define a threshold distance to avoid B blowing up
threshold = 10^-1;
% for each point in space
for i = 1:size(X, 1)
    for j = 1:size(Y, 2)
        for k = 1:size(Z, 3)
            % for each current segment dl
            for l = 1:n-1
                % define the current segment along the wire
                dl = [x(l+1)-x(l), y(l+1) - y(l), z(l+1) - z(l)];
                % define position as mid point of the segment
                dlpos = [x(l+1)+x(l), y(l+1)+y(l), z(l+1)+z(l)]./2;
                
                % calculate separation from point of interest
                Rx = (X(i, j, k) - dlpos(1)); % x component of separation vector
                Ry = (Y(i, j, k) - dlpos(2)); % y component of separation vector
                Rz = (Z(i, j, k) - dlpos(3)); % z component of separation vector
                R = sqrt(Rx^2 + Ry^2 + Rz^2); % magnitude of separation vector

                if R <= threshold 
                    % if the separation is too small the set it to 1
                    % this helps for visualising the fields
                    R = 1;
                end

                % Calculate B field from biot savart law in 3D
                % (note the cross product is evaluated in cartesian coordinates 
                % for simplicity)
                dBx = (const/(R^3))*(dl(2)*Rz - Ry*dl(3));
                dBy = -(const/(R^3))*(dl(1)*Rz - Rx*dl(3));
                dBz = (const/(R^3))*(dl(1)*Ry - Rx*dl(2));

               % add the contribution from this segment to the total field             
                Bx(i, j, k) = Bx(i, j, k) + dBx;
                By(i, j, k) = By(i, j, k) + dBy;
                Bz(i, j, k) = Bz(i, j, k) + dBz;               
            end
        end
    end    
end   

% define B as the magnitude matrix (used for normalization purposes)
 B = (Bx.^2 + By.^2 + Bz.^2).^(1/2);




