function [u,v] = GVF(f, mu, ITER)
[fx,fy] = imgradient(f); 
u = fx; v = fy; 
SqrMagf = fx.*fx + fy.*fy;

for i=1:ITER,
  u = u + mu*4*del2(u) - SqrMagf.*(u-fx);
  v = v + mu*4*del2(v) - SqrMagf.*(v-fy);
  if (rem(i,20) == 0)
  end 
end
