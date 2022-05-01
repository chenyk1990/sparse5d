function a=gather2dto3d(b,odr)
% change 2d cmp gather back to 3D according to odr

% b: 2D gather
% odr: sequence number
% a: 3D gather

[cy,cx]=size(odr);
a=zeros(size(b,1),cy,cx);
for m=1:cy
    for n=1:cx
        a(:,m,n)=b(:,odr(m,n));
    end
end
end