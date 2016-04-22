clear all

% dir_name='liptracking2';
% start_frame=1302;
dir_name='liptracking4';
start_frame=68;
dir=['./',dir_name,'/',dir_name,'_',num2str(start_frame,'%05d'),'.jpg'];
    
img=imread(dir);
imshow(img)
[x,y]=ginput(20);
save('template4.mat');
