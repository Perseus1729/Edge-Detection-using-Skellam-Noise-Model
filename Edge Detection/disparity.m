img = double(imread("Patches/107.tiff"));
patch = img(1:64,1:64,:);
u1r = zeros(1,10);
u1g = zeros(1,10);
u1b = zeros(1,10);
u2r = zeros(1,10);
u2g = zeros(1,10);
u2b = zeros(1,10);
L = 64;
m = 10;
for disp = 1:m
    differ = patch(1: L - disp, 1: L - disp, :) - patch(disp + 1 : L, disp + 1 : L, :);
    patch_M = mean(patch(:, :, :), [1 2]);
    M = mean(differ(:, :, :), [1 2]);
    V = var(differ(:, :, :), 1, [1 2]); 
    u1 = (M+V)/2;
    u2 = (-M+V)/2;
    u1r(disp) = u1(1);
    u1g(disp) = u1(2);
    u1b(disp) = u1(3);
    u2r(disp) = u2(1);
    u2g(disp) = u2(2);
    u2b(disp) = u2(3);
end

A = figure;
plot(1:m,u1r,'-xr'); hold on;
plot(1:m,u1g,'-xg');
plot(1:m,u1b,'-xb'); hold off;
title("Disparity Plot(u1)")
xlabel("Disparity Value", "HorizontalAlignment","left");
ylabel("Skellam Parameter (u1)");
saveas(A, "Results/Disparity_Plot(u1).png");
A = figure;
plot(1:m,u2r,'-xr'); hold on;
plot(1:m,u2g,'-xg');
plot(1:m,u2b,'-xb'); hold off;
title("Disparity Plot(u2)")
xlabel("Disparity Value", "HorizontalAlignment","left");
ylabel("Skellam Parameter (u2)");
saveas(A, "Results/Disparity_Plot(u2).png");