tic
fileID = fopen('labels_test.txt', 'r');
true_labels = [];
cnt = 1;
while ~feof(fileID)
    line = fgetl(fileID);
    if ischar(line)
        true_labels(cnt, 1:5) = char(line);
    end
    cnt = cnt + 1;
end
fclose(fileID);
N = size(true_labels, 1);
my_labels = [];
correct_array = zeros(N, 1);
for k = 1:N
    filename = strcat('samples_test/', true_labels(k, :), '.png');
    im = imread(filename);
    my_labels(k, 1:5) = char(Classifier(im));
    correct_array(k) = sum(char(true_labels(k, :)) == char(my_labels(k, :)));
    if mod(k, 50) == 0
        disp(k)
    end
end
toc

%%
figure();
confusionchart(confusionmat(true_labels(:), my_labels(:)), categories(imds.Labels))
