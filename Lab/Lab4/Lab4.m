clear;
clc;
img=imread('shapes.png');
[components,count]=bwlabel(img,8);

for k=1:count
    N = length(find(components==k));
    [r,c] = find(components == k);          % for region 1, for example.
    cMean = mean(c); 		 		% To find the column mean.
    rMean = mean(r);
    cNorm = c-cMean;				% Subtracts the mean from the whole array
    rNorm = r-rMean;
    cNormSquared = (cNorm).^2;		% Squares the whole array at once
    rNormSquared = (rNorm).^2;
    crNormSquared = (cNorm).*(rNorm);
    csumSquared = sum(cNormSquared);	% Finds the sum of the given array
    rsumSquared = sum(rNormSquared);
    crsumSquared = sum(crNormSquared);
    a(1,1) = csumSquared / N;
    a(1,2) = crsumSquared / N;
    a(2,2) = rsumSquared / N;
    a(2,1) = a(1,2);
    
    [eigen_vector,eigen_value]=eig(a);
    elongation(k)=sqrt(max(eigen_value(1,1),eigen_value(2,2))/min(eigen_value(1,1),eigen_value(2,2)));
    p=bwtraceboundary(img,[r(1) c(1)],'e',8);
    perimeter(k)=sqrt((p(length(p),1)-p(1,1))^2+(p(length(p),2)-p(1,2))^2);
    for i=2:length(p)
        perimeter(k)=perimeter(k)+sqrt((p(i,1)-p(i-1,1))^2+(p(i,2)-p(i-1,2))^2);
    end
    circ(k)=perimeter(k)^2/N;
end