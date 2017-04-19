%% a man walking away from the reciever, starting an (10,2). detect the angle.
clear all;
clc;

bound=[0,11,11,11,11,0,0,0;0,0,0,11,11,11,11,0];%% the boundary of this room
line1=[3.2,3.8,3.8,3.8,3.8,3.2,3.2,3.2;4,4,4,8,8,8,8,4];%% barrier 1
line2=[7.2,7.8,7.8,7.8,7.8,7.2,7.2,7.2;4,4,4,8,8,8,8,4];%% barrier 2
trans=[3.5,7.5;1,1];% transmitter
receiver=[5.5,1];% transmitter
AP=[3.5,7.5,5.5;1,1,1];
start=[1 2]; %% starting point
location=zeros(); %% location of the man 
location(1,1) = start(1,1);
location(2,1) = start(1,2);

%parameters
global lamda;
c = 3e8; % the speed of light 
lamda = c/(2.4*1*10^9);% wavelength
K = 20*log10(4*pi/lamda);% path loss constant
R=1;
Ptr = -45.8;% initialized power of transmitted signal
fc = 10e9;   % carrier frequency
v =1;%speed of human 
channel_1_loss_dB=zeros(); % parameters of the channel 1
channel_2_loss_dB=zeros(); % parameters of the channel 2
channel_1_delay=zeros(); % parameters of the channel 1
channel_2_delay=zeros(); % parameters of the channel 2
path_delay=zeros(1,3);
path_loss=zeros(1,3);
% four fixed channel path: delay and path loss
gama=2; %loss constant in air 

%for transmitter 1: 
    %first path: direct
    r(1,1) = abs((AP(1,1)-AP(1,3)));
    fix_delay_1(1,1) = r(1,1)/c;
    fix_loss_1(1,1) = -10*gama*log10(r(1,1))-K-R*randn(1);
    %second path : left
    r(2,1) = AP(1,1)+AP(1,3);
    fix_delay_1(2,1) = r(2,1)/c;
    fix_loss_1(2,1) = -10*gama*log10(r(2,1))-K-R*randn(1);
    %third path: right
    r(3,1) = bound(1,2)-AP(1,1)+bound(1,2)-AP(1,3);
    fix_delay_1(3,1) = r(3,1)/c;
    fix_loss_1(3,1) = -10*gama*log10(r(3,1))-K-R*randn(1);
    
    %fourth path: down
    r(4,1) = sqrt(((AP(1,3)- AP(1,1))/2)^2 + 1)*2;
    fix_delay_1(4,1) = r(4,1)/c;
    fix_loss_1(4,1) = -10*gama*log10(r(4,1))-K-R*randn(1);
    %fifth path:refletcion from human body
    
    %for transmitter 2: 
    %first path: direct
    r(1,1) = abs((AP(1,2)-AP(1,3)));
    fix_delay_2(1,1) = r(1,1)/c;
    fix_loss_2(1,1) = -10*gama*log10(r(1,1))-K-R*randn(1);
    %second path : left
    r(2,1) = (AP(1,3)+AP(1,2));
    fix_delay_2(2,1) = r(2,1)/c;
    fix_loss_2(2,1) = -10*gama*log10(r(2,1))-K-R*randn(1);
    %third path: right
    r(3,1) = bound(1,2)-AP(1,3)+bound(1,2)-AP(1,2);
    fix_delay_2(3,1) = r(3,1)/c;
    fix_loss_2(3,1) = -10*gama*log10(r(3,1))-K-R*randn(1);
    
    %fourth path: down
    r(4,1) = sqrt(((AP(1,2)- AP(1,3))/2)^2 + 1)*2;
    fix_delay_2(4,1) = r(4,1)/c;
    fix_loss_2(4,1) = -10*gama*log10(r(4,1))-K-R*randn(1);
    %fifth path:refletcion from human body
    channel_p = 0.1;
    
    i=1;
    %%the tracking peorid is 0.5s, and constant speed of man is v 
