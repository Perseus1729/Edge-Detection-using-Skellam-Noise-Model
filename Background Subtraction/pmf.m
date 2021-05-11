%% Calculates the PMF of the Skellam distribution for the input parameters
function f=pmf(mu1,mu2,k)
    M_0=2*((mu1*mu2)^(1/2));
    f = (exp(-(mu1+mu2))*((mu1/mu2)^(k/2)))*besseli(k,M_0); 
end