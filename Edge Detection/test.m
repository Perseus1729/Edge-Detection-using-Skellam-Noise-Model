%% Create image with edges
sz = 512;
img = zeros([sz sz 3], 'uint8');
n = 8;
t = sz/n;
for rows = 0:(n-1)
    for cols = 0:(n-1)
        T = zeros(t, t, 3);
        for i = 1:3
            T(:,:,i) = T(:,:,i) + randi(255);
        end
        T = insertShape(T, "Rectangle", [1 1 t t], "LineWidth", 3);
        img(rows*t + 1:(rows + 1)*t ,cols*t + 1:(cols + 1)*t, :) = T;
        
    end
end

%% Adding objects
colors = ["red" "yellow" "green" "blue" "black" "cyan" "magenta"];
for i = 1:randi(4)
    if randi(3) == 1
        img = insertShape(img, "Polygon", randi(sz, [2*randi(3) + 6 1])', "LineWidth", 5, "Color", colors(randi(7)));
    else
        x = randi(sz, [2*randi(3) + 6 1])';
        img = insertShape(img, "FilledPolygon", x, "Color", colors(randi(7)));  
        img = insertShape(img, "Polygon", x, "LineWidth", 2, "Color", "black");
    end
end

%% Noise addition
img = imnoise(img, 'poisson');
A = figure;
imshow(img);
imwrite(img, "Tests/" + (randi(255)) + ".tiff");