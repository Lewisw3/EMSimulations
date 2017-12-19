% ********* LEWIS WOOLFSON, ENGR 105, ELECTROMAGENTIC SIMULATIONS *********
% Submitted 4th May 2015

%=========================================================================
%                              Simulations
%=========================================================================

% 1. Electric Point Charge(s) <-- has user mouse click abilities
% 2. Line of Charge
% 3. Calculate the Electric Field from given Electric Potential V(x,y)
% 4. Square Loop of Charge
% 5. Ring of Charge
% 6. Charge Disk
% 7. Straight Current-Carrying Wire
% 8. Solenoid
% 9. (Pure) Magnetic Dipoles
% 10. Bar Magnet (superposition of correctly aligned dipoles)
% 11. Motion of Charge Particle in Uniform E and B Fields

%=========================================================================
%                           Program Overview
%=========================================================================

% 1. User selects a simulation from the pop-up menu (see above)
% 2. The user inputs the data (or uses default data) and presses 'Enter'
% 3. The input data is uploaded onto the handles data structure
% 4. The user selects a graph type and presses plot button
% 5. The program selects the correct 'Plotting Function' that calls an
%    external function to calculate the EM field for that simulation *
% 6. The plotting function then plots results depending on the chosen graph

% * with the excpetion of simulation 11 where there is no external function

%=========================================================================
%                           GUI Components Key
%=========================================================================

% menuSim = pop-up menu with choice of simulation
% editText1-editText5 = text boxes for user input
% Text1-Text5 = static text for titles of user input parameters
% slider1-slider5 = slider corresponding to an editTextBox(1-5) 
% buttonEnter = pressed to submit the user input data
% buttonClearInputs = clear editText1-editText5
% buttonClearPlot = clears the axes
% buttonPlot = plots the current data that's uploaded into handles
% listBoxInputs = A listbox that displays the current user input data
% checkNormalize = Check box when pressed normalizes the current plot
% checkContours = Check box when pressed adds contour lines to current plot
% radio2D = Displays current plot in 2D
% radio3D = Displays current plot in 3D

% NOTE: because the purpose of the text boxes (Text1-Text5,
% editText1-editText5) change with each simulation it was easiest to just
% number them according to the order that they appear on the screen. Box
% number 1 is highest up and 5 is lowest. The same is true for the slides

% Automatically generated GUI code 
function varargout = EM(varargin)
% EM MATLAB code for EM.fig
%      EM, by itself, creates a new EM or raises the existing
%      singleton*.
%
%      H = EM returns the handle to a new EM or the handle to
%      the existing singleton*.
%
%      EM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EM.M with the given input arguments.
%
%      EM('Property','Value',...) creates a new EM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EM

% Last Modified by GUIDE v2.5 01-May-2015 22:02:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @EM_OpeningFcn, ...
                   'gui_OutputFcn',  @EM_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%=========================================================================
%                           Initialization
%=========================================================================

% --- Executes just before EM is made visible.
function EM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to EM (see VARARGIN)

% initialise all the global fields
% The purpose of these fields are to store the data used to generate the
% plots in the handles structure to enable access from various functions

handles.xData = []; % vector containting x axis plotting data
handles.yData = []; % vector containting y axis plotting data
handles.zData = []; % vector containting z axis plotting data
handles.qData = []; % vector containting point charge plotting data 
handles.VData = []; % stores potential V(x,y) equation 
handles.B = []; % Magnetic field for motion sim
handles.E = []; % Electric field for motion sim
handles.Length = []; % Length of point charge objects
handles.Current = []; % current for magnetic field objects
handles.NumTurns = []; % num turns for solenoid
handles.mData = []; % vector containting magnetic dipole moment data

% turn off all the sliders until a simulation is selected
set(handles.slider1, 'enable', 'off');
set(handles.slider2, 'enable', 'off');
set(handles.slider3, 'enable', 'off');
set(handles.slider4, 'enable', 'off');
set(handles.slider5, 'enable', 'off');

% turn off all the user input text box's until a simulation is selected
set(handles.editText1, 'enable', 'off');
set(handles.editText2, 'enable', 'off');
set(handles.editText3, 'enable', 'off');
set(handles.editText4, 'enable', 'off');
set(handles.editText5, 'enable', 'off');
set(handles.editTextEquation, 'enable', 'off');

% Choose default command line output for EM
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

%=========================================================================
%                           Choosing a Simulation
%=========================================================================

% First of all the user selects a simulation and the following function is
% called

% --- Executes on selection change in menuSim.
function menuSim_Callback(hObject, eventdata, handles)
% hObject    handle to menuSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FUNCTION OVERVIEW
% When the user selects a simulation it should configure the GUI with
% the appropriate input parameters and fields. Some fields will be disabled
% for some simulations. Next some default data is set and that data is 
% uploaded to handles and plotted so the user views a default plot
% everytime they select a new simulation

% Enable all the GUI components and set them to their default states
set(handles.text1, 'String', ''); % input title 1 e.g. x, Length etc
set(handles.text2, 'String', ''); % input title 2
set(handles.text3, 'String', ''); % input title 3 
set(handles.text4, 'String', ''); % input title 4 
set(handles.text5, 'String', ''); % input title 5 
set(handles.editText1, 'String', ''); % user input boxs from top to bottom
set(handles.editText2, 'String', '');
set(handles.editText3, 'String', '');
set(handles.editText4, 'String', '');
set(handles.editText5, 'String', '');
set(handles.editTextEquation, 'String', ''); % V(x,y) input box
set(handles.listboxInputs, 'String', ''); % list box to display user inputs
set(handles.editText1, 'enable', 'on'); % enable all the user inputs
set(handles.editText2, 'enable', 'on');
set(handles.editText3, 'enable', 'on');
set(handles.editText4, 'enable', 'on');
set(handles.editText5, 'enable', 'on');
set(handles.radio2D, 'enable', 'on'); % radio buttons chose 2D/3D plots
set(handles.radio3D, 'enable', 'on');
set(handles.checkNormalize, 'enable', 'on'); %check button to normalize plot
set(handles.slider1, 'enable', 'on'); % enable all the user input sliders
set(handles.slider2, 'enable', 'on');
set(handles.slider3, 'enable', 'on');
set(handles.slider4, 'enable', 'on');
set(handles.slider5, 'enable', 'on');
set(handles.checkContours, 'enable', 'on'); % check button to add contours
set(handles.editTextEquation, 'enable', 'on');
% clear all plotting data
handles.xData = []; % clear any x points (point charges)
handles.yData = [];% clear any y points (point charges)
handles.zData = [];% clear any z points (point charges)
handles.qData = [];% clear any charge information
handles.VData = [];% clear any V(x,y) equations
handles.E = []; % clear E field (motion sim)
handles.B = []; % clear B field (motion sim)
handles.Length = []; % clear length data 
handles.Current = []; % clear current data
handles.NumTurns = []; % clear number turns data
handles.mData = []; % clear magnetic moment data
set(handles.menuGraphs, 'Value', 1); % set the graphs pop-up menu to top choice
        
% set up GUI for each simulation type
if get(hObject, 'Value') == 1
        % Electric Point Charges Simulation
        
        % set the text boxes for point charges simulations
        set(handles.text1, 'String', 'X');
        set(handles.text2, 'String', 'Y');
        set(handles.text3, 'String', 'Z');
        set(handles.text4, 'String', 'Relative permittivity');
        set(handles.text5, 'String', 'Charge q');
        
        % set the types of graphs for point charge simulation
        set(handles.menuGraphs, 'String', {'Quiver Plot','Field Lines',...
            'Contour Plot', 'Surface Plot'});

        %set default values for a point charge at origin
        set(handles.editText1, 'String', '0');
        set(handles.editText2, 'String', '0');
        set(handles.editText3, 'String', '0');
        set(handles.editText4, 'String', '1');
        set(handles.editText5, 'String', '1');
        
        % disable input paramters that aren't needed
        set(handles.editTextEquation, 'enable', 'off');
        set(handles.editTextEquation, 'enable', 'off');
        
        % set 2d and 3d check box options (default to 2d)
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
        set(handles.checkNormalize, 'Value', 0);
        
        % set an intial plot of a point chage at the origin in 2D
        % upload the input data to handles
        buttonEnter_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        % plot the single point charge 
        buttonPlot_Callback(hObject, eventdata, handles)
end

if get(hObject, 'Value') == 2 || get(hObject, 'Value') == 4 || ...
        get(hObject, 'Value') == 5 || get(hObject, 'Value') == 6
% For all other simulations that are a superposition of point charges

% setup the GUI  depending on what input paramaters the sim requires 
    if get(hObject, 'Value') == 2
        % For the line of charge simulation define the length
         set(handles.text1, 'String', 'Length:');
    elseif get(hObject, 'Value') == 4
        % For the square loop of charge define the side length
         set(handles.text1, 'String', 'Side Length:');  
    else
        % For all other (ring of charge, charge disk) define the radius
        set(handles.text1, 'String', 'Radius: ');
    end

    if get(hObject, 'Value') == 6
        % for the charge disk since it is a solid object we define the
        % charge density per unit area as the usual sigma
         set(handles.text2, 'String', 'Sigma (C/m^2):');
    else
        % for everything else it is a 1D problem so we have charge/length
        set(handles.text2, 'String', 'Lambda (C/m):');
    end   

    if get(hObject, 'Value') >= 5
        % for the ring and disk simulations set then normalization of the 
        % quiver plot to default
        set(handles.checkNormalize, 'Value', 1);
    else
        % turn normalization off for the line of charge
        % and square loop of charge simulation
        set(handles.checkNormalize, 'Value', 0);
    end   

    % define other input parameters
    set(handles.text3, 'String', 'Relative permittivity');
    
    % disable unused input parameters
    set(handles.editText4, 'enable', 'off');
    set(handles.editText5, 'enable', 'off');
    set(handles.editTextEquation, 'enable', 'off');

    % set the plot types available for these simulations
    set(handles.menuGraphs, 'String', {'Quiver Plot','Field Lines',...
        'Contour Plot', 'Surface Plot'});

    if get(hObject, 'Value') == 6
        % for the charge disk default to 3D plot
        set(handles.radio2D, 'Value', 0);
        set(handles.radio3D, 'Value', 1);
    else
        % for everything else default to a 2D plot
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
    end

    %set the default initial data
    set(handles.editText1, 'String', '5');
    set(handles.editText2, 'String', '10');
    set(handles.editText3, 'String', '1');
    
    % upload the input data to handles
    buttonEnter_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    % plot the single point charge 
    buttonPlot_Callback(hObject, eventdata, handles)
