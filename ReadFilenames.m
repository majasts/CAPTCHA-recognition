imageFolder = 'samples_train';
files = dir(fullfile(imageFolder, '*.png'));

fileID = fopen('labels_train.txt', 'w');

for k = 1:length(files)
    [~, fileName, ~] = fileparts(files(k).name);
    fprintf(fileID, '%s\n', fileName);
end

fclose(fileID);

disp('Labels file has been created.');

imageFolder = 'samples_test';
files = dir(fullfile(imageFolder, '*.png'));

fileID = fopen('labels_test.txt', 'w');

for k = 1:length(files)
    [~, fileName, ~] = fileparts(files(k).name);
    fprintf(fileID, '%s\n', fileName);
end

fclose(fileID);

disp('Labels file has been created.');