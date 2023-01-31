%%clear all;
clc;
I1 = imread('man1.jpg');
I2 = imread('man2.jpg');
I1 = im2double(I1);
I2 = im2double(I2);

[m1,n1,r1] = size(I1);
[m2,n2,r2] = size(I2);
m = min(m1,m2);
n = min(n1,n2);
I1 = I1(1:m,1:n,:);
I2 = I2(1:m,1:n,:);


[p2, p1] = cpselect(I2, I1,'Wait', true);

p1 = [p1; 0, 0; 0, m; n, m; n, 0];
p2 = [p2; 0, 0; 0, m; n, m; n, 0];

p1=round(p1);
p2=round(p2);
triangles = delaunay(p1(:,1),p1(:,2));
segment = zeros(m,n);

[XX, YY] = meshgrid( 1:n, 1:m );
V_xx = XX(:);
V_yy = YY(:);

mask_1D_1 = zeros(m*n,1);
mask_1D_2 = zeros(m*n,1);



for i = 1:size(triangles,1)
    in_trig = inpolygon( V_xx, V_yy,...
        [p1(triangles(i,1),1) p1(triangles(i,2),1) p1(triangles(i,3),1)],[p1(triangles(i,1),2) p1(triangles(i,2),2) p1(triangles(i,3),2)] );
    mask_1D_1( in_trig ) = i;
    in_trig = inpolygon( V_xx, V_yy,...
        [p2(triangles(i,1),1) p2(triangles(i,2),1) p2(triangles(i,3),1)],[p2(triangles(i,1),2) p2(triangles(i,2),2) p2(triangles(i,3),2)] );
    mask_1D_2( in_trig ) = i;
end

mask1 = reshape(mask_1D_1, m, n);
mask2 = reshape(mask_1D_2, m, n);




         
            
frame_t = double(zeros(m,n,3));

t = 0:0.02:1;

volumn = double(zeros(m-50,n,3,51));


for i=1:51
    points_t = round(round(p1*t(i) + p2*(1-t(i))));
    
    [XX, YY] = meshgrid( 1:n, 1:m );
    V_xx = XX(:);
    V_yy = YY(:);
    mask_1D_t = zeros(m*n,1);
    for j = 1:size(triangles,1)
        in_trig = inpolygon( V_xx, V_yy,...
            [points_t(triangles(j,1),1) points_t(triangles(j,2),1) points_t(triangles(j,3),1)],[points_t(triangles(j,1),2) points_t(triangles(j,2),2) points_t(triangles(j,3),2)] );
        mask_1D_t( in_trig ) = j;
    end
    region_t = reshape(mask_1D_t, m, n);
    backTransform_1 = zeros( 3, 3, size(triangles,1) );
    backTransform_2 = zeros( 3, 3, size(triangles,1) );
    for j=1:size(triangles,1)
        par_j_1 = affine_par(points_t(triangles(j,1),:) , points_t(triangles(j,2),:) , points_t(triangles(j,3),:) ,...
            p1(triangles(j,1),:) , p1(triangles(j,2),:) , p1(triangles(j,3),:));
        par_j_2 = affine_par(points_t(triangles(j,1),:) , points_t(triangles(j,2),:) , points_t(triangles(j,3),:) ,...
            p2(triangles(j,1),:) , p2(triangles(j,2),:) , p2(triangles(j,3),:));
        trans_matrix1 = [par_j_1(1) par_j_1(2) par_j_1(5);
                         par_j_1(3) par_j_1(4) par_j_1(6);
                         0       0       1      ];
         
        trans_matrix2 = [par_j_2(1) par_j_2(2) par_j_2(5);
                         par_j_2(3) par_j_2(4) par_j_2(6);
                         0       0       1      ];
          
        backTransform_1(:,:,j) = trans_matrix1;             
        backTransform_2(:,:,j) = trans_matrix2;
    end
    for r=1:m
        for c=1:n
            warp_point_1 = backTransform_1(:,:,region_t(r,c))*[c;r;1] ; 
            warp_point_2 = backTransform_2(:,:,region_t(r,c))*[c;r;1];   
            warp_point_1(1) = max(warp_point_1(1) , 1);
            warp_point_1(1) = min(warp_point_1(1) , m);
            warp_point_2(1) = max(warp_point_2(1) , 1);
            warp_point_2(1) = min(warp_point_2(1) , m);
            
            
            warp_point_1(2) = max(warp_point_1(2) , 1);
            warp_point_1(2) = min(warp_point_1(2) , n);
            warp_point_2(2) = max(warp_point_2(2) , 1);
            warp_point_2(2) = min(warp_point_2(2) , n);
            if region_t(r,c)~=mask1(round(warp_point_1(1)),round(warp_point_1(2)))
                %disp('adw');
                %r
                %c
                %region_t
                
            end
            frame_t(r,c,:) = I1(round(warp_point_1(2)),round(warp_point_1(1)),:)*t(i) + I2(round(warp_point_2(2)),round(warp_point_2(1)),:)*(1-t(i));
        end
        
    end
    if i==25
       imshow(frame_t); 
    end
    spec = ['./frames/morph_%0', num2str(floor(log10(51)+1)), 'd.png'];
    filepath = sprintf( spec, i );
    imwrite( frame_t, filepath, 'png' );
    volumn(:,:,:,i) = (frame_t(1:end-50,:,:));
end
%%
mov = immovie(volumn);
implay(mov);


videopath = './output/Morph.avi';
writerObj = VideoWriter(videopath);
open(writerObj);
writeVideo(writerObj,mov);
close(writerObj);