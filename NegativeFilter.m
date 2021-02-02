function NegativeFilter( path, imagePath)
greenBar = waitbar(0,'Please wait...');
mkdir(path,'Negative_images')
imageNames = dir(fullfile(imagePath, '*.jpg'));
imageNames = {imageNames.name}';
steps = length(imageNames) - 1;
j = 1;
for i = 1 : length(imageNames)
    img = imsharpen(imread(fullfile(imagePath,imageNames{i})));
    N=imcomplement(img);
    filename = [sprintf('%04d',j) '.jpg'];
    fullname = fullfile(path, 'Negative_images',filename);
    imwrite(N,fullname);
    j = j +1;
    waitbar(i / steps);
end
% Create success message dialog box
close(greenBar)
msgbox('Operation Completed','Success');
end