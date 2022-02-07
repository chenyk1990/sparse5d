% This script use 2D DRR filter to process the sorted 2D gather
% The user can replace this filter with their own suitable filter to get a
% faster and more satisfactory result.

% read 5D patch data and the offset correction
clear;close all;
load('../prepare_ini_model/y1ini.mat');
load('../read_data/OffInfo.mat');
s=y;
s=s./max(max(max(max(max(s)))))*8;
[nt,cx,cy,nx,ny]=size(s);

clear y;
%1) ploting CMP gather
lim1=-0.3;lim2=0.3;
xl=5;
figure;imagesc(reshape(s(:,:,:,xl,xl),nt,size(s,2)*size(s,3)));colormap(seismic);caxis([lim1,lim2]);
% 
%2) ploting common offset gather
figure;imagesc(reshape(s(:,30,5,:,:),nt,size(s,4)*size(s,5)));colormap(seismic);caxis([lim1,lim2]);
%%
% corresponds to eq.3-4, Fig.3
% calculate absolute offsets and reorder 3d cmp to 2d cmp gather
tic;
ste=rng;
rng(ste);
rd=rand(cx,cy)*0.01;

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
toc;


s4=zeros(nt,cx*cy,size(s,4),size(s,5));
for i=1:nx
    for j=1:ny
        s4(:,:,i,j)=gather3dto2d(s(:,:,:,i,j),odr);
    end
end

%%
% use 2D DRR filter to process the sorted 2D gather
tic;
done=s*0;
flow=10;fhigh=100;dt=0.004;N=10;K=2;verb=1;

parfor lin_num=1:nx*ny
    % linear index for parfor
    [it,jt]=ind2sub([nx,ny],lin_num);
    i=it;
    j=jt;
    % The user can replace this filter with their own suitable filter to
    % get a faster and more satisfactory result.
    sup4=fxydmssa(s4(:,:,i,j),flow,fhigh,dt,N,K,verb);
    % change 2D gather back to 3D format
    done(:,:,:,lin_num)=gather2dto3d(sup4,odr);
    lin_num
end
toc;

%1) ploting CMP gather
figure;imagesc(reshape(done(:,:,:,5,5),nt,cx*cy));colormap(seismic);caxis([lim1,lim2]);
%2) ploting common offset gather
figure;imagesc(reshape(done(:,30,5,:,:),nt,nx*ny));colormap(seismic);caxis([lim1,lim2]);