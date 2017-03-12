function W = Classify(ImageRead)
clc;
%getting orginal color image
RGB = imread('test.bmp');
subplot(1,4,1),
imshow(RGB),
title('Original Image');

%getting grayscale image
GRAY = rgb2gray(RGB);
subplot(1,4,2),
imshow(GRAY),
title('Gray Image');

% image threshold using Otsu's method
threshold = graythresh(GRAY);
BW = im2bw(GRAY, threshold);
subplot(1,4,3),
imshow(BW),
title('Binary Image');

%convert the image
BW = ~ BW;
subplot(1,4,4),
imshow(BW),
title('Inverted Binary Image');


[B,L] = bwboundaries(BW, 'noholes');

STATS = regionprops(L, 'all');
% we need 'BoundingBox' and 'Extent'
%Boundingbox is a property from regionprops.It's being stored in the structure STATS


% Classify Shapes according to properties

% Square = 3 = (1 + 2) = (X=Y + Extent = 1)
% Rectangular = 2 = (0 + 2) = (only Extent = 1)
% Circle = 1 = (1 + 0) = (X=Y , Extent < 1)
% UNKNOWN = 0



figure,
imshow(RGB),
title('Results');
hold on
for i = 1 : length(STATS)
  W(i) = uint8(abs(STATS(i).BoundingBox(3)-STATS(i).BoundingBox(4)) < 0.1);
  W(i) = W(i) + 2 * uint8((STATS(i).Extent - 1) == 0 );
  centroid = STATS(i).Centroid;
  switch W(i)
      case 1
          plot(centroid(1),centroid(2),'wO');
      case 2
          plot(centroid(1),centroid(2),'wX');
      case 3
          plot(centroid(1),centroid(2),'wS');
  end
end
return
