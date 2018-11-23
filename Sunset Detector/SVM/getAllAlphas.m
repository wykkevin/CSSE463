function [allAlphas] = getAllAlphas(net)
% Maps for example, from boolean 1 1 0 1 0 0] 
% and a dense matrix [a1, a2, a3] to
% [a1, a2, 0 a3, 0, 0] 
allAlphas = zeros(net.NumObservations, 1);
svIdx = 1;
for i = 1:length(allAlphas)
   if net.IsSupportVector(i)
       allAlphas(i) = net.Alpha(svIdx);
       svIdx = svIdx + 1;
   end
end

end
