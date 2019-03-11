% CHBH Scanner Volume Recovery
% refer to https://github.com/Psychtoolbox-3/Psychtoolbox-3/wiki/FAQ:-Processing-keyboard-input
% We use KbQueueCheck in this example which will safely capture input events 
% even if they occurred while the script was busy doing other stuff.

%% assuming there is nothing added to the loop - timing recovery is ~7ms after scanner volume

IsLinux

IsWindows

%% Insert this code at the beginning of your script.
commandwindow % this is important to rpevent keypresses spilling into the editor
KbName('UnifyKeyNames');
escapeKey = KbName('ESCAPE');
timingKey = KbName('t')
% % Prevent spilling of keystrokes into console:
% ListenChar(-1);
KbQueueCreate
while KbCheck; end % Wait until all keys are released.

% END OF PRE-AMBLE

%% 't' detection code. Place at part of script where you need the first volume.
keypress_enum = 0;

KbQueueStart
loop_start = GetSecs
while 1 % await 't' press
    % Check the queue for key presses.
    [pressed, firstPress, firstRelease, lastPress, lastRelease]=KbQueueCheck;
    % If the user has pressed a key, then display its code number and name.
    %if pressed
    if pressed == 0
        %we don't change k to blank - a, h, s start - any other key except
        %ESCAPE pauses.  ESCAPE...escapes.
    else
        if firstPress(timingKey)
            % we have our timing event...
            lastPress_timingKey = lastPress(timingKey);
            % this retain the timing of the 't' press from KbQueueStart
            % recover this for verification if required
            break % we now exit this loop
        end
    end
    
    % if you want to force the program to continue - press escape.
    if firstPress(escapeKey)
        break;
    end
    
    % pause(0.000001)
    %clc
    end

    disp(['The `t` timing event occured ',num2str(lastPress_timingKey),'ms after the KbQueueStart command'])
    
    %% PLACE AT END OF SCRIPT & IN TRY/CATCH
    KbQueueRelease()
    