end

if get(hObject, 'Value') == 3
    % Field from Potential simulation
   
    % disable all unsued user input boxs 
    set(handles.editText1, 'enable', 'off')
    set(handles.editText2, 'enable', 'off')
    set(handles.editText3, 'enable', 'off')
    set(handles.editText4, 'enable', 'off')
    set(handles.editText5, 'enable', 'off')

    % set the plot types that are available
    set(handles.menuGraphs, 'String', {'E Quiver Plot',...
        'E Field and V Contour', 'V Surface Plot'});

    % define the default V(x,y) equation 
    set(handles.editTextEquation, 'String', 'sin(x)*sin(y)');
    
    % set the default plot to the V surface plot in 3D
    set(handles.menuGraphs, 'Value', 3);
    
    % disable contours and normalisation
    set(handles.checkContours, 'enable', 'off');
    set(handles.checkNormalize, 'enable', 'off');

    % all plots should be in 3D, disable the 2D option
    set(handles.radio2D, 'Value', 0);
    set(handles.radio3D, 'Value', 1);
    set(handles.radio2D, 'enable', 'off');

    % upload the data into handles 
    buttonEnter_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    % plot the default data
    buttonPlot_Callback(hObject, eventdata, handles)
        
end

if get(hObject, 'Value') == 7
    % Magnetic field from a straight wire simulation
    
    % set the user input titles, all we need is length and current
    set(handles.text1, 'String', 'Length: ');
    set(handles.text2, 'String', 'Current I:');
    
    % turn off normalisation by default
    set(handles.checkNormalize, 'Value', 0);

    % disable unsused input components
    set(handles.editText3, 'enable', 'off');
    set(handles.editText4, 'enable', 'off');
    set(handles.editText5, 'enable', 'off');
    set(handles.editTextEquation, 'enable', 'off');

    % set the default plot types
    set(handles.menuGraphs, 'String', {'Quiver Plot','Field Lines'});

    % default to a 3D plot
    set(handles.radio2D, 'Value', 0);
    set(handles.radio3D, 'Value', 1);

    % set the default length and current values
    set(handles.editText1, 'String', '5');
    set(handles.editText2, 'String', '10');

    % upload the input data to handles
    buttonEnter_Callback(hObject, eventdata, handles)
    handles = guidata(hObject);
    % plot
    buttonPlot_Callback(hObject, eventdata, handles)
end


if get(hObject, 'Value') == 8
        % Solenoid simulation
         
        % set the input parameters 
        set(handles.text1, 'String', 'Number turns N: ');
        set(handles.text2, 'String', 'Current I:');
        set(handles.text3, 'String', 'Radius :');
             
        % turn off normalization by defualt
        set(handles.checkNormalize, 'Value', 0);
                
        % disable unused input components
        set(handles.editText4, 'enable', 'off');
        set(handles.editText5, 'enable', 'off');
        set(handles.editTextEquation, 'enable', 'off');
       
        % set the plot types
        set(handles.menuGraphs, 'String', {'Quiver Plot','Field Lines'});
        
        % default to a 3D plot
        set(handles.radio2D, 'Value', 0);
        set(handles.radio3D, 'Value', 1);
        
        % set the default input values
        set(handles.editText1, 'String', '20');
        set(handles.editText2, 'String', '3');
        set(handles.editText3, 'String', '1');
        
        % upload the input data to handles
        buttonEnter_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        % plot 
        buttonPlot_Callback(hObject, eventdata, handles)
end

if get(hObject, 'Value') == 9
        % Magnetic Dipoles simulation
        
        % set the input parameters for position of dipole and the moment
        set(handles.text1, 'String', 'X');
        set(handles.text2, 'String', 'Y');
        set(handles.text3, 'String', 'Z');
        set(handles.text4, 'String', 'Dipole Moment m');
        
        % set the types of graphs for point charge simulation
        set(handles.menuGraphs, 'String', {'Quiver Plot','Field Lines',...
            'Contour Plot', 'Surface Plot'});
        
        %set default values for a pure dispole at origin with m=1
        set(handles.editText1, 'String', '0');
        set(handles.editText2, 'String', '0');
        set(handles.editText3, 'String', '0');
        set(handles.editText4, 'String', '1');
        
        % disable unsued input parameters
        set(handles.editText5, 'enable', 'off');
        set(handles.editTextEquation, 'enable', 'off');
        
        % set 2d and 3d check box options (default to 2d)
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
        set(handles.checkNormalize, 'Value', 1);
        
        % upload the input data to handles
        buttonEnter_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        % plot 
        buttonPlot_Callback(hObject, eventdata, handles)
end

if get(hObject, 'Value') == 10
        % Bar Magnet simulation; a superposition of pure dipoles
        
        % set the input parameters - Magnetization is m per unit volume
        set(handles.text1, 'String', 'Length');
        set(handles.text2, 'String', 'Magnetization M');
        
        % disable unused components 
        set(handles.editText3, 'enable', 'off');
        set(handles.editText4, 'enable', 'off');
        set(handles.editText5, 'enable', 'off');
        set(handles.editTextEquation, 'enable', 'off');
        % set the types of graphs for point charge simulation
        set(handles.menuGraphs, 'String', {'Quiver Plot','Field Lines',...
            'Contour Plot', 'Surface Plot'});
        
        %set default values
        set(handles.editText1, 'String', '10');
        set(handles.editText2, 'String', '1');

        % set 2d and 3d check box options (default to 2d)
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
        set(handles.checkNormalize, 'Value', 1);
        
        
        % upload the input data to handles
        buttonEnter_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        % plot the single point charge 
        buttonPlot_Callback(hObject, eventdata, handles)
end

if get(hObject, 'Value') == 11
        % particle motion in uniform E & M fields
        
        % set the input values
        % electric field
        set(handles.text1, 'String', 'E field: Ex, Ey, Ez');
        % magnetic field
        set(handles.text2, 'String', 'B field: Bx, By, Bz');
        % initial velocity
        set(handles.text3, 'String', 'V initial Vx, Vy, Vz');
        % initial position
        set(handles.text4, 'String', 'Initial Position x, y, z');
        % charge-mass ratio
        set(handles.text5, 'String', 'Charge:Mass (q/m)');
        
        % set the types of graphs for point charge simulation
        set(handles.menuGraphs, 'String', 'Motion Plot');
        
        % disable unsued input parameters slider in this case cannot input
        % the 3D vector data that we need so we just turn it off
        set(handles.slider1, 'enable', 'off');
        set(handles.slider2, 'enable', 'off');
        set(handles.slider3, 'enable', 'off');
        set(handles.slider4, 'enable', 'off');
        set(handles.checkContours, 'enable', 'off');
        set(handles.checkNormalize, 'enable', 'off');
        set(handles.radio2D, 'enable', 'off');
        set(handles.radio3D, 'enable', 'off');
        set(handles.slider5, 'enable', 'off');
        set(handles.editTextEquation, 'enable', 'off');
     
        % set the default values for a 2D trajectory
        set(handles.editText1, 'String', '0, 0, 1');
        set(handles.editText2, 'String', '1, 0, 0');
        set(handles.editText3, 'String', '0, 0, 0');
        set(handles.editText4, 'String', '0, 0, 0');
        set(handles.editText5, 'String', '0.3');

        % set 2d and 3d check box options (default to 2d)
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
        set(handles.checkNormalize, 'Value', 0);
        
        % disable input paramters that aren't needed
        set(handles.editTextEquation, 'enable', 'off');

        % upload the input data to handles
        buttonEnter_Callback(hObject, eventdata, handles)
        handles = guidata(hObject);
        % plot the single point charge 
        buttonPlot_Callback(hObject, eventdata, handles) 
end

guidata(hObject, handles);

%=========================================================================
%                  Analyse and Upload User Input Data
%=========================================================================

% The following function is called when you press enter to input the data.
% It performs calculations on the data and uploads the results into handles
% for the plotting functions to access

% --- Executes on button press in buttonEnter.
function buttonEnter_Callback(hObject, eventdata, handles)
% hObject    handle to buttonEnter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Calculate the appropriate plotting parameters for each of the simulations
% We have an listbox that displays the current user input data that we
% update


