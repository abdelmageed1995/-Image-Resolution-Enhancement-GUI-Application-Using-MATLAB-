function [imageNames, imagePath] = RemoveFrames( path )
% Handle the empty VideoReader case(inputVideo)
if ~isequal(path, 0)
    % Show that gui in process by creating the mouse loading circle
    greenBar = waitbar(0,'Please wait...');
    % Find Image File Names
    mkdir(fullfile(path, 'unique_images'))
    imageNames = dir(fullfile(path,'images','*.jpg'));
    imageNames = {imageNames.name}';
    steps = length(imageNames) - 1;
    j = 1; % counter for image naming
    for i = 1 : length(imageNames) - 1
       fullname = fullfile(path,'images',imageNames{i});
       img = imread(fullname);
       fullname = fullfile(path,'images',imageNames{i+1});
       img2 = imread(fullname);
       [m, n] = size(img);
       % check the ratio of the difference between a frame and the next one
       if (length(find((img == img2)==0)) / (m*n)) < 0.07
           continue;
       else 
           filename = [sprintf('%04d',j) '.jpg'];
           fullname = fullfile(path, 'unique_images',filename);
           imwrite(img,fullname);
           j = j +1;
       end
       waitbar(i / steps);
    end
    % Create success message dialog box
    msgbox('Operation Completed','Success');
    close(greenBar)
    imageNames = dir(fullfile(path,'unique_images','*.jpg'));
    imageNames = {imageNames.name}';
    imagePath = fullfile(path,'unique_images');
else 
    % Create error message dialog box
    msgbox('There is no vedio file','Error','error');    
end 
end

