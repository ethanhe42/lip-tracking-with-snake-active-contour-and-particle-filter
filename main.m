% import multi images, and use snake function



load('template3.mat');
[x,y] = snakeinterp(x,y,2,0.5);

dir_name='liptracking3';

outputVideo = VideoWriter([dir_name,'.avi']);
outputVideo.FrameRate = 24;
open(outputVideo)

resize = 1;
%%2
% start_frame=1302;
% end_frame=1910;
%3
start_frame=1295;
end_frame=1928;
dir=['./',dir_name,'/',dir_name,'_',num2str(start_frame,'%05d'),'.jpg'];
frame_size=size(imread(dir));

t = 0:0.05:6.28;
for frame=start_frame:end_frame
    dir=['./',dir_name,'/',dir_name,'_',num2str(frame,'%05d'),'.jpg'];
    % use full file next time
    img=imread(dir);
    imshow(img)
    img=im2double(img);
    img=rgb2hsv(img);
    img=img(:,:,1);
    
    
    % raw_img=img;
    if length(size(img))==3
        img=rgb2gray(img);
    end
%     oldx=x;
%     oldy=y;

     meanx=mean(x);
     meany=mean(y);
     enlarge=.5;
     x = x + enlarge*(x-meanx);  
     y = y + enlarge*(y-meany);
     [x,y] = snakeinterp(x,y,2,.5);
     
     [x,y]=snake(img,x,y,5,1);
     snakedisp(x,y,'y')
%     disp(sum((oldx-x).^2)/length(x))
     
        



    
    writeVideo(outputVideo,getframe);

    
    disp(frame)
end
close(outputVideo);