if get(handles.menuSim, 'Value') == 1 
    % For the point charges simulation
    % Get the input parameters from the input boxes
    x = str2num(get(handles.editText1, 'String'));
    y = str2num(get(handles.editText2, 'String'));
    z = str2num(get(handles.editText3, 'String'));
    q = str2num(get(handles.editText5, 'String'));

    % if non-numeric data is entered then str2num will return [], so we
    % check to see if any of the parameters are empty and if so throw error
    if isempty(x) || isempty(y) || isempty(z) || isempty(q)
        warndlg('Input parameters must be numeric! Using default values');
        x = 0;
        y = 0;
        z = 0;
        q = 1;
    end
    
    % Perform input validation to ensure the charges are not too far away
    % and to produce pleasing plots (after checking they are numbers first)
    if abs(x) > 100 || abs(y) > 100 ||  abs(z) > 100 || abs(q) > 100
         warndlg('Input data out of range. Using r = (0, 0, 0) q = 1C instead.');
         x = 0;
         y = 0;
         z = 0;
    end
    
    % append the position and charge of this particular charge to the
    % handles data, we can have multiple charges at once
    handles.xData(end+1) = x; % x position of point charge
    handles.yData(end+1) = y; % y position of point charge
    handles.zData(end+1) = z; % z position of point charge
    handles.qData(end+1) = q; % q charge of point charge
    
    % we have a listbox that displays the current input parameters
    % find the previous text from the list box
    previousString = cellstr(get(handles.listboxInputs, 'String'));
    % form a new line with this particular point charge
    newLine = sprintf('Position = (%0.2f, %0.2f, %0.2f) q = %0.2f C',...
                        x, y, z, q);
                    
    if strcmp(previousString, '');
        % add new line to the top
        set(handles.listboxInputs, 'String', newLine);
    else
        % append new line to the bottom of the list
        newString = [previousString;{newLine}];
        set(handles.listboxInputs, 'String', newString);
    end
end




if get(handles.menuSim, 'Value') == 2 || get(handles.menuSim, 'Value') == 4 ...
        || get(handles.menuSim, 'Value') == 5 || get(handles.menuSim, 'Value') == 6
% for all the other point charge superposition simulations namely
% line of charge, square loop of charge, charge ring, charge disk
   
     if get(handles.menuSim, 'Value') ~= 6
         % if it is not the charge disk simulation then get the length and
         % charge per unit length
        L = str2num(get(handles.editText1, 'String'));
        lambda = str2num(get(handles.editText2, 'String'));
       
        % as explained above - check to see the inputs are numeric
        if isempty(L) || isempty(lambda) 
            warndlg('Input parameters must be numeric! Using default values');
            L = 10;
            lambda = 10;
        end
        
        % input validation
        if abs(L) > 30 || abs(lambda) > 100
            warndlg('Input data out of range. Using L = 10  = 10C instead.');
            % set default data
            L = 10;
            lambda = 10;
        end
        % Calculate the total charge from the length and charge density
        totalCharge = lambda*L;
     else

        % for the charge disk simulatin get the radius and charge density
        R = str2num(get(handles.editText1, 'String'));
        sigma = str2num(get(handles.editText2, 'String'));
        
        % as explained above - check to see the inputs are numeric
        if isempty(R) || isempty(sigma) 
            warndlg('Input parameters must be numeric! Using default values');
            R = 10;
            sigma = 10;
        end

       % input validation
        if abs(R) > 10 || abs(sigma) > 100
            warndlg('Input data out of range. Using R = 10  sigma = 10C instead.');
            % set default data
            R = 10;
            sigma = 10;
        end
        % calculate the total charge on the disk by multiplying the area by
        % the density
        totalCharge = pi*R^2*sigma;
     end
     
     if get(handles.menuSim, 'Value') == 2
        % for the line of charge simulation 
        % approximate the line by 300 point charges
        numCharges = 300;
        % create the line along the x axis and set y and z values to zero
        x = -(L/2):(L/numCharges):(L/2);
        y = zeros(1, length(x));
        z = zeros(1, length(x));
        % calculate the charge on each point charge (uniform)
        q = ones(1, length(x))*((totalCharge)/numCharges);
        % define the new line for the user input listbox
        newLine = sprintf('Line Charge Length = %0.2f m Lambda = %0.2f C/m',...
                L, lambda);
     end
   
    if get(handles.menuSim, 'Value') == 4
       % For the square loop of charge construct the square from 4 lines
       
       % have 100 charges on each side of the square
      numCharges = 100;
      
      % the leftmost side of the square
      y1 = -(L/2):(L/numCharges):(L/2); 
      x1 = ones(1, length(y1))*-(L/2);
      
      % top side of the square
      x2 = y1;
      y2 = ones(1, length(y1))*(L/2);
      
      % right hand side of the square
      x3 = y2;
      y3 = y1;
      
      % bottom side of the square
      x4 = y1;
      y4 = x1;
      
      % set the square on the xy plane by putting z to 0
      z = zeros(1, length(y1)*4);
      
      % add all the x points together into a single vector
      x = horzcat(x1, x2, x3, x4);
      % similarly for y
      y = horzcat(y1, y2, y3, y4);
      
      % calculate the charge of each point charge from the density
      q = ones(1, length(x))*((totalCharge)/numCharges);
      % define line for the input listbox
      newLine = sprintf('Length of Side = %0.2f m Lambda = %0.2f C/m',...
                L, lambda);
    end
    
    if get(handles.menuSim, 'Value') == 5
        % for the ring of charge simulation
        % calculate the total charge
        totalCharge = lambda*(2*pi*L);
        numCharges = 500;
        % draw a cricle with radius L
        t = 0:(2*pi)/numCharges:2*pi;
        x = L*cos(t);
        y = L*sin(t);
        % set it on the xy plane (z=0)
        z = zeros(1, length(x));
        % calculate the charge of each point charge
        q = ones(1, length(x))*((totalCharge)/numCharges);
        % define line for the input listbox
        newLine = sprintf('Radius = %0.2f m Lambda = %0.2f C/m',...
                L, lambda);
    end
    
    if get(handles.menuSim, 'Value') == 6
       % for the charge disk simulation
       x = [];
       y = [];
       % build the disk up by adding together multiple rings
       numCharges = 100; % per ring
       t = 0:(2*pi)/numCharges:2*pi;
       % for each ring
       for i = 0.1:R/20:R;
           % Draw a circle at some radius i
          xi = i*cos(t);
          yi = i*sin(t);
          % append the data to the x and y vectors
          x = horzcat(x, xi);
          y = horzcat(y, yi);
       end
       % set it on the xy plane
       z = zeros(1, length(x));
       % find the charge of each point charge
       q = ones(1, length(x))*((totalCharge)/numCharges);
          % define line for the input listbox
       newLine = sprintf('Radius = %0.2f m Sigma = %0.2f C/m',...
                R, sigma);
    end
   
    % for all of the simulations we can add the resulting x, y, z, q data
    % into the handles structure for plotting purposes later
    handles.xData = x;
    handles.yData = y;
    handles.zData = z;
    handles.qData = q;      
    % add the new line to the list box
    set(handles.listboxInputs, 'String', newLine); 
end
 

if get(handles.menuSim, 'Value') == 3;
    % Field from potential
   
    % get the equation from the text box and upload it to handles
    handles.VData = get(handles.editTextEquation, 'String');
    % set the next line on the listbox
    newLine = sprintf('Potential V(x,y) = %s', handles.VData);
    set(handles.listboxInputs, 'String', newLine);
end


if get(handles.menuSim, 'Value') == 7
    % for the straight wire simulation
    
    % get the length and the current data
    L = str2num(get(handles.editText1, 'String'));
    handles.Current = str2num(get(handles.editText2, 'String'));
    
    % as explained above, check to see data is numeric
    if isempty(L) || isempty(handles.Current) 
            warndlg('Input parameters must be numeric! Using default values');
            L = 10;
            handles.Current = 1;
    end
    
   % perform input valdiation
   if abs(L) > 25 || abs(handles.Current) > 100
      warndlg('Input data out of range. Using L = 10m I = 1A instead.');
      % set the default data
      L = 10;
      handles.Current = 1;
   end
    
   % draw a wire along the y axis with 200 current elements
    NumElements = 200;
    handles.yData = -(L/2):L/NumElements:(L/2);
    handles.xData = zeros(1, length(handles.yData));
    handles.zData = handles.xData;

    % define a new line and set it on the list box
    newLine = sprintf('Length  = %0.2f m Current I = %0.2f A', L, handles.Current);
    set(handles.listboxInputs, 'String', newLine);

end



if get(handles.menuSim, 'Value') == 8
    % solenoid simulation
    
    % get the input parameters
    handles.NumTurns = str2num(get(handles.editText1, 'String'));
    handles.Current = str2num(get(handles.editText2, 'String'));
    handles.Radius = str2num(get(handles.editText3, 'String'));
    
        % as explained above, check to see data is numeric
    if isempty(handles.NumTurns) || isempty(handles.Current) || isempty(handles.Radius)
            warndlg('Input parameters must be numeric! Using default values');
            handles.NumTurns = 20;
            handles.Current = 1;
            handles.Radius = 1;
    end
    
    % input validation
    if abs(handles.NumTurns) > 100 || abs(handles.Current) > 100 || ...
            abs(handles.Radius) > 25
        warndlg('Input data out of range. Using 20 turns, I = 1A, R = 1m instead.');
        % set default data
        handles.NumTurns = 20;
        handles.Current = 1;
        handles.Radius = 1;
    end
    
    % set the step size and draw a helix to represent the solenoid
    dt = 0.2;
    t = 0:dt:handles.NumTurns*2*pi;
    handles.xData = handles.Radius*cos(t);
    handles.yData = handles.Radius*sin(t);
    % scale the height
    handles.zData = t./100;

    %  add the new line to the list box
    newLine = sprintf('N  = %d m Current I = %0.2f A Radius = %0.2f m', handles.NumTurns,...
        handles.Current, handles.Radius);
    set(handles.listboxInputs, 'String', newLine);

end



