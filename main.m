sequence = 2;

F_update = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

Npop_particles = 400;%4000;

Xstd_rgb = .05;
Xstd_pos = 25;
Xstd_vec = 5;

trgt = 1;
samples={{'template3.mat','liptracking3',1295,1928},...
         {'template.mat','liptracking2',1302,1910},...
         {'template4.mat','liptracking4',68,338},...
         {}};
video=samples{sequence};
%%

load(video{1});
% particles
particles=create_particles(y,x,Npop_particles);
[x,y] = snakeinterp(x,y,2,0.5);


dir_name=video{2};x

outputVideo = VideoWriter([dir_name,'.avi']);
outputVideo.FrameRate = 24;
open(outputVideo)

resize = 1;
%%2
% start_frame=1302;
% end_frame=1910;
%3
start_frame=video{3};
end_frame=video{4};
dir=['./',dir_name,'/',dir_name,'_',num2str(start_frame,'%05d'),'.jpg'];
frame_size=size(imread(dir));
particle_var=zeros(size(1,end_frame-start_frame+1));
% t = 0:0.05:6.28;
for frame=start_frame:end_frame
    dir=['./',dir_name,'/',dir_name,'_',num2str(frame,'%05d'),'.jpg'];
    % use full file next time
    raw_img=imread(dir);
    
    raw_img=im2double(raw_img);
    img=rgb2hsv(raw_img);
    img=img(:,:,1);
    
    imshow(raw_img)
    % Forecasting
    particles = update_particles(F_update, Xstd_pos, Xstd_vec, particles);
    
    % Calculating Log Likelihood
    L = calc_log_likelihood(Xstd_rgb, trgt, particles(1:2, :), img);
    
    % Resampling
    particles = resample_particles(particles, L);

    % Showing Image
%     hold on
%     plot(particles(2,:), particles(1,:), '.')
%     hold off

    % raw_img=img;
    
    gray_img=rgb2gray(raw_img);

%     oldx=x;
%     oldy=y;
    if true
     meanx=mean(x(:));
     meany=mean(y(:));
%      particle_var(1,frame-start_frame+1)=...
%          (std(particles(1,:))+std(particles(2,:)));
%     disp(particle_var)
     lam=1.5;
     x =mean(particles(2,:))+...
     lam*std(particles(2,:))*(x-meanx)/std(x(:));  
     y =mean(particles(1,:))+...
         lam*std(particles(1,:))*(y-meany)/std(y(:));
    
    [x,y] = snakeinterp(x,y,2,.5);
     
     [x,y]=snake(gray_img,x,y,3,1);
     snakedisp(x,y,'green')
    end
    writeVideo(outputVideo,getframe);
end
close(outputVideo);
% drawnow
% plot(particle_var);
% drawnow

