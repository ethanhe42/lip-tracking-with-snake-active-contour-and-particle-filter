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
    end


    outputVideo = VideoWriter([root,'.avi']);
    outputVideo.FrameRate = 24;
    open(outputVideo)

    resize = 1;
    
    start_frame=idx1;
    end_frame=idx2;
    lose=zeros(1,3);
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
        imshow(raw_img)
%          for i=1:objects
%             % Forecasting
%             particles{i} = update_particles(F_update, Xstd_pos, Xstd_vec, particles{i});
% 
%             % Calculating Log Likelihood
%             L = calc_log_likelihood(Xstd_rgb, trgt, particles{i}(1:2, :), img);
% 
%             % Resampling
%             particles{i} = resample_particles(particles{i}, L);
%             % raw_img=img;
%             if true
%              meanx=mean(objectx{i}(:));
%              meany=mean(objecty{i}(:));
% 
%              lam=1.5;
%              objectx{i} =mean(particles{i}(2,:))+...
%                 lam*std(particles{i}(2,:))*(objectx{i}-meanx)/std(objectx{i}(:));  
%              objecty{i} =mean(particles{i}(1,:))+...
%                 lam*std(particles{i}(1,:))*(objecty{i}-meany)/std(objecty{i}(:));
% 
%             [objectx{i},objecty{i}] = snakeinterp(objectx{i},objecty{i},2,.5);
%             [objectx{i},objecty{i}]=snake(gray_img,objectx{i},objecty{i},3,1);
%              
%             end
%         end       
        for i=1:objects
            if lose(i)==1
                continue
            end
            % Forecasting
            particles{i} = update_particles(F_update, Xstd_pos, Xstd_vec, particles{i});

            % Calculating Log Likelihood
            L = calc_log_likelihood(Xstd_rgb, trgt, particles{i}(1:2, :), img);

            % Resampling
            particles{i} = resample_particles(particles{i}, L);
            % raw_img=img;
            if true
             meanx=mean(objectx{i}(:));
             meany=mean(objecty{i}(:));

             lam=1.5;
             objectx{i} =mean(particles{i}(2,:))+...
                lam*std(particles{i}(2,:))*(objectx{i}-meanx)/std(objectx{i}(:));  
             objecty{i} =mean(particles{i}(1,:))+...
                lam*std(particles{i}(1,:))*(objecty{i}-meany)/std(objecty{i}(:));
            try
                [objectx{i},objecty{i}] = snakeinterp(objectx{i},objecty{i},2,.5);
            catch
                %loss i object
                lose(i)=1;
            end
            [objectx{i},objecty{i}]=snake(gray_img,objectx{i},objecty{i},3,1);
             
            end
        end
        for i=1:objects
            if lose(i)==1
                continue
            end
                        % Showing Image
            hold on
            plot(particles{i}(2,:), particles{i}(1,:), '.')
            hold off
            snakedisp(objectx{i},objecty{i},'go')
            
        end
        writeVideo(outputVideo,getframe);
    end
    close(outputVideo);