if get(handles.menuSim, 'Value') == 9
    % for magnetic dipoles simulation
    
    % get the positon and magentic moment of the dipole
    x = str2num(get(handles.editText1, 'String'));
    y = str2num(get(handles.editText2, 'String'));
    z = str2num(get(handles.editText3, 'String'));
    m = str2num(get(handles.editText4, 'String'));

    % perform input valiation similar to point charges
    if abs(x) > 100 || abs(y) > 100 ||  abs(z) > 100 || abs(m) > 100
         warndlg('Input data out of range. Using r = (0, 0, 0) m = 1 J/T instead.');
         % set default data
         x = 0;
         y = 0;
         z = 0;
         m = 1;
    end
    
    % add this dipole to the current dipoles. remember there can be
    % multiple dipoles added at once (like point charges) so we append the
    % data to handles
    handles.xData(end+1) = x;
    handles.yData(end+1) = y;
    handles.zData(end+1) = z;
    handles.mData(end+1) = m;
    
    
    % if non-numeric data is entered then str2num will return [], so we
    % check to see if any of the parameters are empty and if so throw error
    if isempty(x) || isempty(y) || isempty(z) || isempty(m)
        warndlg('Input parameters must be numeric! Using default values');
        x = 0;
        y = 0;
        z = 0;
        m = 1;
    end
    
    % find the previous string on the list box
    previousString = cellstr(get(handles.listboxInputs, 'String'));
    % create a new line to be added for this particular dipole
    newLine = sprintf('Position = (%0.2f, %0.2f, %0.2f) m = %0.2f J/T',...
                        x, y, z, m);
                    
    if strcmp(previousString, '');
        % if the list box is empty then add our string to the top
        set(handles.listboxInputs, 'String', newLine);
    else
        % otherwise append our string to the list
        newString = [previousString;{newLine}];
        set(handles.listboxInputs, 'String', newString);
    end
        
end


if get(handles.menuSim, 'Value') == 10
    % for bar magnet simulation
    
    % get the length of the magnet and the magnetization
    L = str2num(get(handles.editText1, 'String'));
    M = str2num(get(handles.editText2, 'String'));
    
   % if non-numeric data is entered then str2num will return [], so we
    % check to see if any of the parameters are empty and if so throw error
    if isempty(L) || isempty(M) 
        warndlg('Input parameters must be numeric! Using default values');
        L = 5;
        M = 10;
    end
    
   % perform input valdiation
   if abs(L) > 25 || abs(M) > 100
       warndlg('Input data out of range. Using L = 5 M = 10 J/T/m^3 instead.');
        % set the default values
        L = 5;
        M = 10;
   end
   
    % create the magent along a line in the x axis
    handles.xData = -(L/2):0.5:L/2;
    handles.yData = zeros(1, length(handles.xData));
    handles.zData = handles.yData;
    % calculate the magnetic moment of each dipole using M
    handles.mData= ones(1, length(handles.xData))*(M*L);
 
    % write a new string for the list box and add it, removing any previous
    % 
    newLine = sprintf('Length = %0.2f Magnetization M = %0.2f J/T/m',...
                        L, M);          
    set(handles.listboxInputs, 'String', newLine);
        
end


if get(handles.menuSim, 'Value') == 11
    % for motion of particle in EM field simultion 
    % the inputs for this must be in the correct format, further input
    % validation to ensure this could be added in the future
    
    % get the input parameters
    % electric field
    E = str2num(cell2mat(strsplit(get(handles.editText1,'String'), ',')));
    % magnetic field
    B = str2num(cell2mat(strsplit(get(handles.editText2,'String'), ',')));
    % initial velocity
    v0 = str2num(cell2mat(strsplit(get(handles.editText3,'String'), ',')));
    % initial position
    p0 = str2num(cell2mat(strsplit(get(handles.editText4,'String'), ',')));
    % charge-mass ratio
    q_m = str2num(get(handles.editText5, 'String'));
    
    % if non-numeric data is entered then str2num will return [], so we
    % check to see if any of the parameters are empty and if so throw error
    if isempty(E) || isempty(B) || isempty(v0) || isempty(p0) || isempty(q_m)
        warndlg('Input parameters must be numeric! Using default values');
        % set default values
         E = [1, 0, 0];
         B = [0, 0, 1];
         v0 = [0, 0, 0];
         p0 = [0, 0, 0];
         q_m = 1;
    end
    
    % input validation for charge mass ratio
    if q_m == 0 
         warndlg('Warning! q:m ratio cannot be zero, setting it to 1.');
         % set default value to 1
        q_m = 1;
    end
    
    % input validation for everything else. If bad input data is given then
    % it make take years for the particle to move any considerable amount
    % so the user must be very careful to have the correct order of
    % magnetidue on the data. To simplify things we just restrict the user
    % inputs to a small range so they can get an idea of the trajectory. I
    % mainly did this becaue the marker is unlikely to have a good idea of
    % the necessary input data and may accidently crash the system. In the 
    % future this could easily by changed
    if sum(abs(E)>10) ~= 0 || sum(abs(B)>10) ~= 0 || sum(abs(v0)>10) ~= 0 ...
            || sum(abs(p0)>10) ~= 0 || abs(q_m) > 5
         warndlg('Bad Input Data, using default data');
         % set default values
         E = [1, 0, 0];
         B = [0, 0, 1];
         v0 = [0, 0, 0];
         p0 = [0, 0, 0];
         q_m = 1;
    end
    % create the new line for the input box
    try 
        % attempt to write the data to the list box this may throw an error
        % if the data is not given in the correct format so as a method of
        % crude input validation we put it in a try/catch so if anything
        % goes wrong then it will not crash but use the default values
        % instead
        newLine = sprintf('E=(%0.2f, %0.2f, %0.2f), B=(%0.2f, %0.2f, %0.2f), V0 = (%0.2f, %0.2f, %0.2f), P0 = (%0.2f, %0.2f, %0.2f), q/m = %0.2f',...
        E(1), E(2), E(3), B(1), B(2), B(3), v0(1), v0(2), v0(3), p0(1), p0(2), p0(3), q_m);
    catch
        % if for any reason the new line did not execute correctly we use
        % default values, this could be for incorrectly formatted input
         warndlg('Bad input data, using default values!')
         % default values
         E = [1, 0, 0];
         B = [0, 0, 1];
         v0 = [0, 0, 0];
         p0 = [0, 0, 0];
         q_m = 1;
         % add the default values information to the list box
         newLine = sprintf('E=(%0.2f, %0.2f, %0.2f), B=(%0.2f, %0.2f, %0.2f), V0 = (%0.2f, %0.2f, %0.2f), P0 = (%0.2f, %0.2f, %0.2f), q/m = %0.2f',...
         E(1), E(2), E(3), B(1), B(2), B(3), v0(1), v0(2), v0(3), p0(1), p0(2), p0(3), q_m);
    end
    
    % add the new line
    set(handles.listboxInputs, 'String', newLine);
    
    % upload the data to handles and note that we take the transpose
    % the reason for this is for solving the ODE later in the program
    handles.E = E'; 
    handles.B = B';
    handles.v0 = v0';
    handles.p0 = p0';
    handles.q_m = q_m;  
end

guidata(hObject, handles);

%=========================================================================
%                           Pick Plotting Function
%=========================================================================

% --- Executes on button press in buttonPlot.
function buttonPlot_Callback(hObject, eventdata, handles)
% hObject    handle to buttonPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Functions executes when user presses plot button on the graph. The
% only purpose of this function is to select the correct plotting function

% clear the plot and reset it to its default values
cla;
reset(gca);
reset(gcf);
% you need to redefine the ButtonDownFcn after reseting the plot!
set(gca, 'ButtonDownFcn', ...
    @(hObject,eventdata)EM('plot_ButtonDownFcn',hObject,eventdata,guidata(hObject)));


% choose which plot function to use depending on the simulation selected
switch get(handles.menuSim, 'Value')
    case 1
        % Electric point charges
        plot_pointCharges(hObject, eventdata, handles);
    case 2
        % Line of Charges
        plot_pointCharges(hObject, eventdata, handles);
    case 3
        % Field from Potential
        plot_EfromV(hObject, eventdata, handles);
    case 4
        % Square loop of charges
        plot_pointCharges(hObject, eventdata, handles);
    case 5
        % Ring of Charge
        plot_pointCharges(hObject, eventdata, handles);
    case 6
        % Charged Disk
        plot_pointCharges(hObject, eventdata, handles);
    case 7
        % Current-Carrying Wire
        plot_biotSavart(hObject, eventdata, handles);
    case 8 
        % Solenoid
        plot_biotSavart(hObject, eventdata, handles);
    case 9 
        % Individual magnetic dipoles
        plot_dipoles(hObject, eventdata, handles);
    case 10
        % Bar magnet
        plot_dipoles(hObject, eventdata, handles);
    case 11
        % Particle motion in EM Fields
        plot_motion(hObject, eventdata, handles);
end    

guidata(hObject, handles);

%=========================================================================
%                           Clear Functions
%=========================================================================
% --- Executes on button press in buttonClearPlot.
function buttonClearPlot_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClearPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear the current plot
cla;

% --- Executes on button press in buttonClearInput.
function buttonClearInput_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClearInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% function clears the user input boxes and removes all current plot data
% from the handles data structure

% clear the user input boxes and the input list box
set(handles.editText1, 'String', '');
set(handles.editText2, 'String', '');
set(handles.editText3, 'String', '');
set(handles.editText4, 'String', '');
set(handles.editText5, 'String', '');
set(handles.editTextEquation, 'String', '');
set(handles.listboxInputs, 'String', '');

% clear all plotting data from the handles data structure
handles.xData = []; % clear any x points (point charges)
handles.yData = [];% clear any y points (point charges)
handles.zData = [];% clear any z points (point charges)
handles.qData = [];% clear any charge information
handles.VData = [];% clear any V(x,y) equations
handles.E = []; % clear E field (motion sim)
handles.B = []; % clear B field (motion sim)
handles.Length = []; % clear length data 
handles.Current = []; % clear current data
handles.NumTurns = []; % clear number turns data
handles.mData = []; % clear magnetic moment data

