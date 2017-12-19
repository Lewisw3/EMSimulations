function [X,Y,Z,Bx,By,Bz,B] = dipoles3D(x,y,z,m)
% Calculate B field in 3D from magnetic dipoles
% This function takes in an arbitrary distrubtion of pure magnetic dipoles
% and calculates the resulting magnetic, B, field

%=================
% Initialisation
%=================
% definte the vacuum permeability
mu0 = 4*pi*1e-7;
% definte the constant in front of the biot-savart law
const = (mu0)/(4*pi);

% Enter the dimensions to contain the charges 
xMin = min(x) - 3; 
xMax = max(x) + 3;
yMin = min(y) - 3;
yMax = max(y) + 3;
zMin = min(z) - 3;
zMax = max(z) + 3;

% define the step size
dx = 1;

% create mesh grid
[X, Y, Z] = meshgrid(xMin:dx:xMax, yMin:dx:yMax, zMin:dx:zMax);

% Initialise the field matrices that store the vector field data to the same size
% as the meshgrid we created
B = zeros(size(X, 1), size(Y, 2), size(Z, 3));
Bx = B; % x component of B field
By = B; % y component of B field
Bz = B; % z component of B field
ex = B; % x unit vector 
ey = B; % y unit vector
ez = B; % z unit vector

threshold = 10^-1;
n = length(x);

%============================
% Compute Magnetic Field (3D)
%============================

% for each dipole
for l = 1:n
    % get magnetic moment
    mom = m(l);
    % for each point in space
    for i = 1:size(X, 1)
        for j = 1:size(Y, 2)
            for k = 1:size(Z, 3)
                % convert separation into spherical cooridinates
                [phi, el, r] = cart2sph(X(i, j, k)-x(l), Y(i, j, k)-y(l), Z(i, j, k)-z(l));
                % adjust matlab convention to physics convention of
                % spherical coordinates
                theta = (pi/2) - el;
                % avoid field blowing up
                if r < threshold; r = 0.5; end;
                % calculate the magnetic field components using the dipole
                % formula
                Bx(i, j, k) = Bx(i, j, k) + const*mom*(3*sin(theta)*cos(theta)*cos(phi))/r^3;
                By(i, j, k) = By(i, j, k) + const*mom*(3*sin(theta)*cos(theta)*(sin(phi)))/r^3;
                Bz(i, j, k) = Bz(i, j, k) + const*mom*((2*cos(theta))^2-(sin(theta))^2)/r^3;
                % calculate the unit vector components
                ex(i, j, k) = (X(i, j, k)-x(l))/r;
                ey(i, j, k) = (Y(i,j,k)-y(l))/r;
                ez(i, j, k)= (Z(i,j,k)-z(l))/r;
            end

        end
    end
end
% calculate the total B field
B = Bx.*ex + By.*ey + Bz.*ez;

end