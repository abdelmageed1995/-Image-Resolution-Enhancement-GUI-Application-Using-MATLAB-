function UnsharpenFilter( path, imagePath, r, a, th)
greenBar = waitbar(0,'Please wait...');
mkdir(path,'Unsharpen_images')
imageNames = dir(fullfile(imagePath, '*.jpg'));
imageNames = {imageNames.name}';
steps = length(imageNames) - 1;
j = 1;
for i = 1 : length(imageNames)
    img = imsharpen(imread(fullfile(imagePath,imageNames{i})),...
        'Radius', r ,'Amount', a,'Threshold', th);    
    filename = [sprintf('%04d',j) '.jpg'];
    fullname = fullfile(path, 'Unsharpen_images',filename);
    imwrite(img,fullname);
    j = j +1;
    waitbar(i / steps);
end
% Create success message dialog box
close(greenBar)
msgbox('Operation Completed','Success');
end