% update handles
guidata(hObject, handles);

%=========================================================================
%                     Adjust GUI For Each Graph Type
%=========================================================================

% --- Executes on selection change in menuGraphs.
function menuGraphs_Callback(hObject, eventdata, handles)
% hObject    handle to menuGraphs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% When the user selects a plot we need to set which plot options should be
% available and what the default settings should be. e.g. for a contour
% plot we set it to 2D and disable changing the dimension

% First enable everything and set back to their default values
set(handles.radio2D, 'enable', 'on'); % selects 2D plot
set(handles.radio3D, 'enable', 'on'); % selects 3D plot
set(handles.checkNormalize, 'enable', 'on'); % normalizes the plot
set(handles.checkContours, 'enable', 'on'); % adds contorus to the plot
set(handles.radio2D, 'Value', 1); % set defualt dimension to 2
set(handles.checkContours, 'Value', 0); % turn off contours by default
set(handles.checkNormalize, 'Value', 0); % turn off normalize by default


if get(handles.menuSim, 'Value') == 1 || get(handles.menuSim, 'Value') == 2 ...
    || get(handles.menuSim, 'Value') == 4 || get(handles.menuSim, 'Value') == 5 ...
    || get(handles.menuSim, 'Value') == 6 || get(handles.menuSim, 'Value') == 9 ...
    || get(handles.menuSim, 'Value') == 10
    % for all simulations except: wire, solenoid and E from V

    if get(hObject, 'Value') == 2
        % if its a streamline plot then turn off 3D and normalize options
        set(handles.radio3D, 'enable', 'off');
        set(handles.checkNormalize, 'enable', 'off');
    end

    if get(hObject, 'Value') == 3
        % if its a contour plots then disable 3D and normalize 
        set(handles.checkNormalize, 'enable', 'off');
        set(handles.radio3D, 'enable', 'off')
        set(handles.checkContours, 'Value', 1); 
        % ensure contours stay on
        set(handles.checkContours, 'enable', 'off');
    end
    
    if get(hObject, 'Value') == 4
        % if its a surface plot then hide 2D and normalize options
        set(handles.checkNormalize, 'enable', 'off');
        set(handles.radio2D, 'enable', 'off');
        set(handles.radio3D, 'Value', 1);
        % turn off the contours by default, can add if user wants (surfc)
        set(handles.checkContours, 'Value', 0);
    end
end

if get(handles.menuSim, 'Value') == 3
    % for the field from potential simulation
    
    if get(hObject, 'Value') == 1 || get(hObject, 'Value') == 2
        % if it is E quiver plot or V surface and E quiver plot
        % then ensure plot stays in 2D
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
        set(handles.radio2D, 'enable', 'off');
        set(handles.radio3D, 'enable', 'off');
    end
    
    if get(hObject, 'Value') == 3 
        % If it is the potential contour plot then ensure plot stays in 3D
        set(handles.radio2D, 'Value', 0);
        set(handles.radio3D, 'Value', 1);
        set(handles.radio2D, 'enable', 'off');
        set(handles.radio3D, 'enable', 'off');
        % turn off contours and normalize options
        set(handles.checkContours, 'enable', 'off');
        set(handles.checkNormalize, 'enable', 'off'); 
    end
end

if get(handles.menuSim, 'Value') == 7 || get(handles.menuSim, 'Value') == 8
    % for the solenoid and long-straight wire plots
    
    if get(hObject, 'Value') == 1 
        % for the quiver plot default to 3D and no contours/normalize
        set(handles.radio2D, 'Value', 0);
        set(handles.radio3D, 'Value', 1);
        set(handles.checkContours, 'Value', 0);
        set(handles.checkContours, 'enable', 'off');
        set(handles.checkNormalize, 'Value', 0);
    end
    
    if get(hObject, 'Value') == 2
        % for the field lines plot default to 2D and disable contours/norm
        set(handles.radio2D, 'Value', 1);
        set(handles.radio3D, 'Value', 0);
        set(handles.radio3D, 'enable', 'off');
        set(handles.checkContours, 'enable', 'off');
        set(handles.checkNormalize, 'enable', 'off');
    end
    
end

%=========================================================================
%                           Plotting Functions
%=========================================================================

% In this section we have different plotting functions for different 
% simulations. The plotting data saved in the handles structure by the 
% buttonEnter function is used as arguments for function calls to the
% external functions that do the numerical integration and physics
% (dipoles3D, biotSavart2D etc). These functions are called by the
% buttonPlot function, which is triggered when the user presses 'Plot'

%=========================================================================
%          Plotting Function for Point Charges Based Simulations
%=========================================================================

function plot_pointCharges(hObject, eventdata, handles)
% This function calls the pointCharges2D and pointCharges3D functions to
% calculate and plot the fields for the simulations that are based on the
% superposition of electric point charges (i.e. sims 1,2,4,5,6)
   
% get the position of the point charges from handles
x = handles.xData;
y = handles.yData;
z = handles.zData;
% get the charge data of point charges from handles
q = handles.qData;
    
   
switch get(handles.menuSim, 'Value')
    % find the relative permittivity depending on the simulation. different
    % simulations have a different input box to find it
    case 1
        % point charge simulation
        epsR = str2num(get(handles.editText4, 'String'));
    case 2
        % line of charge
        epsR = str2num(get(handles.editText3, 'String'));
    case 4
        % ring of charge
        epsR = str2num(get(handles.editText3, 'String'));
    case 5
        % charge disk
        epsR = str2num(get(handles.editText3, 'String'));
    otherwise
        % default value
        epsR = 1;
end

% default to 1 if a bad value is used  
if isempty(epsR) || epsR < 1
    if strcmp(get(handles.editText1, 'enable'),'off')
        warndlg('Select a simulation from the first pop-up menu');
    else
      warndlg('Bad relative permittivity value, defaulting to vacuum');
    end
    epsR = 1; % set er to 1 for a vacuum
end

% Find the field everywhere in 2D
[X, Y, Ex, Ey, E] = pointCharges2D(x, y, q, epsR);
% Calculate the magnitude everywhere for normalization purposes
M = (Ex.^2 + Ey.^2).^(1/2);

% Find which graph is selected to pick which graph to plot
switch get(handles.menuGraphs, 'Value')
    
    % QUIVER PLOT
    case 1 
        
        if get(handles.radio2D, 'Value') == 1
            % if the 2D check box is ticked
            hold on
            if get(handles.checkNormalize, 'Value') == 1
                %scale the values so the direction is more visible
                handles.plot = quiver(X, Y, Ex./M, Ey./M);
            else
                %otherwise just plot the normal values
                handles.plot = quiver(X, Y, Ex, Ey);
            end
            set(handles.plot, 'LineWidth', 2);
            % Plot points where the point charges are
            for i = 1:length(handles.qData)
                if handles.qData(i) > 0 
                    % plot a red dot for a positive charge
                    handles.plot = plot(handles.xData(i), ...
                         handles.yData(i), '.r', 'MarkerSize', 35);
                else
                    % plot a blue dot for a negative charge
                    handles.plot = plot(handles.xData(i), ...
                        handles.yData(i), '.k', 'MarkerSize', 35);
                end
            end
            % default 2 dimensional view
            view(2); 
            hold off
        else 
            % Otherwise if the the 3D check box is ticked calculate the
            % field everywhere in 3D and find the normalization factor
            [X, Y, Z, Ex, Ey, Ez, E] = pointCharges3D(x, y, z, q, epsR);
            M = (Ex.^2 + Ey.^2 + Ez.^2).^(1/2);
            hold on
            % check to see if the normalization option is selected
            if get(handles.checkNormalize, 'Value') == 1
                % plot the normalized field
                 handles.plot = quiver3(X, Y, Z, Ex./M, Ey./M, Ez./M);
            else
                % plot the original field 
                handles.plot = quiver3(X, Y, Z, Ex, Ey, Ez);           
            end
            set(handles.plot, 'LineWidth', 2);
            % as before overlay the plot with dots where the point charges
            % are
            for i = 1:length(handles.qData)
                if handles.qData(i) > 0 
                    % red dot for a positive charge
                    handles.plot = plot3(handles.xData(i), ...
                         handles.yData(i), handles.zData(i), '.r', 'MarkerSize', 35);
                else
                    % blue dot for a negative charge
                    handles.plot = plot3(handles.xData(i), ...
                        handles.yData(i), handles.zData(i), '.k', 'MarkerSize', 35);
                end
            end
            view(3) % default 3 dimensional view
            hold off
        end 

    % STREAM LINE PLOT (FIELD LINES)
    case 2
       
       % check to see that the 2D option is selected
       if get(handles.radio2D, 'Value') == 1
           hold on
           % check to see if normalization is selected
           if get(handles.checkNormalize, 'Value') == 1
               % plot normalized field
               handles.plot = streamslice(X, Y, Ex./M, Ey./M, 0.5);
           else               
                %otherwise just plot the normal values
                handles.plot = streamslice(X, Y, Ex, Ey, 0.5);
           end
           % as above - plot the point charges
           for i = 1:length(handles.qData)
                if handles.qData(i) > 0 
                    handles.plot = plot(handles.xData(i), ...
                         handles.yData(i), '.r', 'MarkerSize', 35);
                else
                    handles.plot = plot(handles.xData(i), ...
                        handles.yData(i), '.k', 'MarkerSize', 35);
                end
           end
           view(2);
           hold off;
       end

    % CONTOUR PLOT
    case 3 
        
        % check to see if 2D option is selected
        if get(handles.radio2D, 'Value') == 1
            hold on
            % draw a contour plot of the total electric field
            handles.plot = contour(X, Y, E, 300);
            % add a colorbar for clarity
            colorbar('location','eastoutside','fontsize',12);
            % draw the position of the point charges as before
            for i = 1:length(handles.qData)
                if handles.qData(i) > 0 
                    handles.plot = plot(handles.xData(i), ...
                         handles.yData(i), '.r', 'MarkerSize', 35);
                else
                    handles.plot = plot(handles.xData(i), ...
                        handles.yData(i), '.k', 'MarkerSize', 35);
                end
            end
            % set the view to 2D
            view(2);
            hold off
        end

    % SURFACE PLOT
    case 4
         colorbar('location','eastoutside','fontsize',12);
         if get(handles.checkContours, 'Value') == 0
            % if no contours then draw a normal surf plot 
            handles.plot = surf(X, Y, E);
         else
             % include contours
            handles.plot = surfc(X, Y, E);
         end
         view(3);
         % nice shading
         shading interp
