%% Face and Eyes Detection demo
%
% This program demonstrates the cascade recognizer. You can use Haar
% or LBP features.
% This classifier can recognize many kinds of rigid objects, once the
% appropriate classifier is trained. It's most known use is for faces.
%
% <https://github.com/opencv/opencv/blob/3.1.0/samples/cpp/facedetect.cpp>
%

%% Options
function [faces]=eyes_detect_points(frame)
% this is the primary trained classifier such as frontal face
%cascadeName = fullfile(mexopencv.root(),'test','haarcascade_frontalface_alt.xml');
cascadeName= fullfile(mexopencv.root(),'test','haarcascade_eye_tree_eyeglasses.xml');
% this an optional secondary classifier such as eyes
%nestedCascadeName = fullfile(mexopencv.root(),'test','haarcascade_eye_tree_eyeglasses.xml');
% image scale greater or equal to 1, try 1.3 for example
scale = 1.0;
% attempts detection of flipped image as well
tryflip = false;

%% Initialize

% download XML files if missing
%download_classifier_xml(cascadeName);
%download_classifier_xml(nestedCascadeName);

% load cacade classifiers
cascade = cv.CascadeClassifier(cascadeName);
assert(~cascade.empty(), 'Could not load classifier cascade');
nestedCascade = cv.CascadeClassifier();
%if ~nestedCascade.load(nestedCascadeName)
%    disp('Could not load classifier cascade for nested objects');
%end
scale = max(scale, 1.0);

%% Main loop
% (either video feed or a still image)

    % read an image
  %  frame = imread(fullfile(mexopencv.root(),'test','lena.jpg'));
    % detect faces/eyes and draw detections
    [faces ]= detectAndDraw(frame, cascade, nestedCascade, scale, tryflip);
   % imshow(frame);


end

%% Help function
function [faces] = detectAndDraw(img, cascadeF, cascadeE, scale, tryflip)
    % downscale image and preprocess it
    fx = 1/scale;
    gray = cv.cvtColor(img, 'RGB2GRAY');
    gray = cv.resize(gray, fx, fx);
    gray = cv.equalizeHist(gray);
    [h,w] = size(gray);

    % detection options
    detectOpts = {
        'ScaleFactor',1.1, ...
        'MinNeighbors',2, ...
        ... 'FindBiggestObject',true, ...
        ... 'DoRoughSearch',true, ...
        'ScaleImage',true, ...
        'MinSize',[30 30]
    };

    % detect faces
    tic
    faces = cascadeF.detect(gray, detectOpts{:});
   
end

function download_classifier_xml(fname)
    if ~exist(fname, 'file')
        % attempt to download trained Haar/LBP/HOG classifier from Github
        url = 'https://cdn.rawgit.com/opencv/opencv/3.1.0/data/';
        [~, f, ext] = fileparts(fname);
        if strncmpi(f, 'haarcascade_', length('haarcascade_'))
            url = [url, 'haarcascades/'];
        elseif strncmpi(f, 'lbpcascade_', length('lbpcascade_'))
            url = [url, 'lbpcascades/'];
        elseif strncmpi(f, 'hogcascade_', length('hogcascade_'))
            url = [url, 'hogcascades/'];
        else
            error('File not found');
        end
        fprintf('Downloading cascade classifier "%s"...\n', [f ext]);
        url = [url f ext];
url
urlwrite(url, fname);
    end
end
