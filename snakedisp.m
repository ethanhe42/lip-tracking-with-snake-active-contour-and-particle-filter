function snakedisp(x,y,s)
hold on
x = x(:); y = y(:);
if nargin == 3
   plot([x;x(1,1)],[y;y(1,1)],s);
   drawnow
   hold off
end