end % end switch

% Edit plot properties
% axis labels
xl = xlabel('X');
yl = ylabel('Y');
zl = zlabel('Z');
set([xl, yl, zl], 'FontSize', 14);
% properties
grid on;
box on;
axis tight;
% get simulation name
list = get(handles.menuSim, 'String');
% create title from sim name
str = sprintf('Electric Field from %s', list{get(handles.menuSim, 'Value')});
t = title(str);
% adjust font sizes and types
set(t, 'FontSize', 16);
set(t, 'FontName', 'Arial');
set(gca, 'FontSize', 14);
% update handles
guidata(hObject, handles);

%=========================================================================
%       Plotting Function for E (Field) from V (Potential) Simulation
%=========================================================================
 
function plot_EfromV(hObject, eventdata, handles)
% Function calls the external fieldFromPotential function in order to plot
% the field

% get the potential function
V = handles.VData;

try 
    % attempt to get the field data
    [X, Y, Ex, Ey, E, Vplot] = fieldFromPotential(V);
catch 
    % if the function returns early because of any error then use default V
    % this is quite crude error handling but for the purposes of the
    % project i think it is ok and it covers many faults
    warndlg('Invalid potential function. Using default V(x, y) = x');
    [X, Y, Ex, Ey, E, Vplot] = fieldFromPotential('x');
    % set the default data
    set(0,'CurrentFigure',handles.figure1);
    set(handles.figure1,'CurrentAxes',handles.plot);
    newLine = 'Potential V(x,y) = x';
    set(handles.listboxInputs, 'String', newLine);
    set(handles.editTextEquation, 'String', 'x');
    handles.VData = 'x';
end
 M = (Ex.^2 + Ey.^2).^(1/2);
 
 % Take the real components of the fields
 Ex = real(Ex);
 Ey = real(Ey);
 E = real(E);
 Vplot = real(Vplot);
 
switch get(handles.menuGraphs, 'Value')
    case 1 
        % Quiver Plot Field only  
        if get(handles.checkNormalize, 'Value') == 1
            % plot the normalized field
            handles.plot = quiver(X, Y, Ex./M, Ey./M);
        else
            %otherwise just plot the normal values
            handles.plot = quiver(X, Y, Ex, Ey);
        end
        % add axis label and title
        xl = xlabel('X');
        yl = ylabel('Y');
        zl = zlabel('Potential (V)');
        str = sprintf('Electric Field from V(x,y) = %s', get(handles.editTextEquation, 'String'));
        t = title(str);
        % set the default view to 2D
        view(2);
    case 2 
        % Potential Contour + Field Plot
        % draw potential contour plot
        handles.plot = contour(X, Y, Vplot);
        hold on 
        % draw the E vector field
        if get(handles.checkNormalize, 'Value') == 1
            % plto the normalized field
             handles.plot = quiver(X, Y, Ex./M, Ey./M);
        else
            %otherwise just plot the normal values
          handles.plot = quiver(X, Y, Ex, Ey);
        end
        colorbar('location','eastoutside','fontsize',12);
        % add axis label and title
        xl = xlabel('X');
        yl = ylabel('Y');
        zl = zlabel('Potential (V)');
        str = sprintf('Electric Potential Contours and Electric Field Arrows');
        t = title(str);
        view(2);
        hold off;
    case 3
        % Potential surface clot with contours
        handles.plot = surfc(X, Y, Vplot);
        % set axis limits
        axis([-5 5 -5 5]);
        % add axis labels and title
        xl = xlabel('X');
        yl = ylabel('Y');
        zl = zlabel('Potential (V)');
        str = sprintf('Electric Potential Surface Plot V(x,y) = %s', get(handles.editTextEquation, 'String'));
        t = title(str);
        view(3);
end

% edit plot properties
grid on;
box on;
axis tight;
% title and axis font type and sizes
set(t, 'FontSize', 16);
set(t, 'FontName', 'Arial');
set(gca, 'FontSize', 14);
set([xl, yl, zl], 'FontSize', 14);
guidata(hObject, handles);
 
%=========================================================================
%       Plotting Function for B field Simulations (Biot Savart Law)
%=========================================================================

function plot_biotSavart(hObject, eventdata, handles)
% plots the data for simulations that use the biot savart law to find the
% magnetic field. The function calls the biotSavart2D and biotSavart3D
% functions to do the physics and then plots the results

% get the positions of the wire and the current values
x = handles.xData;
y = handles.yData;
z = handles.zData;
I = handles.Current;
% given the current distribution find the magnetic field everywhere in 2D
[X, Z, Bx, Bz, B] = biotSavart2D(x, y, z, I);
% pick which graph to plot
switch get(handles.menuGraphs, 'Value') 
    % QUIVER PLOT
    case 1
        if get(handles.radio2D, 'Value') == 1
            %2D plot
            if get(handles.checkNormalize, 'Value') == 1
                handles.plot = quiver(X, Z, Bx./B, Bz./B);
            else
                %otherwise just plot the normal values
                handles.plot = quiver(X, Z, Bx, Bz);
            end
            view(2);
         
        else
          % 3D plot
          % if it is the straight current carrying wire simulation
          if get(handles.menuSim, 'Value') == 7
           % convert the wire into 3 dimensions. the wire is originally
           % along y, we convert it to along x axis
           x = y; 
           y = zeros(1, length(x));
           z = y;
          end
          % get the magnetic field in 3 dimensions
          [X, Y, Z, Bx, By, Bz, B] = biotSavart3D(x, y, z, I);
           
          hold on;

          if get(handles.checkNormalize, 'Value') == 1
              % plot the normalized vector field
             handles.plot = quiver3(X, Y, Z, Bx./B, By./B, Bz./B);
          else
              % plot the original vector field
            handles.plot = quiver3(X, Y, Z, Bx, By, Bz);           
          end
          % plot the wire
          wire = plot3(x, y, z);

          if get(handles.menuSim, 'Value') == 7
            % make the wire appear thick
            set(wire, 'LineWidth', 10);
          end 
          hold off
          % set the view to 3D
          view(3);
        end
    % STREAMSLICE PLOT (Field Lines)
    case 2 
        if get(handles.radio2D, 'Value') == 1
            if get(handles.checkNormalize, 'Value') == 1
                % if normalize is selected then plot normalized field
                handles.plot = streamslice(X, Z, Bx./B, Bz./B, 0.5);
            else               
                %otherwise just plot the normal values
                handles.plot = streamslice(X, Z, Bx, Bz, 0.5);
            end
            view(2);   
        end
end

% Produce pleasing plot
% add axis lables and adjust font size
xl = xlabel('X');
yl = ylabel('Y');
zl = zlabel('Z');
set([xl, yl, zl], 'FontSize', 14);
% create a box and set the axis tight
grid on;
box on;
axis tight;
% get the simulation name
list = get(handles.menuSim, 'String');
% create the title
str = sprintf('Magnetic Field from %s', list{get(handles.menuSim, 'Value')});
t = title(str);
% adjust font settings
set(t, 'FontSize', 16);
set(t, 'FontName', 'Arial');
set(gca, 'FontSize', 14);   
% update handles
guidata(hObject, handles);

%=========================================================================
%                Plotting Function for Magnetic Dipoles
%=========================================================================

function plot_dipoles(hObject, eventdata, handles)
% function operates similar to the point charges simulation except that
% it calculates the magenetic field from a dipole using the dipoles2D and
% dipoles3D functions

% get the (x,y,z) position of the dipoles and their magnetic dipole moment
x = handles.xData;
y = handles.yData;
z = handles.zData;
m = handles.mData;

% get the field data in 2 dimensions
[X, Y, Bx, By, B] = dipoles2D(x, y, m);
% calculate the normalisation factor
M = (Bx.^2 + By.^2).^(1/2);

