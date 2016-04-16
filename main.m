% import multi images, and use snake function



load('template.mat');
[x,y] = snakeinterp(x,y,2,0.5);

dir_name='liptracking2';

outputVideo = VideoWriter([dir_name,'.avi']);
outputVideo.FrameRate = 24;
open(outputVideo)

resize = 1;
start_frame=1302;
end_frame=1910;
dir=['./',dir_name,'/',dir_name,'_',num2str(start_frame,'%05d'),'.jpg'];
frame_size=size(imread(dir));
for frame=start_frame:end_frame
    dir=['./',dir_name,'/',dir_name,'_',num2str(frame,'%05d'),'.jpg'];
    % use full file next time
    img=imread(dir);

    
    
    imshow(img)
    % raw_img=img;
    if length(size(img))==3
        img=rgb2gray(img);
    end
%     oldx=x;
%     oldy=y;
     [x,y]=snake(img,x,y,3,10);
     snakedisp(x,y,'y*')
%     disp(sum((oldx-x).^2)/length(x))
    [x,y] = snakeinterp(x,y,2,.5);
    
    writeVideo(outputVideo,getframe);

    
    disp(frame)
end
close(outputVideo);

