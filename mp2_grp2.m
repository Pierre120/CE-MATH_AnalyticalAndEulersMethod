%{
  MP2
  GROUP2:
    - ESCASA, Francisco Joaquin
    - HERNANDEZ, Pierre Vincent

    ASSIGNED EQUATION:
    2.) (dy/dx) + y = 2x
%}

% ====== START OF PROGRAM ======

% Prompt the user what this script does
diff_eq = 'dy/dx = 2x - y';
fprintf("\nThis script employs Euler's method to solve ");
fprintf("the differential equation\n%s\n\n", diff_eq);

% Ask for the initial condition for `x` and `y`
[x_init, y_init] = get_initialconditions();

% Ask for the lower and upper limit
[lowerlim, upperlim] = get_limits(x_init);

% Ask for the interval or step size
interval = get_interval(lowerlim, upperlim);

% Evaluate at one point only
if(interval == 0)
    x_vals = x_init; % x_vals only has 1 element which is the intial value of `x`
else
    % Generate the values `x` in the specified range
    x_vals = lowerlim:interval:upperlim;
end

% Solve the differential equation using the Euler's method
eulers_vals = eulers_method(x_vals, interval, y_init);

% Tabulate the solution for both the analytical and Euler's method
tabulate_solutions(x_vals, eulers_vals, x_init, y_init);

% Display the plot of both solution
plot_solutions(x_vals, eulers_vals, x_init, y_init, lowerlim, upperlim);

% ====== END OF PROGRAM  =======



% ====== FUNCTIONS =============

function [user_input] = get_num_input(strPrompt)
%{
    This function handles user's numerical input and returns
    it when it is a valid input.
%}
   tmp = '';

    % Continue asking user if input is empty
    % or is not a number(double) input
    while isempty(tmp) || isnan(str2double(tmp))
        tmp = input(strPrompt,'s');
    end
    
    % Convert string input to a double
    user_input = str2double(tmp);
end

function [x_init, y_init] = get_initialconditions()
%{
    This function handles the getting of initial conditions
    for both x and y. It then returns valid x and y values.
%}
    % Get intial value for `x`
    x_init = get_num_input('Enter initial condition value for x: ');
    % Get intial value for `y`
    y_init = get_num_input('Enter initial condition value for y: ');
end

function [lower_lim, upper_lim] = get_limits(x_init)
%{
    This function handles the getting of lower and upper limit
    for the x range.
%}
    % Initialize the lower_lim with the value of x_init - 1.
    % This is done so it would be able to enter the while-loop.
    lower_lim = x_init - 1;
    
    % Initialize the lower_lim with the value of lower_lim - 1.
    % This is done so it would be able to enter the while-loop.
    upper_lim = lower_lim - 1;

    % Continuously ask for the lower limit until user enters
    % the same value as the initial value of `x`
    while(lower_lim ~= x_init)
        lower_lim = get_num_input('Enter lower limit: ');
        
        % Prompt user that input is invalid
        if(lower_lim ~= x_init)
            fprintf("Lower limit must be equal to the initial value of `x`!\n\n");
        end
    end
    
    % Continuously ask for the upper limit until user enters
    % a value that is greater than or equal to the lower limit
    while(upper_lim < lower_lim)
        upper_lim = get_num_input('Enter upper limit: ');
        
        % Prompt user that input is invalid
        if(upper_lim < lower_lim)
            fprintf("Upper limit must be greater than or equal to the lower limit!\n\n");
        end
    end
end

function [interval] = get_interval(low_lim, up_lim)
%{
    This function handles the getting of interval.
%}
    % Temporarily initilize the interval so it could enter the loop
    interval = -1;

    % Check if the low_lim and up_lim is equal
    if(low_lim == up_lim)
        % Promt user that interval or step size input is skipped
        % due to the equation being solved at 1 point only
        fprintf("Input for the interval or step size is skipped!\n");
        fprintf("Lower limit and upper limit are equal, ");
        fprintf("so it will only solve at 1 point only.\n\n");

        % At 1 point only
        interval = 0;

    % low_lim and up_lim is not equal
    else 
        % Continuously ask for input until user enters 
        % a value that is greater than or equal to 0
        % and range is divisible by the interval input
        while(true)
            interval = get_num_input('Enter the interval or step size: ');

            % Prompt the user for invalid input
            if(interval <= 0)
                fprintf("Input must be greater than 0!\n\n");

            % Given range from low_lim to up_lim is not divisible
            % by entered interval.
            elseif(rem(up_lim-low_lim, interval) ~= 0)
                fprintf("Given range from %.4f to %.4f \n", low_lim, up_lim);
                fprintf("that has length: %.4f is not divisible \n", up_lim-low_lim);
                fprintf("by the entered interval value!\n\n");

            % Correct input
            elseif(rem(up_lim-low_lim, interval) == 0)
                break; % Exit loop
            end
        end
    end
end

function [error_pcts] = get_errorpct(analytical_vals, eulers_vals)
%{
    This function gets the percent relative errors of the 
    analytical and euler's solution. It then returns the error values.
%}    
    % abs((true value - approx)/true value) * 100
    error_pcts = abs((analytical_vals - eulers_vals) ./ analytical_vals).*100;
