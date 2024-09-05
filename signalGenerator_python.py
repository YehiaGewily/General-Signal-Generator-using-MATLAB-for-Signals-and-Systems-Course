import numpy as np
import matplotlib.pyplot as plt

def main():
    try:
        Fs, t, nBreaks, breakPoints = get_user_inputs()
        signal = generate_signal(Fs, t, nBreaks, breakPoints)
        plot_signal(t, signal, 'Original Signal')

        modified_signal = apply_operations(signal, t, Fs)
        plot_signal(t, modified_signal, 'Modified Signal')
    except Exception as e:
        print("An error occurred:", e)

def get_user_inputs():
    Fs = get_float_input('Enter the sampling frequency of the signal: ')
    tStart = get_float_input('Enter the start of time scale: ')
    tEnd = get_float_input('Enter the end of time scale: ')
    while tEnd <= tStart:
        print("End of time scale must be greater than start of time scale.")
        tEnd = get_float_input('Enter the end of time scale: ')
    
    t = np.linspace(tStart, tEnd, int((tEnd - tStart) * Fs))

    nBreaks = int(get_float_input('Enter the number of break points: '))
    breakPoints = sorted([get_float_input(f'Enter the position of break point {i+1}: ') for i in range(nBreaks)])
    return Fs, t, nBreaks, breakPoints

def get_float_input(prompt):
    while True:
        try:
            return float(input(prompt))
        except ValueError:
            print("Invalid input. Please enter a valid number.")

def generate_signal(Fs, t, nBreaks, breakPoints):
    regions = [t[0]] + breakPoints + [t[-1]]
    signal = np.zeros_like(t)
    for i in range(len(regions) - 1):
        signal_type, params = get_signal_specs()
        start_idx = np.searchsorted(t, regions[i], side='left')
        end_idx = np.searchsorted(t, regions[i+1], side='right')
        portion = generate_portion(signal_type, t[start_idx:end_idx], params)
        signal[start_idx:end_idx] = portion
    return signal

def get_signal_specs():
    valid_types = ['dc', 'ramp', 'polynomial', 'exponential', 'sinusoidal', 'sinc', 'triangle']
    signal_type = input('Enter signal type (DC, Ramp, Polynomial, Exponential, Sinusoidal, Sinc, Triangle): ').lower()
    while signal_type not in valid_types:
        print("Invalid signal type. Please enter one of the following:", ", ".join(valid_types))
        signal_type = input('Enter signal type: ').lower()
    params = {}
    if signal_type == 'dc':
        params['amplitude'] = get_float_input('Enter amplitude: ')
    elif signal_type == 'ramp':
        params['slope'] = get_float_input('Enter slope: ')
        params['intercept'] = get_float_input('Enter intercept: ')
    elif signal_type == 'polynomial':
        params['amplitude'] = get_float_input('Enter amplitude for the polynomial: ')
        params['power'] = get_float_input('Enter power for the polynomial: ')
        params['intercept'] = get_float_input('Enter intercept for the polynomial: ')
    return signal_type, params

def generate_portion(signal_type, t_segment, params):
    portion = np.zeros_like(t_segment)
    if signal_type == 'dc':
        portion[:] = params['amplitude']
    elif signal_type == 'ramp':
        portion[:] = params['slope'] * (t_segment - t_segment[0]) + params['intercept']
    elif signal_type == 'polynomial':
        portion[:] = params['amplitude'] * (t_segment - t_segment[0])**params['power'] + params['intercept']
    return portion

def apply_operations(signal, t, Fs):
    print('Available operations: Scale, Reverse, Shift, Expand, Compress, Clip, Derivative, None')
    operation = input('Select an operation to perform on the signal: ').lower()
    if operation == 'scale':
        factor = get_float_input('Enter scale factor: ')
        modified_signal = signal * factor
    else:
        modified_signal = signal
    return modified_signal

def plot_signal(t, signal, title_str):
    plt.figure()
    plt.plot(t, signal)
    plt.title(title_str)
    plt.xlabel('Time (s)')
    plt.ylabel('Amplitude')
    plt.show()

if __name__ == "__main__":
    main()
