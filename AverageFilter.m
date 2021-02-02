function AverageFilter( path, imagePath , n)
greenBar = waitbar(0,'Please wait...');
mkdir(path,'average_images')
imageNames = dir(fullfile(imagePath, '*.jpg'));
imageNames = {imageNames.name}';
steps = length(imageNames) - 1;
j = 1;
for i = 1 : length(imageNames)
    average_filter = fspecial('average', [n n]);
    img = imfilter(imread(fullfile(imagePath,imageNames{i})), average_filter, 'replicate');
    filename = [sprintf('%04d',j) '.jpg'];
    fullname = fullfile(path, 'average_images',filename);
    imwrite(img,fullname);
    j = j +1;
    waitbar(i / steps);
end
% Create success message dialog box
close(greenBar)
msgbox('Operation Completed','Success');
end
