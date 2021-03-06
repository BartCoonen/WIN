
%the crossing point of two lines 
% L1: A1(m1,n1),B1(m2,n2) determine A1*x+B1*y+C1=0;
% L2: A2(m3,n3),B2(m4,n4) determine A2*x+B2*y+C2=0;

% Pt crossing point
function Pt=linecrosspoint(m1,n1,m2,n2,m3,n3,m4,n4)
A1=n2-n1; B1=m1-m2; C1=m2*n1-m1*n2;
A2=n4-n3; B2=m3-m4; C2=m4*n3-m3*n4;
A=[A1,B1;A2,B2];B=[-C1;-C2];
Pt=A\B;

