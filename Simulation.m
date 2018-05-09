function [ttable,xtable,ytable,p] = Simulation(n,p,t_end,dt);

% Initalize empty tables
[ttable,xtable,ytable] = deal(zeros(size(p,2),n));


     % Start the simulation at the initial contitions.
     t = 0;
     GM = p(4,:);
     x = p(2,:); % x_0
     y = p(3,:); % y_0
     
     vinkel = p(7,:);
     
     v_x = p(5,:);
     v_y = p(6,:);

    for n=1:1:n
         t = t + dt;   % Update the time
         
         % Calculate acceleration on a mass attached to spring
         a_x = -GM.*(x./((x.^2+y.^2).^1.5));      
         a_y = -GM.*(y./((x.^2+y.^2).^1.5));  
         
         % Update the velocity
         v_x = v_x + a_x.*dt; 
         v_y = v_y + a_y.*dt;
         v = [v_x;v_y];
         
         % Update the position calculation
         x = x + v_x*dt;
         y = y + v_y*dt;         
         
         % Update particle data
         p(2,:) = x;
         p(3,:) = y;
         p(10,:) = t;
         p(5,:) = v_x;
         p(6,:) = v_y;
         
         % Collisions
         %if mod(n,10)==0
             for i=1:1:size(p,2) % Particle 1
                for j=i+1:1:size(p,2) % Particle 2
                     if(i~=j)
                        % parallel
                        
                        % pjiparallel = (dot((p(2:3,j)-p(2:3,i), p(5:6,j)-p(5:6,j))*p(5:6,j)-p(5:6,j))/norm(p(5:6,j)-p(5:6,j)).^2)
                        % pjiparallel = (dot((pij, vij)*vij)/norm(Vij).^2)
                        
                        % vinkelret
                        
                        % pjivinkelret = pji - pjiparallel;
                        
                        % then - if((norm(Pijparallel)<norm(vij)*dt)&&norm(pjivinkelret)<p(11,i) + p(11,j))
                        
                        displacem = p(2:3,i)-p(2:3,j); % displacem=par1xy-par2xy
                        displacemStart = p(2:3,i)-p(2:3,j); % displacem=par1xy-par2xy
                        distanceStart = sum(displacem.^2); % The distance between the particles
                         distance = sum(displacem.^2); % The distance between the particles
                         if(distance<=(p(11,i)+p(11,j))^2||distance<=(p(11,i)+p(11,j))^2) % distance <= particle(i+y, objRadius)
                            %p(12,i) = distance; % Distance between the particles when they collided
                            p(13,i) = true; % is 1 if collision happened and is recorded in the particles data
                            p(14,i) = p(2,i);
                            p(15,i) = p(3,i);
                            
                            p(13,j) = true; % is 1 if collision happened and is recorded in the particles data
                            p(14,j) = p(2,j);
                            p(15,j) = p(3,j);
                         else
                             %p(13,i) = false; %% is 0 if%collision didnt happen at all
                             %p(12,i) = distance;  % Distance between the particles when they collided
                         end
                     end
                end
             end
         %end
          
         % the particle's travel data
         for i=1:1:size(p,2)
             ttable(i, n) = p(10,i);
             xtable(i, n) = p(2,i);
             ytable(i, n) = p(3,i);
         end
    end