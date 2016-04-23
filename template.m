% directory_name='liptracking2';
% start_frame=1302;
% directory_name='liptracking4';
% start_frame=68;
directory_name='liptracking3';
start_frame=1295;
dir=['./',directory_name,'/',directory_name,'_',num2str(start_frame,'%05d'),'.jpg'];
    
img=imread(dir);
imshow(img)
x=zeros(3,20);
y=zeros(3,20);
for i=1:3
    [x(i,:),y(i,:)]=ginput(20);
    disp(i)
end
save(['template',directory_name(length(directory_name)),'.mat'],'x','y');
