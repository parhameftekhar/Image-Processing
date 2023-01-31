function [X1 , Y1 ,move_num]= Dynamic(Image , G , X , Y , M , N)
    
    move_num = 0;
    neighbor = [1 2 3 4 5;
                6 7 8 9 10;
                11 12 13 14 15;
                16 17 18 19 20;
                21 22 23 24 25;
               ];
           
    neighbor1 = [ 1 2 3;
                  4 5 6;
                  7 8 9];
              
    l = length(X);
    alpha = 100;
    beta = 1;
  
    
    Dynamic_matrix_E_accumulate = zeros(25, l-1);      
    Dynamic_matrix_root = zeros(25, l-1);
    
    
    d = sum(sqrt(((double(X) - circshift(double(X),1))/N).^2 + ((double(Y) - circshift(double(Y),-1))/M).^2))/length(X);
    %d=0;
    for i=1:l-1
        
        Vi1_X = X(i);
        Vi1_Y = Y(i);
        Vi2_X = X(i+1);
        Vi2_Y = Y(i+1);
       
        for a=1:25
            [row2,column2] = find(neighbor==a);
            row2 = row2 - 3;
            column2 = column2 - 3;
            N2_X = Vi2_X + column2;
            N2_Y = Vi2_Y + row2;
            Energy = 10^10;
            minimum = 0;
            
                        for b=1:25
                           [row1,column1] = find(neighbor==b);
                           row1 = row1 - 3;
                           column1 = column1 - 3;
                           N1_X = Vi1_X + column1;
                           N1_Y = Vi1_Y + row1;
                           E_ext = beta*G(N1_Y , N1_X);
                           %E_ext = Grad(Image , N1_Y , N1_X);                          
                           E_int = alpha*(((N2_X - N1_X)/N)^2 + ((N2_Y - N1_Y)/M)^2);
                           %E_int = alpha*(sqrt(((N2_X - N1_X)/N)^2 + ((N2_Y - N1_Y)/M)^2) - d)^2;
                           if i==1
                                if Energy > E_ext + E_int 
                                        Energy =  E_ext + E_int;
                                        minimum = b;                             
                                end
                           else
                               if Energy > E_ext + E_int + Dynamic_matrix_E_accumulate(b,i-1) 
                                        Energy =  E_ext + E_int + Dynamic_matrix_E_accumulate(b,i-1);
                                        minimum = b;                             
                                end
                               
                           end
                        end
                 
            Dynamic_matrix_E_accumulate(a,i) = Energy;                    
            Dynamic_matrix_root(a,i) = minimum;
                                                
        end  
        
    end
    
    [M,I] = min(Dynamic_matrix_E_accumulate(:,end));
    
    
    [row,column] = find(neighbor==I);
    row = row - 3;
    column = column - 3;
    X(l) = X(l) + column;
    Y(l) = Y(l) + row;
    
    
    index = zeros(l,1);
    index(l) = I;
    
    for j=l-1:-1:1
        index(j) = Dynamic_matrix_root(I,j);
        I = index(j);  
        [row,column] = find(neighbor==I);
        row = row - 3;
        column = column - 3;
        X(j) = X(j) + column;
        Y(j) = Y(j) + row;
        if row~=0 || column~=0
           move_num = move_num + 1; 
        end
    end
    
    X1 = X;
    Y1 = Y;
    %Dynamic_matrix_root
    
end