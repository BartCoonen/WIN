%simulation of a man waliknig in a fixed route in a room.
% the route is a straight line in this room and the man is walking in a constant speed 1m/s
% we need to detect if this man is walking away the reciever or closer.

% algorithm: inverse synthetic aperture radar (ISAR)
function [theta_max] = angle_detect(C1,C2)
% % angle detection 
w = 4; %overlapping parameter
global lamda;
if length(C1(1,:))> length(C2(1,:))
    C2(:,end+1:length(C1(1,:))) = 0;
else 
    C1(:,end+1:length(C2(1,:))) = 0;
end

H = C1+C2;% channel response from two transmitters

theta_max = zeros();
k = 1;
v = 1;
T = 0.5;
delta = v*T;
theta_gap = 0.01;
angle_start = -pi/2;
angle_end = pi/2;
A_theta = zeros(ceil((angle_end - angle_start)/theta_gap),length(C1(1,:)));
A_theta_norm = zeros(ceil((angle_end - angle_start)/theta_gap),1);

for i =1:1:length(C1(:,1))-3
    for theta = angle_start:theta_gap:angle_end
        for j = 1:1:w
            %index = H(i+j-1,:).*exp((2i*pi*j/lamda)*delta*sin(theta));
            index = H(i+j-1,:).*exp((2i*pi*j/lamda)*delta*sin(theta))*2i*j*pi/lamda*delta*cos(theta);
            A_theta(k,:) = A_theta(k,:) + index;
        end
        A_theta_norm(k,1) = norm(sum(A_theta(k,:))); 
        k = k+1;
        B(:,i) = A_theta_norm;
    end
    k=1;
    [~,m] = max(A_theta_norm);
    theta_max(1,i) = angle_start+(m-1)*theta_gap;
end
HeatMap(B);