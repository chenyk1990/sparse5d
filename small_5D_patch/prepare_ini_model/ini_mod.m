function a=ini_mod(b,p)
% this is to prepare the initial model. see eq.1 and 2 in the paper

% b: input local area (widx*widy cmp bins)
% p: p==1, average all the corrsponding traces 
%    p==other values, use the last corrsponding trace

% a: prepared single CMP gather

% eq.1 'False' situation
[t,x,y,m,n]=size(b);
a=zeros(t,x,y);
if p==1
    for i=1:x
        for j=1:y
            s=0;k=0;
            for ii=1:m
                for jj=1:n
                    if max(b(:,i,j,ii,jj))~=0
                        s=s+b(:,i,j,ii,jj);
                        k=k+1;
                    end
                end
            end
            if k~=0
                a(:,i,j)=s./k;
            end
        end
    end
else
    for i=1:x
        for j=1:y
            for ii=1:m
                for jj=1:n
                    if max(b(:,i,j,ii,jj))~=0
                        a(:,i,j)=b(:,i,j,ii,jj);
                    end
                end
            end
            
        end
    end
end


% eq.1 'True' situation
for i=1:x
    for j=1:y
        if max(b(:,i,j,floor(m/2)+1,floor(n/2)+1))~=0
            a(:,i,j)=b(:,i,j,floor(m/2)+1,floor(n/2)+1);
        end
        
    end
end
end
