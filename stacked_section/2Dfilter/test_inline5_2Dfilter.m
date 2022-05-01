% This script use 2D DRR filter to process the sorted 2D gather
% The user can replace this filter with their own suitable filter to get a
% faster and more satisfactory result.

% read 5D data for an inline, and the offset correction
clear;close all;
load('../prepare_ini_model/yini.mat');
load('../read_data/OffInfo.mat');

%inline==5
s=y(:,:,:,:,5);
s=s./max(max(max(max(max(s)))));
[nt,cx,cy,nx,ny]=size(s);

%1) ploting CMP gather
lim1=-0.003;lim2=0.003;
figure;imagesc(reshape(s(:,:,:,floor(nx/2),1),nt,size(s,2)*size(s,3)));colormap(seismic);caxis([lim1,lim2]);
%%
% calculate absolute offsets
ste=rng;
rng(ste);
rd=rand(cx,cy)*0.001;
off=zeros(cx,cy);odr=off*0;

for m=1:cx
    for n=1:cy
        xof=m*offgridsize(1)+offx_correction;
        yof=n*offgridsize(2)+offy_correction;
        off(m,n)=sqrt(xof^2+yof^2);
%           off(m,n)=sqrt(m^2+n^2);
    end
end
off=off+rd;
od=sort(off(:));

for m=1:cx
    for n=1:cy
        odr(m,n)=find(off(m,n)==od);%give an offset order to each position on the surface
    end
end
%%
% mute the first break
gaa=single(zeros(nt,cx*cy,nx));
s3=s*0;
for i=1:nx
    gaa(:,:,i)=gainmute(gather3dto2d(s(:,:,:,i,1),odr),(1:500)*0.006,od,1,[0,2112],[0.3,1.5],0);
    if i==nx/2
        lim1=-0.01;lim2=0.01;
        figure;imagesc(gaa(:,:,i));colormap(seismic);caxis([lim1,lim2]);
        figure;imagesc(gather3dto2d(s(:,:,:,i,1),odr));colormap(seismic);caxis([lim1,lim2]);
    end
    s3(:,:,:,i,1)=single(gather2dto3d(gaa(:,:,i),odr));
end
%%
% reorder 3d cmp to 2d cmp gather
tic;
s4=zeros(nt,cx*cy,size(s3,4),size(s3,5));
for i=1:nx  
    s4(:,:,i)=gather3dto2d(s3(:,:,:,i),odr);
end

%%
% use fx_decon filter to process the sorted 2D gather
done=s*0;
flow=1;fhigh=70;dt=0.004;

parfor i=1:nx
    sup11=s4(:,:,i);
    % The user can replace this filter with their own suitable filter to
    % get a faster and more satisfactory result.
    sup4=fx_decon(sup11,dt,12,0.001,flow,fhigh);
    % change 2D gather back to 3D format
    done(:,:,:,i)=gather2dto3d(sup4,odr);
    i
end
toc;

%%
%plot results
for i=1:nx
    %initial model and the processed data
    t1=s4(:,:,i);
    t2=gather3dto2d(done(:,:,:,i),odr);

    if mod(i,30)==0 &&i>=10&&i<=300
        figure;imagesc(t1);colormap(seismic);caxis([lim1,lim2]);title([num2str(i),'and',num2str(j)])
        figure;imagesc(t2);colormap(seismic);caxis([lim1,lim2]);
        figure;imagesc(t1-t2);colormap(seismic);caxis([lim1,lim2]);
    end
end

save('od.mat','od');
save('odr.mat','odr');
save('done.mat','done','-v7.3'); 