%  check if two lines have intersection or not   
function r=solve_point(x1,y1,x2,y2,x3,y3,x4,y4) %x1,y1,x2,y2 the coordinates of the two end points of line 1
LD1x=min(x1,x2);LD1y=min(y1,y2);               %x3,y3,x4,y4 the coordinates of the two end points of line 2
LD2x=min(x3,x4);LD2y=min(y3,y4);               %LD leftdown,RU rightup
RU1x=max(x2,x1);RU1y=max(y2,y1); 
RU2x=max(x3,x4);RU2y=max(y3,y4); 
X=(RU1x>=LD2x)&(RU2x>=LD1x); 
Y=(RU1y>=LD2y)&(RU2y>=LD1y); 
if X&&Y 
   M1=[x3-x1,y3-y1;x2-x1,y2-y1]; 
   M2=[x4-x1,y4-y1;x2-x1,y2-y1]; 
   M3=[x1-x3,y1-y3;x3-x4,y3-y4];
   M4=[x2-x3,y2-y3;x3-x4,y3-y4];
   P1=det(M1); P2=det(M2); P3=det(M3);  P4=det(M4); 
   Q1=P1*P2;Q2=P3*P4;
   if Q1<0&&Q2<0
       r=2;%intersect
   elseif Q1==0||Q2==0
       r=1;%crossing point is the endpoint of one of the endpoints
   else
       r=0;% no intersection
  end 
else 
   r=0; 
end
