function [magnitude]= Grad(Image)
    [m n r] = size(Image);
    magnitude = zeros(m , n);
    
    
    R = Image(:,:,1);
    G = Image(:,:,2);
    B = Image(:,:,3);
    G_r = 0;
    G_g = 0;
    G_b = 0;
    
    
    for i=1:m-1
        for j=1:n-1
            G_r = ((R(i , j) - R(i + 1 , j))^2  + (R(i , j) - R(i , j + 1))^2);
            G_g = ((G(i , j) - G(i + 1 , j))^2  + (G(i , j) - G(i , j + 1))^2);
            G_b = ((B(i , j) - B(i + 1 , j))^2  + (B(i , j) - B(i , j + 1))^2);
            magnitude(i,j) = -max([G_r G_g G_b]);        
 
        end
    end

end