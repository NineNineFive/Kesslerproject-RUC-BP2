% Reset past variables
clear 


% Simulation settings (leap-frog)
t_end = 6000; % Simulation seconds
partikel_antal = 10; % Particle quantity

% Particles Data
% p = zeros(10,partikel_antal); % 10 variabler i partiklen, x antal partikler


dt = 1; % Time-step
n = ceil(t_end/dt); % Number of steps simulation has to run

r = 6.378e6; % Orbits radius from earth
G = 6.67e-11; % Graviation constant
M = 5.98e24; % Mass

p = zeros(15,partikel_antal);
for i=1:1:size(p,2)
    inverted = randi([0,1],1,1);
    h = randi([200000,200000],1,1); %h�jde i meter
    id(i) = i;
    vi(i) = deg2rad(randi([1 360],1,1));
    x(i) = (r+h)*cos(vi(i));
    y(i) = (r+h)*sin(vi(i));
    tid(i) = i;
    % x_0(i) = (r+h)*cos(vi(i));
    % y_0(i) = (r+h)*sin(vi(i));
    rh(i) = r+h;
    if(inverted==1)
        v_0(i) = sqrt(G*M/(r+h));
    else
        v_0(i) = -sqrt(G*M/(r+h));
    end    
    v_x(i) = -v_0(i)*sin(vi(i)); % V_x = -(V_0) * sin(vinkel)
    v_y(i) = v_0(i)*cos(vi(i)); % V_y = (V_0) * cos(vinkel)
    GM(i) = G*M;
    objsize(i) = randi([1,200],1,1);
    distance(i) = 0;
    collided(i) = 0;
    collided2(i) = 0;
    collided3(i) = 0;
end

%| 1:id | 2:x | 3:y | 4:GM | 5:v_x (x) |6:v_y (y) | 7:vi | 8:rh | 9:v_0 | 10:tid |
%11:objsize |
values = [id;x;y;GM;v_x;v_y;vi;rh;v_0;tid;objsize;distance;collided;collided2;collided3;];
p = values;



% LeapFrog Orbit Function
[ttable, xtable, ytable,p] = Simulation(n,p,t_end,dt);



% plotting
%figure(1);
%plot(ttable(i,:),xtable(i,:));
%hold on
%plot(ttable(i,:),ytable(i,:));

figure(2);
axis equal;
grid on;
hold on;
xlabel('X position');
ylabel('Y position');
earth = viscircles([0 0],r,'Color',[0 0.4 0]); % The earth
%earth.LineWidth = 1;
%earth.Color = 'black';
for i = 1:1:size(p,2)
    plot(p(2,:), p(3,:), '.'); % particles current position
    plot(xtable(i,:),ytable(i,:)); % Particles travel in orbit
    if p(14,i)~=0&&p(15,i)~=0
        plot(p(14,i), p(15,i),'X');
    end
end

% Clear variables from workspace
clearvars id dt G v h G M GM tid pv v_x v_y v_0 r rh t x y values inverted vi i n objsize collided distance; 