clc
clear all;
close all;

%% Load images
imageFolder = 'samples';
imageFiles = dir(fullfile(imageFolder, '*.png'));

TrainTestSplit
ReadFilenames

fileID = fopen('labels_train.txt', 'r');
names = {};
while ~feof(fileID)
    line = fgetl(fileID);
    if ischar(line)
        names{end+1} = line; 
    end
end
fclose(fileID);

%% Image processing
N = size(names, 2);
for k = 1:N
    filename = strcat('samples_train/', names{k}, '.png');
    I = DenoiseFunction(filename);
    imwrite(im2bw(I),sprintf('labeledImage/labeled_train_%04d.png', k))
end

%% Load true CAPTCHA code from image name
fileID = fopen('labels_train.txt', 'r');
true_labels = {};
while ~feof(fileID)
    line = fgetl(fileID);
    if ischar(line)
        true_labels{end+1} = line; 
    end
end
fclose(fileID);

%% Create folder for each character
outputFolder = 'labeled_character';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

uniqueChars = {};

for i = 1:length(true_labels)
    label = true_labels{i};

    for j = 1:length(label)
        currentChar = label(j);
        if ~any(strcmp(uniqueChars, currentChar))
            uniqueChars{end+1} = currentChar; 
        end
    end
end

for k = 1:length(uniqueChars)
    uniqueChar = uniqueChars{k};
    mkdir(fullfile(outputFolder, uniqueChar));
end
disp('Folders created for each unique character.');

SplitImage

%% Classifying characters

TrainCNN
EvaluateCNN
