function [X,Y,Bx,By,B] = dipoles2D(x,y,m)
% Calculate B field in 2D from magnetic dipoles
% This function takes in an arbitrary distrubtion of pure magnetic dipoles
% and calculates the resulting magnetic, B, field

%=================
% Initialisation
%=================
% definte the vacuum permeability
mu0 = 4*pi*1e-7;
% definte the constant in front of the biot-savart law
const = (mu0)/(4*pi);

% Enter the dimensions for the xy plane to contain the charges 
xMin = min(x) - 3; 
xMax = max(x) + 3;
yMin = min(y) - 3;
yMax = max(y) + 3;

% define the step size
dx = 0.5;

% create mesh grid. the step size needs some work
[X, Y] = meshgrid(xMin:dx:xMax, yMin:dx:yMax);

% Initialise the field matrices that store the vector field data to the same size
% as the meshgrid we created
B = zeros(size(X, 1), size(Y, 2));
Bx = B; % initialise the x component of the B field
By = B; % initialise the y component of the B field
ex = B; % initialise the x unit vector everywhere
ey = B; % initialise the y unit vector everywhere

threshold = 10^-1;
% define the number of dipoles
n = length(x);

%============================
% Compute Magnetic Field (2D)
%============================

% for each dipole
for l = 1:n
    % get magnetic moment
    mom = m(l);
    % for each point in space
    for i = 1:size(X, 1)
        for j = 1:size(Y, 2)
                % convert field to polar coordinates
                [theta, r] = cart2pol(X(i, j)-x(l), Y(i, j)-y(l));
                % avoid field blowing up
                if r < threshold; r = 0.5; end;
                % add x contribution to magnetic field using dipole formula
                Bx(i, j) = Bx(i, j) + const*mom*(2*(cos(theta)^2)-(sin(theta))^2)/r^3;
                % add y contribution to magnetic field using dipole formula
                By(i, j) = By(i, j) + const*mom*(3*sin(theta)*cos(theta))/r^3;
                % find the x direction
                ex(i, j) = (X(i, j)-x(l))/r;
                % find the y direction
                ey(i, j) = (Y(i,j)-y(l))/r;
                
         end
    end
end
% find the total field
B = Bx.*ex + By.*ey; 
end

