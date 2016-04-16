%deal with single image, become function when done.

load('template.mat');
[x,y] = snakeinterp(x,y,2,0.5);

% filename
% 
methods={'slide' 'normal' 'classic' 'gvf'};
method=methods(4);

filename='./liptracking2/liptracking2_01302.jpg';
img=imread(filename);
raw_img=img;
if length(size(img))==3
    img=rgb2gray(img);
end

img=im2double(img);
if strcmp(method,'gvf')
    img=img/255.0;
else
    
    sigma=1;
    gaussian_mask=fspecial('gaussian',3*sigma,sigma);
    img=conv2(img,gaussian_mask);
end


if strcmp(method,'gvf')
    [u,v] = GVF(img, 0.2, 80); 
     disp(' Nomalizing the GVF external force ...');
     mag = sqrt(u.*u+v.*v);
     px = u./(mag+1e-10); py = v./(mag+1e-10);  
else
    [px,py]=gradient(img);
    [pxx,pxy]=gradient(px);
    [pyx,pyy]=gradient(py);
end
alpha=0.05;
beta=0;
gamma=1;
kappa=4;
N=size(x,1);

alpha = alpha* ones(1,N); 
beta = beta*ones(1,N);

a = beta;
b = -alpha - 4*beta;
c = 2*alpha +6*beta;

% generate the parameters matrix



if strcmp(method,'slide')
    A = diag(a(1:N-2),-2);% + diag(a(N-1:N),N-2);
    A = A + diag(b(1:N-1),-1);% + diag(b(N), N-1);
    A = A + diag(c);
    A = A + diag(b(1:N-1),1);% + diag(b(N),-(N-1));
    A = A + diag(a(1:N-2),2);% + diag(a(N-1:N),-(N-2));
    
    invA=inv(A);

else
    A = diag(a(1:N-2),-2) + diag(a(N-1:N),N-2);
    A = A + diag(b(1:N-1),-1) + diag(b(N), N-1);
    A = A + diag(c);
    A = A + diag(b(1:N-1),1) + diag(b(N),-(N-1));
    A = A + diag(a(1:N-2),2) + diag(a(N-1:N),-(N-2));
    if strcmp(method,'normal')
        
        template_x=x;
        template_y=y;
    end
end

inv_AplusI = inv(gamma * A + diag(ones(1,N)));


for count = 1:5*25
   intensity_x = interp2(px,x,y);
   intensity_y = interp2(py,x,y);
   if strcmp(method,'gvf')
       ext_x=gamma*(kappa*intensity_x);
       ext_y=gamma*kappa*intensity_y;
   else
       zerocross_x = 2*(interp2(pxx,x,y)+interp2(pyx,x,y));
       zerocross_y = 2*(interp2(pxy,x,y)+interp2(pyy,x,y));
       ext_x=gamma* (kappa*intensity_x+zerocross_x);
       ext_y=gamma* (kappa*intensity_y+zerocross_y);
   end


    if strcmp(method,'slide')
        x=invA*(ext_x/gamma);
        y=invA*(ext_y/gamma);
    else
        if strcmp(method,'classic') || strcmp(method,'gvf')
           x = inv_AplusI * (x - ext_x);
           y = inv_AplusI * (y - ext_y);
        else
           x =template_x+ inv_AplusI * ( - ext_x); %#ok<*MINV>
           y =template_y+ inv_AplusI * ( -ext_y);
        end
    end
end
imshow(raw_img);
snakedisp(x,y,'r')


