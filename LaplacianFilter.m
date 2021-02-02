function LaplacianFilter( path, imagePath)
greenBar = waitbar(0,'Please wait...');
mkdir(path,'laplacian_images')
imageNames = dir(fullfile(imagePath, '*.jpg'));
imageNames = {imageNames.name}';
steps = length(imageNames) - 1;
j = 1;
for i = 1 : length(imageNames)
    laplacian_filter =fspecial('laplacian') ;
    img = imfilter(imread(fullfile(imagePath,imageNames{i})), laplacian_filter);    
    filename = [sprintf('%04d',j) '.jpg'];
    fullname = fullfile(path, 'laplacian_images',filename);
    imwrite(img,fullname);
    j = j +1;
    waitbar(i / steps);
end
% Create success message dialog box
close(greenBar)
msgbox('Operation Completed','Success');
end