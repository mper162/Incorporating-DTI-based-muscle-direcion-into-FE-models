function [results, id] = readFEBioText(path_to_file, start_str, end_str)
    results = [];
    % Open text file
    fid = fopen(path_to_file,'rt');
    
    % Read first line
    fgetl(fid);
    
    % Loop through text file
    i = 1;
    while feof(fid) == 0
        % Read the line
        tline = fgetl(fid);

        % Find first node number
        if i == 1
            start_idx = strfind(tline, start_str);
            searching = 1;
            x = 0;
            while ~isnan(searching)
                x = x + 1;
                i = searching;
                searching = str2double(tline(start_idx+length(start_str):start_idx+length(start_str)+x));
            end
        id = i;
        end
        % Define start of the line
        node_name = strcat(start_str, string(i), '">');
        
        % Get start and end index of the node coordinates
        start_idx = strfind(tline, node_name);
        if isempty(start_idx)
            break;
        end
        end_idx = strfind(tline, end_str);

        % Cut out node coordinates fro text to array
        data_string = tline(start_idx+strlength(node_name):end_idx-1);
        results(end+1,:) = str2double(strsplit(data_string, ','));
        i = i + 1;
    end
    fclose(fid);
end