% plot the appropriate graph
switch get(handles.menuGraphs, 'Value')
    case 1
        % quiver plot
        if get(handles.radio2D, 'Value') == 1
            % if the 2D check box is ticked
            hold on        
            if get(handles.checkNormalize, 'Value') == 1
                %scale the values so the direction is more visible
                handles.plot = quiver(X, Y, Bx./M, By./M);
            else
                %otherwise just plot the normal values
                handles.plot = quiver(X, Y, Bx, By);
            end
            % overlay the plot with points representing where the dipoles
            % are positioned
            for i = 1:length(handles.xData)            
               % draw a red dot for the North part of the dipole
               handles.plot = plot(handles.xData(i), ...
                   handles.yData(i), '.r', 'MarkerSize', 35);
               % draw a blue dot for the South part of the dipole
               handles.plot = plot(handles.xData(i)-0.1, ...
                   handles.yData(i), '.b', 'MarkerSize', 35);
            end
            view(2); % default 2 dimensional view
            axis tight;
            hold off
        else 
            % Quiver 3D - if the 3D check box is ticked
            % get the field data in 3D
            [X, Y, Z, Bx, By, Bz, B] = dipoles3D(x, y, z, m);
            % calculate the normalisation factor
            M = (Bx.^2 + By.^2 + Bz.^2).^(1/2);
            hold on
             if get(handles.checkNormalize, 'Value') == 1
                %scale the values so the direction is more visible
                handles.plot = quiver3(X, Y, Z, Bx./M, By./M, Bz./M);
            else
                %otherwise just plot the normal values
                handles.plot = quiver3(X, Y, Z, Bx, By, Bz);
             end
            % as above overlay the dipole positions
             for i = 1:length(handles.xData)            
               % red for North
               handles.plot = plot(handles.xData(i), ...
                   handles.yData(i), '.r', 'MarkerSize', 35);
               % blue for South
               handles.plot = plot(handles.xData(i)-0.1, ...
                   handles.yData(i), '.b', 'MarkerSize', 35);
             end
            view(3) % default 3 dimensional view
            axis tight;
            hold off
        end 
  case 2
        % Field lines - Stream line plot
       if get(handles.radio2D, 'Value') == 1
           hold on
           % if 2D button is selected then plot the stream line
           if get(handles.checkNormalize, 'Value') == 1
               % plot the normalised values
               handles.plot = streamslice(X, Y, Bx./M, By./M, 0.5);
           else               
                %otherwise just plot the normal values
                handles.plot = streamslice(X, Y, Bx, By, 0.5);
           end
           % as before overlay the dipole positions
           for i = 1:length(handles.xData)         
               % red for North
               handles.plot = plot(handles.xData(i), ...
                   handles.yData(i), '.r', 'MarkerSize', 35);
               % blue for South
               handles.plot = plot(handles.xData(i)-0.1, ...
                   handles.yData(i), '.b', 'MarkerSize', 35);
           end
            view(2);
            hold off;
       end
  case 3 
        % Contour plot
        if get(handles.radio2D, 'Value') == 1
            hold on
            % draw a contour plot with the field magnitude
            handles.plot = contour(X, Y, B, 300);
            colorbar('location','eastoutside','fontsize',12);
            % as before overlay the dipole positions
            for i = 1:length(handles.mData)     
               % red for North 
               handles.plot = plot(handles.xData(i), ...
                   handles.yData(i), '.r', 'MarkerSize', 15);
               % blue for South
               handles.plot = plot(handles.xData(i)-0.1, ...
                   handles.yData(i)-0.1, '.b', 'MarkerSize', 15);
            end
            % default to 2D view
            view(2);
            hold off
            axis tight;                       
        end

 case 4 
        % surface plot
         colorbar('location','eastoutside','fontsize',12);
         % check to see if contours check box is selected
         if get(handles.checkContours, 'Value') == 0
            % if no contours then draw a normal surf plot
            handles.plot = surf(X, Y, B);
         else
             % otherwise add in the contour lines
            handles.plot = surfc(X, Y, B);
         end
         % default to 3D view
         view(3);
         axis tight;
end % end switch

% Plot properties
% add acis labels
xl = xlabel('X');
yl = ylabel('Y');
zl = zlabel('Z');
set([xl, yl, zl], 'FontSize', 14);
grid on;
box on;
% add title 
str = sprintf('Magnetic Dipole Field');
t = title(str);
% adjust font size and type
set(t, 'FontSize', 16);
set(t, 'FontName', 'Arial');
set(gca, 'FontSize', 14);
% update handles
guidata(hObject, handles);
 
%=========================================================================
%               Plotting Function for Motion in EM Fields
%=========================================================================

 function plot_motion(hObject, eventdata, handles)
% function solves the ODE produced by the Lorentz force to calculat the
% motions of a particle in uniform E and B fields. No external functions
% are used

% The plot will animate the path of the particle first so while that is
% happenning we disable all the user input controls
set(handles.buttonPlot, 'enable', 'off');
set(handles.buttonEnter, 'enable', 'off');
set(handles.checkNormalize, 'enable', 'off');
set(handles.checkContours, 'enable', 'off');
set(handles.editText1, 'enable', 'off');
set(handles.editText2, 'enable', 'off');
set(handles.editText3, 'enable', 'off');
set(handles.editText4, 'enable', 'off');
set(handles.editText5, 'enable', 'off');
set(handles.buttonClearInput, 'enable', 'off');
set(handles.menuSim, 'enable', 'off');
set(handles.buttonClearPlot, 'enable', 'off');
 
% get the plot properties ready
hold on
grid on;
box on; 
% default to a 2D view
view(2);
% set the time range for the simulation
tspan = [0, 70];
% definte the initial conditions from user inputs
r0 = [handles.p0; handles.v0];

% Anonymous function - easier than a separate function. The function
% represents the ma = q(E + (v x B)) Lorentz equation and solves for the
% position, velocity and acceleration in 3 dimensions
func = @(t, f) [f(4:6); handles.q_m*(cross(f(4:6),handles.B)+handles.E)];
% call to the ode
[t, f] = ode45(func, tspan, r0);

% Plot resu;ts

% Determine if motion is 1D, 2D or 3D
options=0;	% default is 3D plot
% we determine which plane(s) the motion of the particle lies on
if (max(f(:, 3))==min(f(:,3)))	&& (min(f(:, 2))==max(f(:,2)))
	options = 1;	% motion is 1D along x-direction only
end

if ((max(f(:,3))==min(f(:,3))) && (min(f(:, 1))==max(f(:,1))))
	options = 2;	% motion is 1D along y-direction only
end

if (min(f(:, 1))==max(f(:,1)))	&& (min(f(:, 2))==max(f(:,2)))
	options = 3;	% motion is 1D along z-direction only
end

if (min(f(:, 3))==max(f(:,3)))	&& (min(f(:, 2))~=max(f(:,2))) ...
        && (min(f(:, 1))~=max(f(:,1)))
	options = 4;	% motion is 2D in xy-plane		
end

if (min(f(:, 1))==max(f(:,1)))	&& (min(f(:, 2))~=max(f(:,2))) ...
        && (min(f(:, 3))~=max(f(:,3))) 
	options = 5;	% motion is 2D in yz-plane
end

if (min(f(:, 2))==max(f(:,2))) && (min(f(:, 1))~=max(f(:,1))) ...
        && (min(f(:, 3))~=max(f(:,3)))
	options = 6;	% motion is 2D in xz-plane
end

if (min(f(:,1))~=max(f(:,1))) && (min(f(:, 2))~=max(f(:,2))) ...
        && (min(f(:, 3))~=max(f(:,3)))
	options = 0;	% motion is 3D in xyz space
end

% we now plot the motion depending on the plane of the partile
switch options
	case 1
        % plot the x positon against time (1D)
        plot(t,f(:,1));				
		xlabel('time (s)');
		ylabel('X');
        
	case 2
        % plot the y position against time (1D)
		plot(t,f(:,2));
		xlabel('time (s)');
		ylabel('Y');
		
	case 3
        % plot the z position against time (1D)
		plot(t,f(:,3))					
		xlabel('time (s)');
		ylabel('Z');
		
	case 4
        % animate motion in the xy plane
		comet(f(:,1),f(:,2));					
        % once animated plot is finished draw a static plot
		plot(f(:,1),f(:,2));					
		xlabel('X'); 
        ylabel('Y');
        
	case 5
        % animate motion in the yz plane
		comet(f(:,2),f(:,3));
        % once animated plot is finished draw a static plot
		plot(f(:,2),f(:,3));				
		ylabel('Z'); 
        xlabel('Y');

	case 6
        % animate motion in the xz plane
		comet(f(:,1),f(:, 3))			
         % once animated plot is finished draw a static plot
		plot(f(:,1),f(:, 3));				
		xlabel('X'); 
        ylabel('Z');

	case 0
        % 3D plot so change the view 
        view(3);
        % animate motion in 3 dimensions
		comet3(f(:,1), f(:,2), f(:, 3));			
        % once animated plot is finished draw a static plot
		plot3(f(:,1),f(:,2),f(:,3));			
		xlabel('X');
        ylabel('Y'); 
        zlabel('Z');
end
% add title to the static plot 
t = title('Motion of Charged Particle in Electric and Magnetic Fields');
% adjust font sizes
set(t, 'FontSize', 16);
set(t, 'FontName', 'Arial');
set(gca, 'FontSize', 14);
hold off;
% enable all the controls that we originally disabled apart from the
% checkContours and checkNormalize options because they should never be
% available for the particle motion simulation
set(handles.buttonPlot, 'enable', 'on');
set(handles.buttonEnter, 'enable', 'on');
set(handles.editText1, 'enable', 'on');
set(handles.editText2, 'enable', 'on');
set(handles.editText3, 'enable', 'on');
set(handles.editText4, 'enable', 'on');
set(handles.editText5, 'enable', 'on');
set(handles.buttonClearPlot, 'enable', 'on');
set(handles.buttonClearInput, 'enable', 'on');
set(handles.menuSim, 'enable', 'on');
% update handles
guidata(hObject, handles);   

%=========================================================================
%                      Add Contours to Plots
%=========================================================================

