clear;
rng(1,'philox')

% %% Image generate for Skellam estimation
% sz = 512;
% img3 = zeros([sz sz 3], 'uint8');
% n = 8;
% t = sz/n;
% for rows = 0:(n-1)
%     for cols = 0:(n-1)
%         for i = 1:3
%             T = img3(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, i) + randi(205);
%             img3(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, i) = T;
%         end
%     end
% end
% 
% %% Noise addition
% 
% img3 = imnoise(img3, 'poisson');
% % A = figure;
% % imshow(img3);
% % imwrite(img3, "Patches/" + (randi(255)) + ".tiff");

%% Load image
img = double(imread("pic2.png"));
% img = double(img3);
[m, n, ~]= size(img);
L = 20;
dx = 1; dy = 1;
no_patches = 24;
no_channels = 3;

%% Calculate Skellam parameters for homogenous patches
patch_M = zeros(no_patches, no_channels);
differ = zeros(L - dx, L - dy, no_channels);
M = zeros(no_patches, no_channels);
V = zeros(no_patches, no_channels);
for i = 0:3
    for j = 0:5
        c = i*6 + j + 1;
        % crop = img(randi(n-L+1)+(0:L-1),randi(m-L+1)+(0:L-1), :);
        I = i*50 + 10;
        J = j*50 + 10;
        crop = img( I : I + L, J : J + L, :);
%         figure;
%         imshow(uint8(crop));
        patch_M(c, :) = mean(crop(:, :, :), [1 2]);
        differ(:, :, :) = crop(1: L - dx, 1: L - dy, :) - crop(dx + 1 : L, dy + 1 : L, :);
        M(c, :) = mean(differ(:, :, :), [1 2]);
%         for k = 1:3
%             new(:,:) = M(c,k) - differ(:,:,k);
%             V(c, k) = mean(new(:,:).^2, 'all');
%         end
        V(c, :) = var(differ(:, :, :), 1, [1 2]); 
%         V(c, :) == W(c, :)
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
 colors = ['r' 'g' 'b'];
 for i = 1:3   
     figure;
     histogram(differ( :, :, i));
 end
 for i = 1:3
     figure;
     scatter(patch_M(:, i), mu1(:,i), '.', colors(i));
     hold on;
     vec = reshape(fit(1, i, :), [1 2]); 
     y = polyval(vec, patch_M(:,i));
     plot(patch_M(:,i), y, colors(i));
 end

%% Find confidence intervals for 90% for each distribution
all = repmat(0:255,[3,1])';
intervals = zeros(256,3);
img = double(imread("bg_sub_sample.png"));
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
e = zeros(m-2, n-2, 'double');
indices = e_x(:,:,1) > 0 | e_x(:,:,2) > 0| e_x(:,:,3) > 0| e_y(:,:,1) > 0| e_y(:,:,2) > 0| e_y(:,:,3) > 0;
e(indices) = sum(indices);
% Primitive detection via noise
figure;
imshow(e);
% Canny edge detection
figure;
edge(rgb2gray(img), "canny");
% Non-maximum suppression
e=e>0;
s=circshift(e,1,1)+circshift(e,-1,1)+circshift(e,1,2)+circshift(e,-1,2)+circshift(e,[1,1])+circshift(e,[1,-1])+circshift(e,[-1,1])+circshift(e,[-1,-1]);
s=s/8;
k=(e-s)>0;
figure;
imshow(k);