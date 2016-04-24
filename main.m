function main(directory,root,idx1,idx2)
    F_update = [1 0 1 0; 0 1 0 1; 0 0 1 0; 0 0 0 1];

    Npop_particles = 400;%4000;

    Xstd_rgb = .05;
    Xstd_pos = 25;
    Xstd_vec = 5;

    trgt = 1;
    objects=3;

    templates={'template2.mat','template3.mat','template4.mat'};
    %%
    if strcmp(root,'liptracking2')
        load(templates{1});
    elseif strcmp(root,'liptracking3')
        load(templates{2});
    elseif strcmp(root,'liptracking4')
        load(templates{3});      
    else
        disp('the root name must be liptracking*, I need this to indicate which template to use!');
    end
    %% particles
    for i=1:objects
        particles{i}=create_particles(y(i,:),x(i,:),Npop_particles);
        [objectx{i},objecty{i}] = snakeinterp(x(i,:),y(i,:),2,0.5);
        bound{i}=[mean(particles{i}(2,:)),...
        std(particles{i}(2,:)),...
        mean(particles{i}(1,:)),...
        std(particles{i}(1,:))];
    end


    outputVideo = VideoWriter([root,'.avi']);
    outputVideo.FrameRate = 24;
    open(outputVideo)

    resize = 1;
    
    start_frame=idx1;
    end_frame=idx2;

    boundscale=1;
    color=['b','y','r'];
            %image processing
        dir=fullfile(directory,[root,'_',num2str(start_frame,'%05d'),'.jpg']);
        raw_img=imread(dir);
        raw_img=im2double(raw_img);
        img=rgb2hsv(raw_img);
        img=img(:,:,1);
             
    %% processing
    for frame=start_frame:end_frame
        %image processing
        dir=fullfile(directory,[root,'_',num2str(frame,'%05d'),'.jpg']);
        raw_img=imread(dir);
        raw_img=im2double(raw_img);
        img=rgb2hsv(raw_img);
        img=img(:,:,1);
        gray_img=rgb2gray(raw_img);
        %thresh
%         img=img>.95;
        [brightx,brighty]=find(img>.9);
        imshow(img>.95)

        
        for i=1:objects
            % Forecasting
            particles{i} = update_particles(F_update, Xstd_pos, Xstd_vec, particles{i});

            for iter=1:1
                % raw_img=img;
                particlecenter_x=mean(particles{i}(2,:));
                particlecenter_y=mean(particles{i}(1,:));
                particlestd_x=std(particles{i}(2,:));
                particlestd_y=std(particles{i}(1,:));

                centerx=mean(brightx((brightx>particlecenter_x-boundscale*particlestd_x) & ...
                        (brightx<particlecenter_x+boundscale*particlestd_x)));
                centery=mean(brighty((brighty>particlecenter_y-boundscale*particlestd_y) & ...
                        (brighty<particlecenter_y+boundscale*particlestd_y)));
                particles{i}(2,:)=particles{i}(2,:)+centerx-particlecenter_x;
                particles{i}(1,:)=particles{i}(1,:)+centery-particlecenter_y;
            end
            % Calculating Log Likelihood
            L = calc_log_likelihood(Xstd_rgb, trgt, particles{i}(1:2, :), img);

            % Resampling
            particles{i} = resample_particles(particles{i}, L);
            
            hold on
%             disp([particlecenter_x,particlecenter_y,particlestd_x,particlestd_y]);
%             disp([centerx,centery]);
            scatter(centerx,centery,['o',color(i)]);
            
            if false
             meanx=mean(objectx{i}(:));
             meany=mean(objecty{i}(:));

             lam=1.5;
             objectx{i} =particlecenter_x+...
                lam*particlestd_x*(objectx{i}-meanx)/std(objectx{i}(:));  
             objecty{i} =particlecenter_y+...
                lam*particlestd_y*(objecty{i}-meany)/std(objecty{i}(:));

            [objectx{i},objecty{i}] = snakeinterp(objectx{i},objecty{i},2,.5);
            [objectx{i},objecty{i}]=snake(gray_img,objectx{i},objecty{i},3,1);
             
            end
        end

        for i=1:objects
                        % Showing Image
             hold on
             plot(particles{i}(2,:), particles{i}(1,:), ['.',color(i)])
%             hold off
%             snakedisp(objectx{i},objecty{i},'green')        
            
            
        end
        
        
        writeVideo(outputVideo,getframe);
    end
    close(outputVideo);

