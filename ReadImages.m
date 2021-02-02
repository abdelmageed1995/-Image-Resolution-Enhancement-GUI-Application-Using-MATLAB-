function  [imageNames, imagePath] = ReadImages( name, path )
% Check for the file existance
if ~isequal(path, 0) 
    if ~isequal(name,0)
        fullname = fullfile(path, name); % fullnaem = path + name
        inputVideo = VideoReader(fullname); % read the video file
        mkdir(fullfile(path,'images')); % create new dir
        % Show that gui in process by creating a loading bar
        greenBar = waitbar(0,'Please wait...');
        drawnow;
        steps = inputVideo.Duration * inputVideo.FrameRate;
        j = 1;
        while hasFrame(inputVideo)
           img = readFrame(inputVideo);
           % Create image name
           filename = [sprintf('%04d',j) '.jpg'];
           imageName = fullfile(path,'images',filename);
           % Write out to a JPEG image file
           imwrite(rgb2gray(img),imageName);
           waitbar(j / steps);
           j = j+1;
        end
        % Create success message dialog box
        msgbox('Frames Reading Completed','Success');
        close(greenBar)
        % Output the image names and their path
        imageNames = dir(fullfile(path,'images','*.jpg'));
        imageNames = {imageNames.name}';
        imagePath = fullfile(path,'images');
    else
        imageNames = dir(fullfile(path,'*.jpg'));
        imageNames = {imageNames.name}';
        imagePath = path;
    end
else
    % Create error message dialog box
    msgbox('User does not choose a vedio file','Error','error');
end
end