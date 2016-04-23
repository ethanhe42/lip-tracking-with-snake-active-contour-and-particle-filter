function X = create_particles(x,y, Npop_particles)
X1 = min(x)+randi(ceil(max(x)-min(x)), 1, Npop_particles);
X2 = min(y)+randi(ceil(max(y)-min(y)), 1, Npop_particles);
X3 = zeros(2, Npop_particles);

X = [X1; X2; X3];
