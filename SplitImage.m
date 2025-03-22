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
            uniqueChars{end+1} = currentChar; %#ok<AGROW>
        end
    end
end

for k = 1:length(uniqueChars)
    uniqueChar = uniqueChars{k};
    mkdir(fullfile(outputFolder, uniqueChar));
end

disp('Folders created for each unique character.');
%% Izdvajanje karaktera sa slika

N = size(true_labels,2);
i_p = 0;
all_n_number = [];

for cnt = 1:N
    im = imread(sprintf('labeledImage/labeled_train_%04d.png', cnt));
    bw_img = ~im;
    bw_img = bwareaopen(bw_img, 50);
    [labeledImage, numComponents] = bwlabel(bw_img);
    props = regionprops(labeledImage, 'BoundingBox', 'Area');
    
    disp(cnt)
    while size(props, 1) < 5
        numComponents = size(props, 1);
        if size(props, 1) < 5
            [~, largestIdx] = max([props.Area]);
            largeBox = props(largestIdx).BoundingBox;
            splitWidth = round(largeBox(3) / (5 - numComponents + 1));
    
            for k = numComponents:-1:largestIdx+1
                props(k+1) = props(k); 
            end
    
            if numComponents == 1
                props(2, :) = props(1, :);
            end
    
            for k = 1:(5 - numComponents + 1)
                newBox = largeBox;
                newBox(1) = largeBox(1) + (k-1) * splitWidth;
                newBox(3) = splitWidth;
                props(largestIdx + k - 1).BoundingBox = newBox;
            end
    
        elseif size(props, 1) > 5
            for k = 1:(numComponents - 5)
                minDist = inf;
                mergeIdx = [0, 0];
                for i = 1:numComponents-1
                    dist = props(i+1).BoundingBox(1) - (props(i).BoundingBox(1) + props(i).BoundingBox(3));
                    if dist < minDist
                        minDist = dist;
                        mergeIdx = [i, i+1];
                    end
                end
    
                props(mergeIdx(1)).BoundingBox(3) = ...
                    props(mergeIdx(2)).BoundingBox(1) + props(mergeIdx(2)).BoundingBox(3) - props(mergeIdx(1)).BoundingBox(1);
                props(mergeIdx(2):end-1) = props(mergeIdx(2)+1:end);
                props(end) = [];
                numComponents = numComponents - 1;
            end
        end
    end
    
    for i = 1:5
        thisBoundingBox = props(i).BoundingBox;
        subImage = imcrop(bw_img, thisBoundingBox);
    
        true_label =  true_labels{cnt};
        if isnan(str2double(true_label(i)))
            converted_label = true_label(i);
        else
            converted_label = str2double(true_label(i));
        end
        outputFileName = strcat('./labeled_character/', true_label(i), '/', int2str(i_p), '.tif');
        resized_image = imresize(subImage,[40,20]);
        imwrite(resized_image, outputFileName);
        i_p = i_p + 1;
    end

end
