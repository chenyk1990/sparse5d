clear; close all;
% This is the manuscript doing nmo correction and stacking

%read original data and processed data
load ../read_data/y.mat
y=y(:,:,:,:,5);
load ../2Dfilter/done.mat

%read offset data and velocity field
load ../2Dfilter/od.mat
load ../2Dfilter/odr.mat
load Vp.mat
%%
%do nmo correction for the original and processed data
t=(1:size(done,1))*0.006;
nmos=done*0;
nmoso=done*0;
parfor i=1:size(done,4)
    s=gather3dto2d(done(:,:,:,i),odr);
    so=gather3dto2d(y(:,:,:,i),odr);
    sup1=nmor(s,t',od',v(:,i));
    sup2=nmor(so,t',od',v(:,i));
    nmos(:,:,:,i)=gather2dto3d(sup1,odr);
    nmoso(:,:,:,i)=gather2dto3d(sup2,odr);
    i
end
%%
%plot the nmo correction results
for i=1:size(done,4)
   
    t1=gather3dto2d(nmos(:,:,:,i),odr);
    t2=gather3dto2d(done(:,:,:,i),odr);
    
    lim1=-0.003;lim2=0.003;
    if mod(i,50)==0 &&i>=10&&i<=300
        figure;imagesc(t1);colormap(seismic);caxis([lim1,lim2]);title([num2str(i),'and',num2str(j)])
        figure;imagesc(t2);colormap(seismic);caxis([lim1,lim2]);
    end
    
    i
       
    t1=gather3dto2d(nmoso(:,:,:,i),odr);
    t2=gather3dto2d(y(:,:,:,i),odr);
    
    lim1=-0.003;lim2=0.003;
    if mod(i,50)==0 &&i>=10&&i<=300
        figure;imagesc(t1);colormap(seismic);caxis([lim1,lim2]);title([num2str(i),'and',num2str(j)])
        figure;imagesc(t2);colormap(seismic);caxis([lim1,lim2]);
    end
    
    i
    
end
%%
% stack both datasets
stk=zeros(size(done,1),size(done,4));
stko=zeros(size(done,1),size(done,4));
parfor i=1:size(done,4)
    ct=sum(nmos)~=0;cout=sum(ct(:));
    sup=gather3dto2d(nmos(:,:,:,i),odr);
    stk(:,i)=sum(sup,2)./cout;
    i
end

parfor i=1:size(done,4)
    ct=sum(nmoso)~=0;cout=sum(ct(:));
    sup1=gather3dto2d(nmoso(:,:,:,i),odr);
    stko(:,i)=sum(sup1,2)./cout;
    i
end
%%
%plot the both stacking results
stkg=gain1(stk(83:500,:),0.006,'agc',0.7,0);
figure;imagesc(stkg);colormap(seismic);
x1=600;y1=600;dx=300;dy=500;
set(gcf,'position',[x1,y1,dx,dy]);

stkgo=gain1(stko(83:500,:),0.006,'agc',0.7,0);
figure;imagesc(stkgo);colormap(seismic);set(gcf,'position',[x1,y1,dx,dy]);