if IsWindows
    
    % For windows, how about restricting keys for saving responses? Something along these lines (should be checked…)
    
    
    
    %Create and start queue for responses
    
    KbQueueCreate
    
    KbQueueStart
    
    
    
    % Response keys (check NAtA output!)
    
    p.acceptedKeys = ([KbName('0'),KbName('1'),KbName('2'),KbName('3'),...
        
    KbName('4'),KbName('5'),KbName('6'),KbName('7'),KbName('8'),KbName('9')]);



%Collect responses and stop queue

[p.pressed(itrial,:), p.firstPress(itrial,:), p.firstRelease(itrial,:),...
    p.lastPress(itrial,:), p.lastRelease(itrial,:)] = KbQueueCheck;



KbQueueStop



p.firstResp(itrial,:) = p.firstPress(itrial,p.acceptedKeys);

p.lastResp(itrial,:) = p.lastPress(itrial,p.acceptedKeys);

[r_time1, r_index1] = min(p.firstResp(p.firstResp>0));

[r_time2, r_index2] = min(p.lastResp(p.lastResp>0));

elseif IsLinux
    
    %Specify response device name and index (this works for CHBH, tested March 12 2019)
    
    p.responseDeviceName = 'NAtA Technologies LxPAD PK080219 v6.11';
    
    p.responseDeviceNumInputs = 248;
    
    
    
    %Get response device index from its name and number of inputs
    
    [t.inputDevIndices, t.inputDevNames, t.inputDevInfo] = GetKeyboardIndices;
    
    for iKeyb = 1:size(t.inputDevIndices,2)
        
        if strcmp(p.responseDeviceName,t.inputDevNames{iKeyb}) && ...
                
        p.responseDeviceNumInputs == t.inputDevInfo{1,iKeyb}.inputs
        
        p.respDevIndex = t.inputDevIndices(iKeyb);
        
        end
        
    end
    
    
    
    %Create queue for responses
    
    KbQueueCreate(p.respDevIndex);
    
    
    
    %STUFF HAPPENS
    
    
    
    %Collect responses and stop queue
    
    [p.pressed(itrial,:), p.firstPress(itrial,:), p.firstRelease(itrial,:),...
        p.lastPress(itrial,:), p.lastRelease(itrial,:)] = KbQueueCheck(p.respDevIndex);

KbQueueStop(p.respDevIndex);

end

