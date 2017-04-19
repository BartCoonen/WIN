function [ RSSI,delay ] = RSSI_calculation(i,j,location,AP,line1,line2,K,R,c)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
            pt11= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,1),line1(2,1),line1(1,2),line1(2,2));
            pt12= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,3),line1(2,3),line1(1,4),line1(2,4));
            pt13= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,5),line1(2,5),line1(1,6),line1(2,6));
            pt14= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,7),line1(2,7),line1(1,8),line1(2,8));
            pt21= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,1),line2(2,1),line2(1,2),line2(2,2));
            pt22= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,3),line2(2,3),line2(1,4),line2(2,4));
            pt23= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,5),line2(2,5),line2(1,6),line2(2,6));
            pt24= solve_point(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,7),line2(2,7),line2(1,8),line2(2,8));
            index1=[pt11,pt12,pt13,pt14];
            index2=[pt21,pt22,pt23,pt24];
            r=distance(location(1,i), location(2,i),AP(1,j),AP(2,j));
            delay = r/c;
                 if (sum(index1==2)==0) && sum(index2==2)==0 % the line between the two succesive points does not intersect with barrier 1,2 
               n=2;
              RSSI=-10*n*log10(distance(location(1,i),location(2,i),AP(1,j),AP(2,j)))-K-R*randn(1);
               
                 else if sum(index1==2)~=0 && sum(index2==2)==0 % only barrier 1 has intersection with the line
                         if sum(index1==1)==0
                           index_1=find(index1==2);
                           n1=2;n2=3;
                           point1=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,2*index_1(1)-1),line1(2,2*index_1(1)-1),line1(1,2*index_1(1)),line1(2,2*index_1(1)));
                           point2=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,2*index_1(2)-1),line1(2,2*index_1(2)-1),line1(1,2*index_1(2)),line1(2,2*index_1(2)));
                           r1=distance(point1(1),point1(2),point2(1),point2(2));
                           r2=distance(location(1,i), location(2,i),AP(1,j),AP(2,j))-r1;
                           RSSI=-10*n2*log10(r1)-10*n1*log10(r2)-K-R*randn(1);
                         else
                           index3=find(index1==1);
                           index4=find(index1==2);
                           n1=2;n2=3;
                           point1=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,2*index3(1)-1),line1(2,2*index3(1)-1),line1(1,2*index3(1)),line1(2,2*index3(1)));
                           point2=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,2*index4(1)-1),line1(2,2*index4(1)-1),line1(1,2*index4(1)),line1(2,2*index4(1)));
                           r1=distance(point1(1),point1(2),point2(1),point2(2));
                           r2=distance(location(1,i), location(2,i),AP(1,j),AP(2,j))-r1;
                           RSSI=-10*n2*log10(r1)-10*n1*log10(r2)-K-R*randn(1);
                          end
                            else if sum(index1==2)==0 && sum(index2==2)~=0 % % only barrier 1 has intersection with the line
                                   if sum(index2==1)==0
                                      index_1=find(index2==2);
                                      n1=2;n2=3;
                                      point1=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,2*index_1(1)-1),line2(2,2*index_1(1)-1),line2(1,2*index_1(1)),line2(2,2*index_1(1)));
                                      point2=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,2*index_1(2)-1),line2(2,2*index_1(2)-1),line2(1,2*index_1(2)),line2(2,2*index_1(2)));
                                      r1=distance(point1(1),point1(2),point2(1),point2(2));
                                      r2=distance(location(1,i), location(2,i),AP(1,j),AP(2,j))-r1;
                                      RSSI=-10*n2*log10(r1)-10*n1*log10(r2)-K-R*randn(1);
                                   else
                                        index3=find(index2==1);
                                        index4=find(index2==2);
                                        n1=2;n2=3;
                                        point1=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,2*index3(1)-1),line2(2,2*index3(1)-1),line2(1,2*index3(1)),line2(2,2*index3(1)));
                                        point2=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,2*index4(1)-1),line2(2,2*index4(1)-1),line2(1,2*index4(1)),line2(2,2*index4(1)));
                                        r1=distance(point1(1),point1(2),point2(1),point2(2));
                                        r2=distance(location(1,i), location(2,i),AP(1,j),AP(2,j))-r1;
                                        RSSI=-10*n2*log10(r1)-10*n1*log10(r2)-K-R*randn(1);
                                   end
                                else
                                        index3=find(index2==2);
                                        index4=find(index2==2);
                                        n1=2;n2=3;
                                        point1=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,2*index3(1)-1),line1(2,2*index3(1)-1),line1(1,2*index3(1)),line1(2,2*index3(1)));
                                        point2=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line1(1,2*index3(2)-1),line1(2,2*index3(2)-1),line1(1,2*index3(2)),line1(2,2*index3(2)));
                                        point3=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,2*index4(1)-1),line2(2,2*index4(1)-1),line2(1,2*index4(1)),line2(2,2*index4(1)));
                                        point4=linecrosspoint(location(1,i), location(2,i),AP(1,j),AP(2,j),line2(1,2*index4(2)-1),line2(2,2*index4(2)-1),line2(1,2*index4(2)),line2(2,2*index4(2)));
                                        r1=distance(point1(1),point1(2),point2(1),point2(2));
                                        r2=distance(point3(1),point3(2),point4(1),point4(2));
                                        r=distance(location(1,i), location(2,i),AP(1,j),AP(2,j));
                                        RSSI=-10*n2*log10(r1)-10*n2*log10(r2)-10*n1*log10(r-r1-r2)-K-R*randn(1);
                                end
                     end
                 end
              

end

