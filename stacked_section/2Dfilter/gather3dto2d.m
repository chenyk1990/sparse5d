function a=gather3dto2d(b,odr)
% reorder 3d cmp gather to 2D according to odr

% b: 3D gather
% odr: sequence number
% a: 2D gather

[~,cy,cx]=size(b);
a=zeros(size(b,1),size(b,2)*size(b,3));
for m=1:cy
    for n=1:cx
        a(:,odr(m,n))=b(:,m,n);
    end
end
end