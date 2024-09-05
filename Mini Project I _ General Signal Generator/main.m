function main
    % Main function to orchestrate the signal generation and operations
    [Fs, t, nBreaks, breakPoints] = getUserInputs();
    originalSignal = generateSignal(Fs, t, nBreaks, breakPoints);
    
    % Plot the original signal immediately after creation
    plotSignal(t, originalSignal, 'Initial Signal - Before Any Operations');
    
    % Initialize the modified signal
    modifiedSignal = originalSignal;
    
    % Copy the original time vector to a new variable for modifications
    t_mod = t;
    
    % Define operation choices
    operations = {'Scale', 'Reverse', 'Shift', 'Expand', 'Compress', 'Clip', 'Derivative', 'None', 'Stop'};
    operationCodes = {'s', 'rev', 'sh', 'ex', 'co', 'cl', 'd', 'n', 'stop'};
    
    % Loop to apply operations until the user enters 'Stop'
    while true
        % Display available operations
        disp('Available operations:');
        for i = 1:length(operations)
            disp([num2str(i) '. ' operations{i} ' (' operationCodes{i} ')']);
        end
        
        % Get user selection
        operationSel = input('Select an operation number or code to perform on the signal or enter Stop to finish: ', 's');
        
        % Check if user input is a number or operation code and get the corresponding operation
        operationIdx = find(strcmpi(operationSel, operationCodes) | strcmpi(operationSel, operations));
        if isempty(operationIdx)
            disp('Invalid operation selection. Please try again.');
            continue;
        elseif strcmpi(operationSel, 'stop') || strcmpi(operationSel, '9')
            % When 'Stop' is entered, plot the original and the last modified signals
            plotSignal(t, originalSignal, 'Original Signal');
            plotSignal(t_mod, modifiedSignal, 'Final Modified Signal');
            break;
        end

        % Get the actual operation name
        operation = operations{operationIdx};
        
        % Apply the selected operation
         [modifiedSignal, t_mod] = applyOperations(modifiedSignal, t,t_mod, Fs, operation);

        % Plot the modified signal after each operation
        plotSignal(t_mod, modifiedSignal, ['Modified Signal - ', operation]);
    end
end


function plotSignal(t, signal, titleText)
    % Helper function to plot a signal
    figure;
    plot(t, signal);
    title(titleText);
    xlabel('Time (s)');
    ylabel('Amplitude');
end





function signal = generateSignal(~, t, ~, breakPoints)
    % Initialize the complete signal with zeros
    signal = zeros(size(t));
    
    % Determine the time regions for each signal portion
    regions = [min(t), breakPoints, max(t)];

    for i = 1:length(regions) - 1
        % Get specifications for the signal portion
        [signalType, params] = getSignalSpecs();

        % Generate each portion of the signal and directly assign it
        portion = generatePortion(signalType, t, regions(i), regions(i+1), params);
        idx = t >= regions(i) & t < regions(i+1);
        signal(idx) = portion(idx); % Only update the signal in the designated interval
    end
end


function [Fs, t, nBreaks, breakPoints] = getUserInputs()
    % Get general user inputs for signal generation
    Fs = input('Enter the sampling frequency of the signal: ');
    tStart = input('Enter the start of time scale: ');
    tEnd = input('Enter the end of time scale: ');
    nBreaks = input('Enter the number of break points: ');
    breakPoints = zeros(1, nBreaks);
    for i = 1:nBreaks
        breakPoints(i) = input(['Enter the position of break point ' num2str(i) ': ']);
    end
    t = linspace(tStart, tEnd, (tEnd - tStart) * Fs);
end

function [type, params] = getSignalSpecs()
    % Define valid signal types
    validTypes = {'dc', 'ramp', 'polynomial', 'exponential', 'sinusoidal', 'sinc', 'triangle'};
    type = lower(input('Enter signal type (DC, Ramp, Polynomial, Exponential, Sinusoidal, Sinc, Triangle): ', 's'));
    
    if ~ismember(type, validTypes)
        error('Unsupported signal type entered. Valid types are: %s', strjoin(validTypes, ', '));
    end

    params = struct();
    switch type
        case 'dc'
            params.amplitude = input('Enter amplitude: ');
        case 'ramp'
            params.slope = input('Enter slope: ');
            params.intercept = input('Enter intercept: ');
        case 'polynomial'
            degree = input('Enter the degree of the polynomial: ');
            params.coefficients = zeros(1, degree + 1);
            for i = degree:-1:0
                coeff = input(sprintf('Enter the coefficient for x^%d: ', i));
                params.coefficients(degree - i + 1) = coeff;
            end
        case 'sinusoidal'
            params.amplitude = input('Enter amplitude: ');
            params.frequency = input('Enter frequency: ');
            params.phase = input('Enter phase: ');
        case 'sinc'
            params.amplitude = input('Enter amplitude: ');
            params.centerShift = input('Enter center shift: ');
        case 'triangle'
            params.amplitude = input('Enter amplitude: ');
            params.centerShift = input('Enter center shift: ');
            params.width = input('Enter width: ');
        case 'exponential'
            params.amplitude = input('Enter amplitude: ');
            params.exponent = input('Enter exponent: ');
    end
