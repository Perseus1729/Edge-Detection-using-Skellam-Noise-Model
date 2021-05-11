%% Plots the confidence intervals 

Tmin = min(intervals(:,1);
Tmax = max(intervals(:,1);
rol = zeros(Tmax);

% Find confidence intervals
for i = Tmin:Tmax
    for j = 1:256
        if(intervals(j,1) == i)
            rol(i) = j;
        end
    end
end

% Plot the figure
figure;
for i = Tmin:Tmax
    plot([max(0, rol(i) - i) min(255, rol(i) + i)], [i i], 'b', "LineWidth", 0.5);
    hold on;
end
title("Ia vs Intensity");
xlabel("Intensity values");
ylabel("Difference allowed");