function video2frames( video_file, extension )
%VIDEO2FRAMES Converts a videofile into frames
%   video_file: path to the video
%
%   folder_destination: the folder where the images will be stored.
%   IMPORTANT!: This code will create a folder inside [folder_destination]
%   with the same name of the video
%
%   extension: The image output extension:
%               jpg, tif, etc.

% Extract video path and filename
[filepath,name, ~] = fileparts(video_file);
folder_destination = [filepath, filesep, 'muestra'];

% Load video
video = VideoReader(video_file);

% Video parameters (do not modify)
fr = video.FrameRate;
tt = video.Duration;

% Set cutting parameters
initial_time    = 0;    % Start cutting (in seconds)
final_time      = tt;    % Final cutting (in seconds)
frame_step      = 1;   % It will jump between [frame_step] frames


% Start frame extraction
if final_time > tt
    error('The final time is larger than the video duration.')
elseif initial_time < 0
    error('Initial time cannot be negative.')
elseif isequal(folder_destination,'')
    error('No folder has been set as a directory ouput.')
else
    % Clear previous files
    if exist(folder_destination,'dir')
        disp('Folder already exists. Deleting...')
        rmdir(folder_destination, 's');
        mkdir(folder_destination);
    else
        mkdir(folder_destination);
    end
    
    
    % Start frame extraction
    disp('Converting video...');
    ii = 1;
    while hasFrame(video)
        img = readFrame(video);
        filename = [sprintf('%03d',ii) ['.', extension] ];
        fullname = fullfile(folder_destination, filename);
        imwrite(img,fullname)    % Write out to a JPEG file (img1.jpg, img2.jpg, etc.)
        ii = ii+1;
    end
    disp('Conversion finished SUCCESSFULLY');
end

end