end

function portion = generatePortion(type, t, ~, endd, params)
    % Generate signal portion based on the type and parameters
    idx = t <= endd; % Only consider the end point since the start is handled by the absolute t vector
    portion = zeros(size(t));
    switch type
        case 'dc'
            portion(idx) = params.amplitude;
        case 'ramp'
            % Use the absolute time vector
            portion(idx) = params.slope * t(idx) + params.intercept;
        case 'polynomial'
            % Use polyval with the absolute time vector
            portion(idx) = polyval(params.coefficients, t(idx));
        case 'sinusoidal'
            % Use the absolute time vector for sinusoidal calculations
            portion(idx) = params.amplitude * sin(2 * pi * params.frequency * t(idx) + params.phase);
        case 'sinc'
            % Use the absolute time vector, adjust for center shift
            shifted_t = t(idx) - params.centerShift;
            portion(idx) = params.amplitude * sinc(shifted_t);
        case 'triangle'
            % Use the absolute time vector, adjust for center shift
            shifted_t = t(idx) - params.centerShift;
            % Triangle function needs to be computed manually for each t value
            for i = find(idx)
                portion(i) = params.amplitude * max(1 - abs(shifted_t(i))/params.width, 0);
            end
        case 'exponential'
            % Use the absolute time vector for exponential calculation
            portion(idx) = params.amplitude * exp(params.exponent * t(idx));
    end
end


function [modifiedSignal, t_mod] = applyOperations(signal,t,  t_mod, ~, op)
% Use t_mod throughout this function instead of t
    switch lower(op)
        case 'scale'
            factor = input('Enter scale factor: ');
            modifiedSignal = signal * factor;
            % No change in time vector for scaling
        case 'reverse'
            modifiedSignal = fliplr(signal);
            % No change in time vector for reversing
        case 'shift'
            shift_val = input('Enter the value of the shift (positive for right shift, negative for left shift): ');
            t_mod = t_mod + shift_val;  % Shift the time vector
            modifiedSignal = signal;  % Keep the signal values unchanged

        case 'expand'
            expand_val = input('Enter expansion factor: ');
            t_mod = linspace(min(t)* expand_val, max(t) * expand_val, numel(signal));  % Use the original 't' for range
            modifiedSignal = signal;  % The values of the signal do not change

        case 'compress'
            compress_val = input('Enter compression factor: ');
           % Adjust t_mod based on the compression factor
            t_mod = linspace(min(t)* compress_val, max(t) * compress_val, numel(signal));
            modifiedSignal = signal;  % For compressing, we just change the time vector, not the signal values

          case 'clip'
            upper_clip = input('Enter upper clipping value: ');
            lower_clip = input('Enter lower clipping value: ');
            modifiedSignal = min(max(signal, lower_clip), upper_clip);
            % No change in time vector for clipping
        case 'derivative'
            modifiedSignal = computeDerivative(signal, t);
            % No change in time vector for derivative
        case 'none'
            modifiedSignal = signal;
            % No change in time vector for no operation
        otherwise
            disp('No valid operation selected. Returning original signal.');
            modifiedSignal = signal;
            % No change in time vector for invalid operation
    end
end



function modifiedSignal = computeDerivative(signal, t)
    % Compute the derivative of a signal
    dt = mean(diff(t)); % Assume uniform sampling for simplicity
    modifiedSignal = zeros(size(signal));
    
    % Use second-order accurate differences at the boundaries
    modifiedSignal(1) = (-3*signal(1) + 4*signal(2) - signal(3)) / (2*dt);
    modifiedSignal(end) = (3*signal(end) - 4*signal(end-1) + signal(end-2)) / (2*dt);
    
    % Use central difference for the rest
    for i = 2:length(signal)-1
        modifiedSignal(i) = (signal(i+1) - signal(i-1)) / (2*dt);
    end
end
