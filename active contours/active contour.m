clear all;
clc;
I = imread('tasbih.jpg');
I1=I;
%I = cat(3,I,I,I);
I = imresize(I,.4);
I = im2double(I);

[M N R] = size(I);


[X1,Y1] = getpts(get(imshow(I),'Parent'));
X = round(X1);
Y = round(Y1);

number = length(X);
X_n = X/N;
Y_n = Y/M;
iteration = 400;

volumn = zeros(M,N,3,iteration/10);

G = Grad(I);


threshold = length(X)/10;
move_num = 1000;


videopath = './hw5_q1_video.avi';
writerObj = VideoWriter(videopath);
open(writerObj);
num_frame=1;
while(move_num>threshold || iteration>0)
    [X,Y,move_num] = Dynamic(I , G , X , Y , M , N);
    X = circshift(X,1);
    Y = circshift(Y,1);
    iteration = iteration - 1;
    f = figure('visible','off');
    imshow(I);
    hold on               
    plot(X,Y,'G*');
    F = getframe(f);
    writeVideo(writerObj,F.cdata);
    close(f);
end

close(writerObj);