end

function [analytical_vals] = analytical_method(x_values, x_init, y_init)
%{
    This function uses the analytical method to provide the solution.
    It then returns those values.
%}
    % FORMULA FOR TRUE/EXACT/ANALYTICAL SOLUTION:
    % y = ce^-x + 2x - 2

    % Get constant
    % FORMULA: c = e^x(y - 2x + 2)
    const = exp(x_init)*(y_init - 2*x_init + 2);

    % Get the analytical solution for all values of `x_vals`
    analytical_vals = const.*exp(-x_values) + 2.*x_values - 2;
end

function [eulers_vals] = eulers_method(x_values, interval, y_init)
%{
    This function uses the euler's method to provide the solution.
    It then returns those values.
%}
    % FORMULA EULER'S SOLUTION:
    % y_i+1 = y_i + f(x_i, y_i)h
    
    % If evaluation is at one point only
    if(numel(x_values) == 1) % interval == 0
        eulers_vals = y_init;
        return; % return with the same value as y_init
    
    % x_values has more than 1 element
    else
        % Get number of elements in `x_values`
        % Will be used as the upper limit of iteration in for-loop.
        max_i = numel(x_values) - 1; 
    
        % Preallocate memory for `eulers_vals` with the 
        % same size as the x_values.
        eulers_vals = zeros(size(x_values));
    
        % Initialize first value of the Euler's solution
        eulers_vals(1) = y_init;
    
        % Use for loop to get all y_i values
        for i = 1:max_i
            % Get the slope estimate base on the current x_i and y_i
            % FORMULA: y' = 2x - y
            slp_est = 2*x_values(i) - eulers_vals(i);
            % Solve for the y_i+1
            y_i1 = eulers_vals(i) + slp_est*interval;
            % Store it as the next value of the eulers_vals
            eulers_vals(i+1) = y_i1;
        end
    end
end

function tabulate_solutions(vars, eulers_vals, x_init, y_init)
%{
    Tabulates the solution got from the analytical and euler's
    method together with the percent relative error on the
    MATLAB command window.
%}
    % Column names
    colNames = {'x', 'y_true', 'y_Euler''s', 'Error (%)'};
    % Store the values of params into local variables
    x_vars = vars;
    analytical_vals = analytical_method(vars, x_init, y_init);
    eulers = eulers_vals;
    error_pcts = get_errorpct(analytical_vals, eulers_vals);

    % If x_vars vector is a row vector change into a column vector
    if(isrow(x_vars))
        x_vars = transpose(x_vars);
    end

    % If analytical vector is a row vector change into a column vector
    if(isrow(analytical_vals))
        analytical_vals = transpose(analytical_vals);
    end

    % If eulers vector is a row vector change into a column vector
    if(isrow(eulers))
        eulers = transpose(eulers);
    end

    % If errors vector is a row vector change into a column vector
    if(isrow(error_pcts))
        error_pcts = transpose(error_pcts);
    end

    % Create and form tabulated solution
    solutionTable = table(x_vars, analytical_vals, eulers, error_pcts, ...
        'VariableNames', colNames);

    % Display tabulated solution
    fprintf("\nTabulated solutions:\n");
    disp(solutionTable);
end

function [points] = generateNumberOfPoints(low_lim, up_lim)
%{
    Returns the number of points that need to be generated
    from low_lim to up_lim. This is done by getting the
    difference of up_lim and low_lim first, then checking whether
    the difference is less than or equal to 1. If true it returns
    100, otherwise it returns the quotient of the difference and 100.
%}
    % Calculate the difference
    difference = up_lim - low_lim;
    
    % Get the number of points
    if(difference <= 1) % small interval
        points = 100;
    else
        points = difference*100; % bigger interval
    end
end

function plot_solutions(x_vars, eulers_vals, x_init, y_init, low_lim, up_lim)
%{
    Plots the solution from the analytical and euler's method
    in a MATLAB figure.
%}
    % Generate number of points needed
    numPoints = generateNumberOfPoints(low_lim,up_lim);
    
    % at 1 point only
    if(numel(x_vars) == 1) % up_lim - low_lim == 0
        % For sure that the x_vars also contains 1 element
        % when the given conditions is at 1 point only.
        true_vars = x_vars;
    else
        % Generate numPoints of elements from low_lim to up_lim.
        % This will be the variables that will be used when plotting
        % the analytical/true/exact solution.
        true_vars = linspace(low_lim,up_lim,numPoints);
    end
    
    % Get the analytical solution to plot
    true_vals = analytical_method(true_vars, x_init, y_init);

    % Create figure for plot
    figure,
    clf; hold on
    
    % Plot the analytical/true/exact solution
    plot(true_vars,true_vals, ...
        'Color','#0072BD', ...
        'DisplayName','True Solution')

    % Plot the Euler's method solution
    plot(x_vars,eulers_vals, ...
        'Color','black', ...
        'Marker','.', ...
        'MarkerSize',14, ...
        'DisplayName','Euler Solution')

    % Add title and labels
    xlabel('x')
    ylabel('y')
    title('Analytical and Euler''s Solution Graph')
    
    % Display legend
    legend
    hold off
end
