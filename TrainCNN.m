tic;
digitDatasetPath = './labeled_character';

imds = imageDatastore(digitDatasetPath, ...
    'IncludeSubfolders',true,'LabelSource','foldernames');

labelCount = countEachLabel(imds);
[imdsTrain,imdsValidation] = splitEachLabel(imds, 0.7, 0.3);

layers = [
    imageInputLayer([40 20 1], 'Name', 'input')

    % First Convolutional Block
    convolution2dLayer(5, 256, 'Padding', 'same', 'Name', 'conv1')
    reluLayer('Name', 'relu1')
    batchNormalizationLayer('Name', 'batchnorm1')
    maxPooling2dLayer(2, 'Stride', 2, 'Padding', 'same', 'Name', 'maxpool1')
    dropoutLayer(0.2, 'Name', 'dropout1')

    % Second Convolutional Block
    convolution2dLayer(3, 128, 'Padding', 'same', 'Name', 'conv2')
    reluLayer('Name', 'relu2')
    batchNormalizationLayer('Name', 'batchnorm2')
    maxPooling2dLayer(2, 'Stride', 2, 'Padding', 'same', 'Name', 'maxpool2')
    dropoutLayer(0.2, 'Name', 'dropout2')

    % Third Convolutional Block
    convolution2dLayer(3, 64, 'Padding', 'same', 'Name', 'conv3')
    reluLayer('Name', 'relu3')
    batchNormalizationLayer('Name', 'batchnorm3')
    maxPooling2dLayer(2, 'Stride', 2, 'Padding', 'same', 'Name', 'maxpool3')
    dropoutLayer(0.3, 'Name', 'dropout3')

    % Flatten layer
    fullyConnectedLayer(64, 'Name', 'fc1')
    reluLayer('Name', 'relu4')
    batchNormalizationLayer('Name', 'batchnorm4')
    dropoutLayer(0.3, 'Name', 'dropout4')

    % First Dense Block
    fullyConnectedLayer(64, 'Name', 'fc2')
    reluLayer('Name', 'relu5')
    batchNormalizationLayer('Name', 'batchnorm5')
    dropoutLayer(0.3, 'Name', 'dropout5')

    % Output Layer
    fullyConnectedLayer(19, 'Name', 'fc3')
    softmaxLayer('Name', 'softmax')
    classificationLayer('Name', 'output')
];

% Improved Training Options with Learning Rate Schedule and L2 Regularization
options = trainingOptions('adam', ...
    'InitialLearnRate',0.001, ...
    'LearnRateSchedule','piecewise', ...
    'LearnRateDropFactor',0.5, ...
    'LearnRateDropPeriod',5, ...
    'MaxEpochs',20, ...  % Increased number of epochs
    'L2Regularization', 0.0005, ...
    'Shuffle','every-epoch', ...
    'ValidationData',imdsValidation, ...
    'ValidationFrequency',30, ...
    'Verbose',false, ...
    'Plots','training-progress')

net = trainNetwork(imdsTrain,layers,options);
%%
YPred = classify(net,imdsValidation);
YValidation = imdsValidation.Labels;

accuracy = sum(YPred == YValidation)/numel(YValidation)
figure(); confusionchart(confusionmat(YPred,YValidation), imds.countEachLabel.Label)
figure(); plotconfusion(YPred,YValidation)
save net;
load net;
toc;

% classNames = categories(imds.Labels);
% labelCount = countEachLabel(imds)
