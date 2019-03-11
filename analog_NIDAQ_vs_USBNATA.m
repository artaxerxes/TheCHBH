%% this code provides a sanity test between the NIDAQ and the USB NATA 't' response

commandwindow
%% set up Keyboard

KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
% % Prevent spilling of keystrokes into console:
% ListenChar(-1);
KbQueueCreate
while KbCheck; end % Wait until all keys are released.
KbQueueStart

%% generate data

fs = floor(100000)
num_runs = 10
impulse_duration =1;
impulse_volts = 3.3;
duration = num_runs;

outputdata = zeros(1, fs*num_runs)';
for iterations = 1:num_runs
    
    impulse_start = ceil(((fs * iterations)-0.5*fs));
    outputdata(impulse_start:impulse_start+(impulse_duration-1)) = 3.3;  %TTL at the mid point of each second for 1us
    
end

plot(outputdata)

devices = daq.getDevices

devices(1)

s = daq.createSession('ni')

addAnalogOutputChannel(s,'Dev1',0,'Voltage');
addAnalogOutputChannel(s,'Dev1',1,'Voltage');

s.Rate = fs

queueOutputData(s,[outputdata outputdata]);

%% Start the Session in Foreground
% Use the |startForeground| function to start the analog output
% operation and block MATLAB execution until all data is generated.
prepare(s);
%% DAQ_start
keep_key = zeros(1,20);
keep_t = zeros(1,20);
keypress_enum = 0;

s.startBackground
DAQ_start = GetSecs

while GetSecs < (DAQ_start + num_runs)
    % Check the queue for key presses.
    [pressed, firstPress, firstRelease, lastPress, lastRelease]=KbQueueCheck;
    % If the user has pressed a key, then display its code number and name.
    %if pressed
    if pressed == 0
        %we don't change k to blank - a, h, s start - any other key except
        %ESCAPE pauses.  ESCAPE...escapes.
    else
        
        keypress_enum = keypress_enum +1;
        %keep_key(keypress_enum) = KbName(find(firstPress, 1 ));
        keep_t(keypress_enum) = firstPress(find(firstPress, 1 )) - DAQ_start;
    end
    
    if firstPress(escapeKey)
        break;
    end
    
    % pause(0.000001)
    %clc
end

keep_t
KbQueueRelease