for t=0.5:channel_p:30
    location(2,i+1)=location(1,i);
    location(1,i+1)=location(1,i)+ v*channel_p;
    %%check that if the line between two succeisive points crosses the barriers(this can't happen in reality)
    pt11= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line1(1,1),line1(2,1),line1(1,2),line1(2,2));
    pt12= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line1(1,3),line1(2,3),line1(1,4),line1(2,4));
    pt13= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line1(1,5),line1(2,5),line1(1,6),line1(2,6));
    pt14= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line1(1,7),line1(2,7),line1(1,8),line1(2,8));
    pt21= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line2(1,1),line2(2,1),line2(1,2),line2(2,2));
    pt22= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line2(1,3),line2(2,3),line2(1,4),line2(2,4));
    pt23= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line2(1,5),line2(2,5),line2(1,6),line2(2,6));
    pt24= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),line2(1,7),line2(2,7),line2(1,8),line2(2,8));  
    %%check that if the line between two succeisive points crosses the bound(meaning that the man is walking out of this room)   
    bound1= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),bound(1,1),bound(2,1),bound(1,2),bound(2,2));  
    bound2= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),bound(1,3),bound(2,3),bound(1,4),bound(2,4));  
    bound3= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),bound(1,5),bound(2,5),bound(1,6),bound(2,6));  
    bound4= solve_point(location(1,i+1), location(2,i+1),location(1,i),location(2,i),bound(1,7),bound(2,7),bound(1,8),bound(2,8));
    
    index=[pt11,pt12,pt13,pt14,pt21,pt22,pt23,pt24,bound1,bound2,bound3,bound4];
         if sum(index==2)==0 % means that those two situations mentioned before do not happen 
            i=i+1;
            for j=1:3
                % caculate the path loss for channel 1 and channel 2
            [loss,delay] = RSSI_calculation(i,j,location,AP,line1,line2,K,R,c);     
            path_loss(1,j) = loss;
            path_delay(1,j) = delay;
            end
            channel_1_loss_dB(5,i-1) = path_loss(1,1) + path_loss(1,3);% path loss of channel 1
            channel_2_loss_dB(5,i-1) = path_loss(1,2) + path_loss(1,3);% path loss of channel 2
            channel_1_delay(5,i-1)= path_delay(1,1)+path_delay(1,3);
            channel_2_delay(5,i-1)= path_delay(1,2)+path_delay(1,3);
           else
           continue;
         end
         channel_1_loss_dB(1:4,1:i-1)=[repmat(fix_loss_1(1,1),1,i-1); ...
             repmat(fix_loss_1(2,1),1,i-1);repmat(fix_loss_1(3,1),1,i-1);repmat(fix_loss_1(4,1),1,i-1)];
         
         channel_1_delay(1:4,1:i-1)=[repmat(fix_delay_1(1,1),1,i-1); ...
             repmat(fix_delay_1(2,1),1,i-1);repmat(fix_delay_1(3,1),1,i-1);repmat(fix_delay_1(4,1),1,i-1)];
         
         channel_2_loss_dB(1:4,1:i-1)=[repmat(fix_loss_2(1,1),1,i-1); ...
             repmat(fix_loss_2(2,1),1,i-1);repmat(fix_loss_2(3,1),1,i-1);repmat(fix_loss_2(4,1),1,i-1)];
         
         channel_2_delay(1:4,1:i-1)=[repmat(fix_delay_2(1,1),1,i-1); ...
             repmat(fix_delay_2(2,1),1,i-1);repmat(fix_delay_2(3,1),1,i-1);repmat(fix_delay_2(4,1),1,i-1)];
        if location(1,i) <10
            continue;
        else
            v = 0;
        end           
end
% channel response 

phase_delay = exp(-2i*pi*fc.*channel_1_delay); 
%phase_delay(:,:) = 1;
channel_1_loss_real = sqrt(10.^(channel_1_loss_dB./10)); 
channel_2_loss_real = sqrt(10.^(channel_2_loss_dB./10)); 

C1 = zeros();%channel response of channel 1
C2 = zeros();% channel response of channel 2
C1_man = zeros();% only channel response from the man of channel 1  
C2_man = zeros();% only channel response from the man of channel 2 
% turin this multipath response into a discrete-time FIR channel filter
dt = 10e-10; %sampling time (the input signal sample period)
% channel response for channel 1
for i=1:1:length(channel_1_delay)
    %a = max(channel_1_delay(:,i));
    %max_element = ceil(a/dt);
    for j =1:1:5
        C1(i,ceil(channel_1_delay(j,i)/dt))= channel_1_loss_real(j,i)*phase_delay(j,i);
    end
    C1_man (i,ceil(channel_1_delay(5,i)/dt)) = channel_1_loss_real(5,i)*phase_delay(5,i);
end

%channel response for channel 2
for i=1:1:length(channel_2_delay)
    for j =1:1:5
        C2(i,ceil(channel_2_delay(j,i)/dt))= channel_2_loss_real(j,i)*phase_delay(j,i);
    end
     C2_man(i,ceil(channel_2_delay(5,i)/dt))= channel_2_loss_real(5,i)*phase_delay(5,i);
end
[theta_max] = angle_detect(C1_man,C2_man);





% hold on
% 
% x=[3.2 3.8 3.8 3.2];      
% y=[4 4 8 8];      
% X=[x x(1)];       
% Y=[y y(1)];
% plot(X,Y,'-r');
% 
% m=[7.2 7.8 7.8 7.2];      
% n=[4 4 8 8];      
% M=[m m(1)];       
% N=[n n(1)];
% plot(M,N,'-r');
% 
% l=[0,11,11,11,11,0,0,0];
% ml=[0,0,0,11,11,11,11,0];
% plot(l,ml,'-ko');
% 
% a=location(1,:);
% b=location(2,:);
% plot(a,b,'-g*');
% 
% hold off
% 
