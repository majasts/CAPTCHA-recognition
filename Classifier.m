function S = Classifier(im)

[im1,im2,im3, im4, im5] = splitFunction(im);
load net;

Pred1 = classify(net,im1);
Pred2 = classify(net,im2);
Pred3 = classify(net,im3);
Pred4 = classify(net,im4);
Pred5 = classify(net,im5);

S = [Pred1, Pred2, Pred3, Pred4, Pred5];

end
