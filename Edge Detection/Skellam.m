clear;
rng(1,'philox')

%% Load image
img = double(imread("Patches/217.tiff"));
[m, n, ~] = size(img);
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
img = double(imread("Tests/177.tiff"));

img1 = zeros(m, n, 3);
for i = 1:3
    intervals(:,i) = trans(all(:,i), fit(1,i,1), fit(1,i,2), fit(2,i,1), fit(2,i,2));
    img1(:,:, i) = reshape(intervals( img(:, :, i) + 1, i), [m n]);
end

%% Edge detection
g_y = abs(img(1:m-2, 2:n-1, :) - img(3:m, 2:n-1, :));
g_x = abs(img(2:m-1, 1:n-2,:) - img(2:m-1, 3:n, :));
e_x = (g_x ./ img1(2:m-1, 2:n-1, :)) - 1;
e_y = (g_y ./ img1( 2:m-1, 2:n-1, :)) - 1;

sum = sum(e_x, 3) + sum(e_y, 3);

%% No Non-Maximum Supression
e = zeros(m-2, n-2, 'double');
indices = e_x(:,:,1) > 0 | e_x(:,:,2) > 0| e_x(:,:,3) > 0| e_y(:,:,1) > 0| e_y(:,:,2) > 0| e_y(:,:,3) > 0;
e(indices) = sum(indices);

A = figure;
imshow(e);
title("Edge Detection without NMS");
saveas(A, "Results/no_NMS.png");

%% Non Maximum Supression
e = e > 0;
s = circshift(e,1,1)+circshift(e,-1,1)+circshift(e,1,2)+circshift(e,-1,2)+circshift(e,[1,1])+circshift(e,[1,-1])+circshift(e,[-1,1])+circshift(e,[-1,-1]);
s = s/8;
k=(e-s)>0;

A = figure;
imshow(k);
title("Edge Detection with NMS");
saveas(A, "Results/NMS.png");