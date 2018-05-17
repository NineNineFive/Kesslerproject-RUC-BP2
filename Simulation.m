function [ttable,xtable,ytable,p] = Simulation(n,p,t_end,dt,r,live_simulation)

% Initalize empty tables
[ttable,xtable,ytable] = deal(zeros(size(p,2),n));

     % Start the simulation at the initial contitions.
     t = 0;
     GM = p(4,:);
     x = p(2,:); % x_0
     y = p(3,:); % y_0
     v_x = p(5,:);
     v_y = p(6,:);

    for n=1:1:n
         t = t + dt;   % Update the time
         
         % Calculate acceleration on a mass attached to spring
         a = -GM.*(p(2:3,:)./((p(2,:).^2+p(3,:).^2).^1.5));      

         % Update the velocity
         v = p(5:6,:) + a.*dt; 
         
         % Update the position calculation
         x = p(2,:) + p(5,:)*dt;
         y = p(3,:) + p(6,:)*dt;         
         
         % Update particle data
         p(2:3,:) = [x;y];
         p(5:6,:) = v;
         p(10,:) = t;
         
         
         % Collisions
             for i=1:1:size(p,2) % Particle 1
                for j=1:1:size(p,2) % Particle 2
                     if(i~=j)
                        % parallel
                        pji = p(2:3,j)-p(2:3,i);
                        vij = p(5:6,j)-p(5:6,i);
                        % pjiparallel = (dot((p(2:3,j)-p(2:3,i)), p(5:6,j)-p(5:6,j))*p(5:6,j)-p(5:6,j))/(norm(p(5:6,j)-p(5:6,j)).^2);
                        pjiparallel = (dot(pji, vij)*vij)/(norm(vij).^2);
                        
                        % vinkelret
                        
                        pjivinkelret = pji - pjiparallel;
                        
                        % then - if((norm(Pijparallel)<norm(vij)*dt)&&norm(pjivinkelret)<p(11,i) + p(11,j))
                        if((norm(pjiparallel) < norm(vij)*dt) && norm(pjivinkelret) < p(11,i) + p(11,j))
                            % Partikel 1
                            p(13,i) = p(13,i)+1; % is 1 if collision happened and is recorded in the particles data
                            p(14:15,i) = p(2:3,i); % Position of collisions  
                            
                            impuls = p(12,i)*p(5:6,i);   %impuls p = m*v
                            p(16,i) = 1/2*p(12,i)*( norm(p(5:6,i)) )^2; % Formlen for energi: 1/2*objMasse*(velocity)^2
                            
                                
                            % Partikel 2
                            p(13,j) = p(13,j)+1; % is 1 if collision happened and is recorded in the particles data
                            p(14:15,j) = p(2:3,j);
                          
                            
                            impuls2 = p(12,j)*[p(5,j);p(6,j)];
                            p(16,j) = 1/2*p(12,j)*(norm(p(5:6,j))^2); % Formlen for energi: 1/2*objMasse*(velocity)^2
                            
                            
                            % Center of mass frame
                            vcm = (impuls+impuls2)/(p(12,i)+p(12,j)); % Velocity - Center of Mass
                            
                            % CM frame 
                            vel1indframe = [p(5,i);p(6,i)] - vcm;      %vel1indframe = vel1 - vcm; 
                            vel2indframe = [p(5,j);p(6,j)] - vcm; 
                            
                            % Energi (ikke bevaret)
                            
                            k_ind1 = (1/2)*p(12,i)*norm([p(5,i);p(6,i)])^2;
                            k_ind2 = (1/2)*p(12,j)*norm([p(5,j);p(6,j)])^2;
                            
                            %energisum = p(16,i)+p(16,j);
                            %energiud = energisum*(0.9);
                            
                            k_ud1 = (k_ind1)*0.9;
                            k_ud2 = (k_ind2)*0.9;
                            k_0 = (k_ud1+k_ud2);
                            
                           
                            % Kollision i frame 
                            vel1udframe = -vel1indframe;
                            vel2udframe = -vel2indframe;
                            
                            % Frame kredsl�b 
                            vel1ud = vel1udframe + vcm; 
                            vel2ud = vel2udframe + vcm; 
                            
                            
                            %sqrt(k_ind1)*[p(5,i);p(6,i)]
                            
                            % Set new velocity for existing particles
                            p(5:6,i) = -p(5:6,i);
                            p(5:6,j) = -p(5:6,j);

                         end
                     end
                end
             end

          
         % the particle's travel data
         for i=1:1:size(p,2)
             ttable(i, n) = p(10,i);
             xtable(i, n) = p(2,i);
             ytable(i, n) = p(3,i);
         end
         
         % live plotting
         if live_simulation==true && mod(n,10)==0
            Plotting(p,ttable,xtable,ytable,r,n, live_simulation);
         end
    end
    
    
    % not live plotting
    if(live_simulation==false)
        Plotting(p,ttable,xtable,ytable,r,n,live_simulation);
    end
