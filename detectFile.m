function timerObj = detectFile(dirName, actionToBeTaken, newFilesOnly, periodMs)

%


if nargin < 3
    newFilesOnly = false;
end

if nargin < 4
    periodMs = 10;
end


timerObj = timer('TimerFcn', {@timerCallback, dirName, actionToBeTaken, newFilesOnly}, 'Period', periodMs, 'executionmode', 'fixedrate');
start(timerObj)
return 

function timerCallback(src, eventdata, dirName, actionToBeTaken, newFilesOnly)
    persistent prs_lastRunTime;
    persistent prs_beginFlag;

     fprintf('Detect File callback for %s\n', dirName);
    
    if isempty(prs_beginFlag)
        prs_lastRunTime = now;
        prs_beginFlag = 1;
        fprintf('File detector for %s has started now\n', dirName);
    end
    
    myDir = dir(dirName);
    if (myDir(1).datenum > prs_lastRunTime) || (~newFilesOnly) % This checks if '.' folder is changed before going into a thorough search
        for k=1:length(myDir)
            file = myDir(k);
            fileTime = file.datenum;
            if (~strncmp(file.name, '.', 1)) && ~isempty(fileTime) && (fileTime > prs_lastRunTime)
                fprintf('%s has changed\n', file.name);
%                 path_scanning=strcat(dirname,'/','scanning_folder',file.name);
                folder_containing_newVideo='/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/new_video/';
                name_video=ls(folder_containing_newVideo);
                full_path_video=strcat(folder_containing_newVideo,name_video)
                call_tracker(full_path_video);
       
            end
        end
    end

    prs_lastRunTime = now;
return
