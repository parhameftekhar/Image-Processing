clear all;
clc;
tic

h = waitbar(0,'Please wait...');

original = imread('sea.jpg');
original = original(1:480,1:640,:);
mask_original = imread('mask.png');
mask = uint8(mask_original);

original = imresize(original,1);

mask = imresize(mask,1);


e = 1- cat(3,mask,mask,mask);
original = original.*e;
target = original;
imshow(target);
%%
[m,n,r] = size(original);
neighbor_size = 9;
[mask_r,mask_c] = find(mask);
priority = ones(m , n)*-1;
useful = zeros(m,n);



w = (neighbor_size + 1)/2;
v = (neighbor_size - 1)/2;
for i=w:(n-w)
       for j=w:(m-w)
               a =  mask(j - v:j + v,i - v:i + v );
               if(max(max(a))==0)                   
                   useful(j,i) = 1;
               end              
       end
end









priority1 = (1-mask).*-1;
priority2 = conv2(1-mask,ones(neighbor_size));
priority2 = priority2(w:end-w+1,w:end-w+1);
priority2 = uint8(priority2).*mask;
priority1 = priority1 + priority2;

%[M,I] = max(A(:));
%[I_row, I_col] = ind2sub(size(A),I);
ssd = 0;

patch1_r = 0;
patch1_g = 0;
patch1_b = 0;

patch2_r = 0;
patch2_g = 0;
patch2_b = 0;




M = 0;
index_r = 0;
index_c = 0;

best_r = 0;
best_c = 0;
c = 100;
%sum(sum(find(mask)))
 %sum(sum(find(priority)))

original_r = original(:,:,1);
original_g = original(:,:,2);
original_b = original(:,:,3);
while(true)
    
   
    [M,index] = max(priority1(:));
    [index_r, index_c] = ind2sub(size(priority1),index);
    
    patch1_r = target(index_r - v:index_r + v,index_c - v:index_c + v,1);
    patch1_g = target(index_r - v:index_r + v,index_c - v:index_c + v,2);
    patch1_b = target(index_r - v:index_r + v,index_c - v:index_c + v,3);   
   
    r1 = conv2(double(original_r).^2,double(rot90(1-mask(index_r - v:index_r + v,index_c - v:index_c + v),2)));
    r2 = conv2(double(original_r),rot90(double(patch1_r),2))*2;
    r3 = conv2(double(ones(m,n)),rot90(double(patch1_r).^2,2));
    ssd_r = r1 + r3 - r2;
    
    
    
    g1 = conv2(double(original_g).^2,double(rot90(1-mask(index_r - v:index_r + v,index_c - v:index_c + v),2)));
    g2 = conv2(double(original_g),rot90(double(patch1_g),2))*2;
    g3 = conv2(double(ones(m,n)),rot90(double(patch1_g).^2,2));
    ssd_g = g1 + g3 - g2;
    
    
    b1 = conv2(double(original_b).^2,double(rot90(1-mask(index_r - v:index_r + v,index_c - v:index_c + v),2)));
    b2 = conv2(double(original_b),rot90(double(patch1_b),2))*2;
    b3 = conv2(double(ones(m,n)),rot90(double(patch1_b).^2,2));
    ssd_b = b1 + b3 - b2;
    
    
    ssd = ssd_r + ssd_b + ssd_g;
    
    ssd = ssd(w:end-w+1,w:end-w+1);
    ssd = ssd.*useful;
    
    
    
    [i1,j1]=find(ssd==min(ssd(ssd > 0)));
    
    best_c = j1(1,1);
    best_r = i1(1,1);
    
    
   
    target(index_r - v:index_r + v,index_c - v:index_c + v,1) = target(index_r - v:index_r + v,index_c - v:index_c + v,1) +  mask(index_r - v:index_r + v,index_c - v:index_c + v).*original(best_r - v:best_r + v,best_c - v:best_c + v,1);
    target(index_r - v:index_r + v,index_c - v:index_c + v,2) = target(index_r - v:index_r + v,index_c - v:index_c + v,2) +  mask(index_r - v:index_r + v,index_c - v:index_c + v).*original(best_r - v:best_r + v,best_c - v:best_c + v,2);
    target(index_r - v:index_r + v,index_c - v:index_c + v,3) = target(index_r - v:index_r + v,index_c - v:index_c + v,3) +  mask(index_r - v:index_r + v,index_c - v:index_c + v).*original(best_r - v:best_r + v,best_c - v:best_c + v,3);    
    mask(index_r - v:index_r + v,index_c - v:index_c + v) = zeros(neighbor_size,neighbor_size);
    
    priority1 = (1-mask).*-1;
    priority2 = conv2(1-mask,ones(neighbor_size));
    priority2 = priority2(w:end-w+1,w:end-w+1);
    priority2 = uint8(priority2).*mask;
    priority1 = priority1 + priority2;


    
    
    %figure;
    
    
 
    
    if max(priority1(:))==0
        break; 
    end 
    
    
  %  sum(sum(find(mask)))
  %  sum(sum(find(priority)))
    
    %c = c - 1;
    if c==0
        break;
    end
end

imshow(target);

 toc

close(h)


