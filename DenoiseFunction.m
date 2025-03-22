function [I6] = DenoiseFunction(filename)

    I = imread(filename);
    I1 = rgb2gray(I);
    I2 = imbinarize(I1,adaptthresh(I1, 0.7));
    se1 = strel('disk',1);
    I4 = imopen(I2,se1);
    se2 =strel('disk',1);
    I5 = imdilate(I4, se2);
    I6 = imgaussfilt(double(I5), 0.8);
end