% --- Executes on button press in checkContours.
function checkContours_Callback(hObject, eventdata, handles)
% hObject    handle to checkContours (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This function is called when the add contours button is pressed. Only
% some of the simulations will have this enabled. The function essentially
% replots the current data but overlays a contour plot

if get(hObject, 'Value') == 1
    % if add contours is selected
    % switch the plot to 2D as we have not included 3D contour plots
    set(handles.radio2D, 'Value', 1);
    set(handles.radio3D, 'Value', 0);
    % disable the 3D plot option
    set(handles.radio3D, 'enable', 'off');
    % for the point charges based simulations (point charges, line of
    % charge, square loop of charge, charge disk and ring of charge)
    if get(handles.menuSim, 'Value') == 1 || get(handles.menuSim, 'Value') == 2 ...
        || get(handles.menuSim, 'Value') == 4 || get(handles.menuSim, 'Value') == 5 ...
        || get(handles.menuSim, 'Value') == 6
    
        % if the Quiver plot or the Streamslice plot is selected then
        if get(handles.menuGraphs, 'Value') == 1 || ...
                get(handles.menuGraphs, 'Value') == 2 
            % get the current plotting data
            x = handles.xData;
            y = handles.yData;
            q = handles.qData;
            % set the relative permittivity as before
           switch get(handles.menuSim, 'Value')
             case 1
                 % for point charges plot
                epsR = str2num(get(handles.editText4, 'String'));
             case 2
                 % for line of charge plot
                epsR = str2num(get(handles.editText3, 'String'));
             otherwise
                epsR = 1;
            end

            if epsR < 1, epsR = 1; end;       
            % get the 2D plotting data
            [X, Y, Ex, Ey, E] = pointCharges2D(x, y, q, epsR);
            hold on
            % overlay whatever is currently plotted with a contour plot
            handles.plot = contour(X, Y, E, 100);
            colorbar('location','eastoutside','fontsize',12);          
            % change the view to 2D
            view(2);
            hold off
            axis tight; 
        end
     
        % if the surface plot is selected
        if get(handles.menuGraphs, 'Value') == 4
            % just replot the graph with the button ticked now and it will
            % chose surfc instead of surf in the plotting function
            buttonPlot_Callback(hObject, eventdata, handles)
        end
    end
    
    % if it is the field from potential simulation
    if get(handles.menuSim, 'Value') == 3

        if get(handles.menuGraphs, 'Value') == 1
            % if its the quiver plot then add contour field lines
                V = handles.VData;
                try 
                    % attempt to get the plotting data
                    [X, Y, Ex, Ey, E, Vplot] = fieldFromPotential(V);
                catch 
                    %if the function returns early because of any error then use default V
                    [X, Y, Ex, Ey, E, Vplot] = fieldFromPotential('x');
                    newLine = 'Potential V(x,y) = x';
                    set(handles.listboxInputs, 'String', newLine);
                end
                hold on;
                % overlay a contour plot
                handles.plot = contour(X, Y, E, 100);
                % add colorbar
                colorbar('location','eastoutside','fontsize',12);   
                % adjust plot settings
                view(2);
                hold off
                axis tight; 
        end
    end
    % for the straight current carrying wire or solenoid simultions
    if get(handles.menuSim, 'Value') == 7 || ... 
            get(handles.menuSim, 'Value') == 8
         if get(handles.menuGraphs, 'Value') == 1
            % if its the quiver plot then add contour field lines
            % get the current plotting data
            x = handles.xData;
            y = handles.yData;
            z = handles.zData;
            I = handles.Current;
            % get the field data
            [X, Z, Bx, Bz, B] = biotSavart2D(x, y, z, I);
            hold on;
            % overlay the contour plot
            handles.plot = contour(X, Z, B, 100);
            colorbar('location','eastoutside','fontsize',12);     
            % adjust plot settings
            view(2);
            hold off
            axis tight; 
         end
    end
    
    % if it is the bar magnet of magnetic dipole simultion
    if get(handles.menuSim, 'Value') == 9 || ... 
            get(handles.menuSim, 'Value') == 10
        % if it is the quiver plot or the stream line plot
        if get(handles.menuGraphs, 'Value') == 1 || ...
                get(handles.menuGraphs, 'Value') == 2
            % get the current plotting data
            x = handles.xData;
            y = handles.yData;
            m = handles.mData;   
            % calculate the field in 2D
            [X, Y, Bx, By, B] = dipoles2D(x, y, m);
            hold on
            % add the contour plot
            handles.plot = contour(X, Y, B, 200);
            colorbar('location','eastoutside','fontsize',12);          
            view(2);
            hold off
            axis tight; 
        end
    
    end
else 
    % if you unclick the contours option then just replot what you had
    set(handles.radio3D, 'enable', 'on');
    buttonPlot_Callback(hObject, eventdata, handles)
    % turn off the color bar
    colorbar('off')
end

%=========================================================================
%                           Normalize Plots
%=========================================================================

% --- Executes on button press in checkNormalize.
function checkNormalize_Callback(hObject, eventdata, handles)
% hObject    handle to checkNormalize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% function allows the user to normalize the plots. It simply recalls the
% appropriate plotting function which will plot the normalized data instead
% of the original data

if get(hObject, 'Value') == 1
    % if normalized is selected then replot the data
    buttonPlot_Callback(hObject, eventdata, handles)
else 
    % otherwise re-enable the contour plo
    set(handles.checkContours, 'enable', 'on');
    buttonPlot_Callback(hObject, eventdata, handles)
end

  
%=========================================================================
%                           Mouse Press Events
%=========================================================================

% --- Executes on mouse press over axes background.
function plot_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% For the point charge simulation only the function allows the user to
% place point charges into the plot by clicking on the appropriate position
% get current plot position. It works for 2D and 3D but it makes much more
% sense in 2D since you cannot really determine a 3D position on a 2D
% screen
pos = get(hObject, 'CurrentPoint');
% determine if right or left click
click = get(handles.figure1, 'selectiontype');

if get(handles.menuSim, 'Value') == 1
    % for point charges simultion only
    % extract the x and y coordinate
    x = pos(1,1);
    y = pos(1,2);
    % just set it on the xy plane
    z = 0;
    % get the charge from the input box
    q = str2num(get(handles.editText5, 'String'));
    % if no specified charge is given
    if isempty(q)
        % if its a left click then set charge to 1
        if strcmp(click, 'normal')
            q = 1;
        else 
            % if its a right click then set charge to -1
            q = -1;
        end
    end
    % add the point charge to the current plotting data
    handles.xData(end+1) = x;
    handles.yData(end+1) = y;
    handles.zData(end+1) = z;
    handles.qData(end+1) = q;
    % find the previous text on the input listbox
    previousString = cellstr(get(handles.listboxInputs, 'String'));
    % create a new line of text for this point charge
    newLine = sprintf('Position = (%0.2f, %0.2f, %0.2f) q = %0.2f C',...
                        x, y, z, q);
    % add the new string to the list box                
    if strcmp(previousString, '');
        % add it to the top
        set(handles.listboxInputs, 'String', newLine);
    else
        % append to the end of the list
        newString = [previousString;{newLine}];
        set(handles.listboxInputs, 'String', newString);
    end 
end
% update handles
guidata(hObject, handles);
% plot the new point charge
buttonPlot_Callback(hObject, eventdata, handles);

%=========================================================================
%                           Additional Functions
%=========================================================================

% sometimes experienced strange behaviour running program on different
% systems when i removed these functions and deleted their link in the GUI
% so for stability I will leave them here not implmented

% --- Outputs from this function are returned to the command line.
function varargout = EM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
  
% --- Executes during object creation, after setting all properties.
function menuSim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function menuGraphs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menuGraphs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set slider value to adjust the value of the appropriate user input box 
slider1_value = get(hObject,'Value');
set(handles.editText1, 'String', slider1_value);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set slider value to adjust the value of the appropriate user input box 
slider2_value = get(hObject,'Value');
set(handles.editText2, 'String', slider2_value);
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set slider value to adjust the value of the appropriate user input box 
slider3_value = get(hObject,'Value');
set(handles.editText3, 'String', slider3_value);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns calledD
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function editText3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function editTextEquation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editTextEquation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in listboxInputs.
function listboxInputs_Callback(hObject, eventdata, handles)
% hObject    handle to listboxInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listboxInputs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listboxInputs


% --- Executes during object creation, after setting all properties.
function listboxInputs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listboxInputs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editText3_Callback(hObject, eventdata, handles)
% hObject    handle to editText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText2 as text
%        str2double(get(hObject,'String')) returns contents of editText2 as a double

function editText2_Callback(hObject, eventdata, handles)
% hObject    handle to editText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText2 as text
%        str2double(get(hObject,'String')) returns contents of editText2 as a double


% --- Executes during object creation, after setting all properties.
function editText2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editText1_Callback(hObject, eventdata, handles)
% hObject    handle to editText1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText1 as text
%        str2double(get(hObject,'String')) returns contents of editText1 as a double


% --- Executes during object creation, after setting all properties.
function editText1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% set slider value to adjust the value of the appropriate user input box 
slider4_value = get(hObject,'Value');
set(handles.editText4, 'String', slider4_value);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function editText4_Callback(hObject, eventdata, handles)
% hObject    handle to editText4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText4 as text
%        str2double(get(hObject,'String')) returns contents of editText4 as a double


% --- Executes during object creation, after setting all properties.
function editText4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function editText5_Callback(hObject, eventdata, handles)
% hObject    handle to editText5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editText5 as text
%        str2double(get(hObject,'String')) returns contents of editText5 as a double

% --- Executes during object creation, after setting all properties.
function editText5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editText5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set slider value to adjust the value of the appropriate user input box 
slider5_value = get(hObject,'Value');
set(handles.editText5, 'String', slider5_value);
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in radio2D.
function radio2D_Callback(hObject, eventdata, handles)
% hObject    handle to radio2D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% when user turns on the 2D option
if get(hObject, 'Value') == 1 
        % plot the current data in 2D
        set(handles.checkContours, 'enable', 'on');
        set(handles.checkNormalize, 'enable', 'on');        
        buttonPlot_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in radio3D.
function radio3D_Callback(hObject, eventdata, handles)
% hObject    handle to radio3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% when user turns on the 2D option
if get(hObject, 'Value') == 1 
        % plot the current data in 3D
        set(handles.checkContours, 'enable', 'off');
        set(handles.checkNormalize, 'Value', 0);
        buttonPlot_Callback(hObject, eventdata, handles)
end
