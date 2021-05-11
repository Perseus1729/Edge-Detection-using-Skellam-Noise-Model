%% Image generate for Skellam estimation
rng(124);
sz = 512;
img3 = zeros([sz sz 3], 'uint8');
n = 8;
t = sz/n;
for rows = 0:(n-1)
    for cols = 0:(n-1)
        for i = 1:3
            T = img3(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, i) + randi(255);
            img3(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, i) = T;
        end
    end
end

%% Noise addition

img3 = imnoise(img3, 'poisson');
A = figure;
imshow(img3);
imwrite(img3, "Patches/" + (randi(255)) + ".tiff");