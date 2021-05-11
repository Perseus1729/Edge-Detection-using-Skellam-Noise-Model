function y=trans(I_all,slope1,c1,slope2,c2)
    
    Img_mu1=(I_all.*slope1+c1);
    Img_mu2=(I_all.*slope2+c2);
    alpha=0.99;
    
    y = ones(256, 1)*255;
    for i= 1:256
        mu1=Img_mu1(i);
        mu2=Img_mu2(i);
        x=pmf(mu1,mu2,0);
        for j = 1:255
            if x < alpha
                x = x + pmf(mu1,mu2,j) + pmf(mu1,mu2,-j);         
            else
                y(i) = j;
                break
            end
        end
    end
    
end