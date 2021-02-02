function MedianFilter( path, imagePath, n)
greenBar = waitbar(0,'Please wait...');
mkdir(path,'median_images')
imageNames = dir(fullfile(imagePath, '*.jpg'));
imageNames = {imageNames.name}';
steps = length(imageNames) - 1;
j = 1;
for i = 1 : length(imageNames)
    img = medfilt2(imread(fullfile(imagePath,imageNames{i})), [n n]);
    filename = [sprintf('%04d',j) '.jpg'];
    fullname = fullfile(path, 'median_images',filename);
    imwrite(img,fullname);
    j = j +1;
    waitbar(i / steps);
end
% Create success message dialog box
close(greenBar)
msgbox('Operation Completed','Success');
end

