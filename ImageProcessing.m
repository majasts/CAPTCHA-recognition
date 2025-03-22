fileID = fopen('labels_train.txt', 'r');
names = {};
while ~feof(fileID)
    line = fgetl(fileID);
    if ischar(line)
        names{end+1} = line; 
    end
end
fclose(fileID);

%%
N = size(names, 2);
for k = 1:N
    filename = strcat('samples_train/', names{k}, '.png');
    I = imread(filename);
    I1 = rgb2gray(I);
    I2 = imbinarize(I1,adaptthresh(I1, 0.7));
    se1 = strel('disk',1);
    I4 = imopen(I2,se1);
    se2 =strel('disk',1);
    I5 = imdilate(I4, se2);
    I6 = imgaussfilt(double(I5), 0.8);
    imwrite(im2bw(I6),sprintf('labeledImage/labeled_train_%04d.png', k))
end
