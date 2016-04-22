function main(directory,root,idx1,idx2)
    F_update = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

    Npop_particles = 400;%4000;

    Xstd_rgb = .05;
    Xstd_pos = 25;
    Xstd_vec = 5;

    trgt = 1;

    templates={'template.mat','template3.mat','template4.mat'};
    %%
    if strcmp(root,'liptracking2')
        load(templates{1});
    elseif strcmp(root,'liptracking3')
        load(templates{3});
    elseif strcmp(root,'liptracking4')
        load(templates{4});      
    else
        disp('the root name must be liptracking*, I need this to indicate which template to use!');
    end
    % particles
    particles=create_particles(y,x,Npop_particles);
    [x,y] = snakeinterp(x,y,2,0.5);

    outputVideo = VideoWriter([dir_name,'.avi']);
    outputVideo.FrameRate = 24;
    open(outputVideo)

    resize = 1;
    
    start_frame=idx1;
    end_frame=idx2;
    
    % t = 0:0.05:6.28;
    for frame=start_frame:end_frame
        dir=fullfile(directory,[root,'_',num2str(frame,'%05d'),'.jpg']);
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

