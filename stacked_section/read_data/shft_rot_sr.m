function [sr1,sr2]=shft_rot_sr(sr,ag,xy)
% shift and rotate sr

% input  
% sr: original coordinates
% ag: direction vector of this survey area (complex number format)

% output 
% sr1: shift the coordinates to make (0,0) as original point
% sr2: rotate sr1 based on the angle ag to make the area aligned with the
% axes

% shift the sr coordinates in the same way as xy-->xy1, use the same
% original point
sr1=(sr-repmat([min(xy) min(xy)],[size(sr,1),1]));

% rotate the sr1 coordinates in the same way as xy1-->xy2
sta=-angle(ag);
rot=[cos(sta)   sin(sta);
    -sin(sta)   cos(sta);];
sr2(:,1:2)=sr1(:,1:2)*rot;
sr2(:,3:4)=sr1(:,3:4)*rot;
end
