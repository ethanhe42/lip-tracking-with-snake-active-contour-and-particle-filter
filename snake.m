%deal with single image, become function when done.
% filename
% 
function [x,y]=snake(img,x,y,m,learning_rate)

alpha=10;

kappa=.5;
kappap=-.5;
beta=1*kappa;
zeta=10000*kappa;
sigma=3;
methods={'slide' 'normal' 'classic' 'gvf' 'balloon'};
method=methods(m);


    
%     imshow(img);
%     drawnow

if strcmp(method,'gvf')
    [u,v] = GVF(img, 0.2, 80);
    mag = sqrt(u.*u+v.*v);
    px = u./(mag+1e-10); py = v./(mag+1e-10); 
else
    gaussian_mask=fspecial('gaussian',3*sigma,sigma);
    img=conv2(img,gaussian_mask);
%     img=imgaussfilt(img,sigma);

    
    [px,py]=gradient(img);
end
if strcmp(method,'gvf')==0
    [pxx,pxy]=gradient(px);
    [pyx,pyy]=gradient(py);
end


N=size(x,1);

alpha = alpha* ones(1,N); 
beta = beta*ones(1,N);

a = beta;
b = -alpha - 4*beta;
c = 2*alpha +6*beta;

% generate the parameters matrix



if strcmp(method,'slide')
    A = diag(a(1:N-2),-2) + diag(a(N-1:N),N-2);
    A = A + diag(b(1:N-1),-1) + diag(b(N), N-1);
    A = A + diag(c);
    A = A + diag(b(1:N-1),1) + diag(b(N),-(N-1));
    A = A + diag(a(1:N-2),2) + diag(a(N-1:N),-(N-2));
    w=1e-15;
    while rank(A+w*eye(size(A)))<size(A,1)
        w=w+1e-15;
    end
    disp(w)
    disp(rank(A))
    disp(size(A))
    invA=inv(A+w*eye(size(A)));
    
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

inv_AplusI = inv(learning_rate * A + diag(ones(1,N)));


for count = 1:50
%     imshow(img)
%     drawnow
%     snakedisp(x,y,'r')
% snakedisp(x,y,'green')
   intensity_x = interp2(px,x,y);
   intensity_y = interp2(py,x,y);
   
   if strcmp(method,'gvf')==0
       zerocross_x = 2*(intensity_x.*interp2(pxx,x,y)+intensity_y.*interp2(pyx,x,y));
       zerocross_y = 2*(intensity_x.*interp2(pxy,x,y)+intensity_y.*interp2(pyy,x,y));
       ext_x=learning_rate* (-kappa*intensity_x-zeta*zerocross_x);
       ext_y=learning_rate* (-kappa*intensity_y-zeta*zerocross_y);
   end


    if strcmp(method,'slide')
        newx=invA*(ext_x/learning_rate);
        newy=invA*(ext_y/learning_rate);
    else
        if strcmp(method,'classic')
           newx = inv_AplusI * (x - ext_x);
           newy = inv_AplusI * (y - ext_y);
        elseif strcmp(method,'gvf')
           newx = inv_AplusI * (x - learning_rate*kappa*intensity_x);
           newy = inv_AplusI * (y - learning_rate*kappa*intensity_x);
        elseif strcmp(method,'balloon')
               xp = [x(2:N);x(1)];    yp = [y(2:N);y(1)]; 
               xm = [x(N);x(1:N-1)];  ym = [y(N);y(1:N-1)]; 

               qx = xp-xm;  qy = yp-ym;
               pmag = sqrt(qx.*qx+qy.*qy);
               fx = qy./pmag;     fy = -qx./pmag;
               newx = inv_AplusI * (x -ext_x - kappap.*fx);
               newy = inv_AplusI * (y -ext_y - kappap.*fy);
               
        else
           newx =template_x+ inv_AplusI * ( -ext_x); %#ok<*MINV>
           newy =template_y+ inv_AplusI * ( -ext_y);
        end
    end
    
    
    
%     residue=sum((newx-x).^2+(newy-y).^2)/(length(x)+length(y));
    x=newx;
    y=newy;
%     if residue<.1/learning_rate
%         break
%     end
    
end


