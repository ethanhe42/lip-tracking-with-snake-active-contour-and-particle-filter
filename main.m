% import multi images, and use snake function
%% particle Parameters

F_update = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

Npop_particles = 400;%4000;

Xstd_rgb = .05;
Xstd_pos = 25;
Xstd_vec = 5;

trgt = 1;

%%
load('template3.mat');
% particles
particles=create_particles(y,x,Npop_particles);
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
    
    img=im2double(img);
    img=rgb2hsv(img);
    img=img(:,:,1);
    disp(max(img(:)))
    imshow(img)
    % Forecasting
    particles = update_particles(F_update, Xstd_pos, Xstd_vec, particles);
    
    % Calculating Log Likelihood
    L = calc_log_likelihood(Xstd_rgb, trgt, particles(1:2, :), img);
    
    % Resampling
    particles = resample_particles(particles, L);

    % Showing Image
    hold on
    plot(particles(2,:), particles(1,:), '.')
    hold off

    % raw_img=img;
    
    %grey don't use this
%     if length(size(img))==3
%         img=rgb2gray(img);
%     end


%     oldx=x;
%     oldy=y;

%      meanx=mean(x);
%      meany=mean(y);
%      enlarge=.5;
%      x = x + enlarge*(x-meanx);  
%      y = y + enlarge*(y-meany);
    
    [x,y] = snakeinterp(x,y,2,.5);
     
     [x,y]=snake(img,x,y,5,1);
     snakedisp(x,y,'y')
%     disp(sum((oldx-x).^2)/length(x))
     
        



    
    writeVideo(outputVideo,getframe);

    
    disp(frame)
end
close(outputVideo);

