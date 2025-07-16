classdef ephusParser
    % This class is used to turn the .xps files form ephus into data.
    properties
        % Current Folder Path
        path
        
        % Cell of (Filename, Struct with info)
        fullFileList
        
        % Cell of (Cell, Array of Epochs)
        cells
    end
    methods
        %% Constructor. Sets the folder path to the current matlab path
        % Looks in the current path for ephus files and fills the other
        % data fields. 
        function obj = ephusParser(path)
            if nargin < 1
                obj.path = pwd;
            else
                obj.path = path;
            end
            
            [ffl,c] = obj.findData();
            
            obj.fullFileList = ffl;
            obj.cells = c;
        end
        %% Look for xsg files in the current path and populate fields
        % Will empty the current list of files, and then go over all files
        % in the current folder path. If there are any .xsg objects, it
        % will load their data and read out the epoch, cell and so forth.
        % Afterwards, updates the list of available cells and epochs.
        function [ffl,c] = findData(obj)
            % Get the Content of the specified directory
            folderContent = dir(obj.path);
            % Empty old fields
            ffl = {};
            c = {};
            c{1,1} = 'N/A';
            c{1,2} = 0;
            counter = 0;
            
            % Go through all files in the folder
            for i=1:numel(folderContent)
                % Check if they are xsg files by comparing to xsg file
                % naming format via a regexp
                if regexp(folderContent(i).name,'(?<experiment>[A-Z]{2,}\d{4})(?<cell>[A-Z]{4})(?<shot>\d{4})\.xsg')
                    counter = counter+1;
                    % Add them to the file list
                    ffl{counter,1} = folderContent(i).name;
                    fileStruct.name = folderContent(i).name;
                    % Load the Data
                    tmp = load([obj.path '/' folderContent(i).name],'-mat');
                    fileStruct.header = tmp.header;
                    fileStruct.data = tmp.data;
                    if isempty(fileStruct.data.ephys)
                        counter = counter-1;
                        disp(['Could not load file ' folderContent(i).name ' - Skipping...']);
                        continue;
                    end
                    fileStruct.epoch = str2double(tmp.header.xsg.xsg.epoch);
                    fileStruct.visible = 1;
                    fileStruct.cell = tmp.header.xsg.xsg.setID;
                    fileStruct.initials = tmp.header.xsg.xsg.initials;
                    fileStruct.experimentNumber = str2double(tmp.header.xsg.xsg.experimentNumber);
                    % One bigger then filename, for some reason.
                    fileStruct.acquisitionNumber = str2double(tmp.header.xsg.xsg.acquisitionNumber)-1; 
                    
                    % Write to list
                    ffl{counter,2} = fileStruct; %#ok<*AGROW>
                    
                    % Update cells and epochs
                    idx = 0;
                    for j=1:size(c,1)
                        if strcmp(fileStruct.cell,c{j,1})
                            idx = j;
                            break;
                        end
                    end
                    if idx < 1
                        newidx = size(c,1)+1;
                        c{newidx,1} = fileStruct.cell;
                        c{newidx,2} = [fileStruct.epoch];
                    else
                        if ~any(c{idx,2}==fileStruct.epoch)
                            c{idx,2} = [c{idx,2} fileStruct.epoch];
                        end
                    end
                    clear fileStruct
                end
            end
        end
        %% 
    end
end