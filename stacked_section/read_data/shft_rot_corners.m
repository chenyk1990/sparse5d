function [ag,xy1,xy2]=shft_rot_corners(xy)
%calculate the angle of the survey area and shift and rotate it

% input  
% xy : original coordinates

% output 
% ag: direction vector of this survey area (complex number format)
% xy1: shift the coordinates to make (0,0) as original point
% xy2: rotate xy1 based on the angle ag to make the area aligned with the
% axes
ag=(xy(2,1)-xy(1,1))+1i*(xy(2,2)-xy(1,2));

% ag2=(xy(4,1)-xy(3,1))+1i*(xy(4,2)-xy(3,2));
xy1=xy-repmat(min(xy),[4,1])+1;
sta=-angle(ag);
M=[cos(sta)   sin(sta);
    -sin(sta)   cos(sta);];
xy2=xy1*M;
end
