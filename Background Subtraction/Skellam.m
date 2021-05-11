clear;
rng(11);

%% Image generate for Skellam estimation    
sz = 512;
img = zeros([sz sz 3], 'uint8');
n = 8;
t = sz/n;
for rows = 0:(n-1)
    for cols = 0:(n-1)
        for i = 1:3
            T = img(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, i) + randi(255);
            img(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, i) = T;
        end
    end
end

img2 = img;
x = randi(400, 2);
img2(x(1) : x(1) + 100, x(2) : x(2) + 50, :) = 0;

%% Noise addition

img = imnoise(img, 'poisson');
img2 = imnoise(img2, 'poisson');
figure;
imshow(img);
title("Original Image");
figure;
imshow(img2);
title("Image with Object");
x = randi(255);
imwrite(img, "Results/Train.png");
imwrite(img2, "Results/Test.png");

%% Load image
img = double(img);
[m, n, ~]= size(img);
L = 32;
dx = 1; dy = 1;
no_patches = 64;
no_channels = 3;

%% Calculate Skellam parameters for homogenous patches
patch_M = zeros(no_patches, no_channels);
differ = zeros(L - dx, L - dy, no_channels);
M = zeros(no_patches, no_channels);
V = zeros(no_patches, no_channels);
for i = 0:7
    for j = 0:7
        c = i*8 + j + 1;
        I = i*64 + 16;
        J = j*64 + 16;
        crop = img( I : I + L, J : J + L, :);
        patch_M(c, :) = mean(crop(:, :, :), [1 2]);
        differ(:, :, :) = crop(1: L - dx, 1: L - dy, :) - crop(dx + 1 : L, dy + 1 : L, :);
        M(c, :) = mean(differ(:, :, :), [1 2]);
        V(c, :) = var(differ(:, :, :), 1, [1 2]); 
    end
end

mu1 = (M + V)/2;
mu2 = (-M + V)/2;
fit = zeros(2,3,2);
for i=1:3
    fit(1,i,:) = polyfit(patch_M(:,i), mu1(:, i), 1);
    fit(2,i,:) = polyfit(patch_M(:,i), mu2(:, i), 1);
end

%% Plot graphs
 Colors = ["red" "green" "blue"];
 colors = ['r' 'g' 'b'];
 for i = 1:3   
     A = figure;
     histogram(differ( :, :, i));
     title("Histogram of Intensity Difference in " + Colors(i));
     xlabel("Intensity Difference values");
     ylabel("Number of pixels");
     saveas(A, "Results/Histogram for " + Colors(i) + ".png");
 end
 for i = 1:3
     A = figure;
     scatter(patch_M(:, i), mu1(:,i), '.', colors(i));
     hold on;
     vec = reshape(fit(1, i, :), [1 2]); 
     y = polyval(vec, patch_M(:,i));
     plot(patch_M(:,i), y, colors(i));
     title("Skellam Parameters and Mean Plot for " + Colors(i));
     xlabel("Mean Intensity of Patch");
     ylabel("Skellam Parameter (mu1)");
     saveas(A, "Results/Linear_fit for " + Colors(i) + ".png");
 end

%% Find confidence intervals for 90% for each distribution
all = repmat(0:255,[3,1])';
intervals = zeros(256,3);
img2 = double(img2);
img1 = zeros(m, n, 3);
for i = 1:3
    intervals(:,i) = trans(all(:,i), fit(1,i,1), fit(1,i,2), fit(2,i,1), fit(2,i,2));
    img1(:,:, i) = reshape(intervals( img(:, :, i) + 1, i), [m n]);
end

%% Background Subtraction
g = abs(img - img2);
e = (g ./ img1 - 1);
sum = sum(e, 3);

%% No Non-Maximum Supression
E = zeros(m, n, 'double');
indices = e(:,:,1) > 0 | e(:,:,2) > 0| e(:,:,3) > 0;
E(indices) = sum(indices);

A = figure;
imshow(E);
title("Background Subtraction");
saveas(A, "Results/object.png");
