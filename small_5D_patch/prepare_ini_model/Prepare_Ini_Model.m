% This script prepare the initial model

%read data
clear;close all;
load ../read_data/y1.mat;
s=y;
s=s./max(max(max(max(max(s)))));
[nt,cx,cy,nx,ny]=size(s);
s1=s;
clear s y ym;

% padding 
widx=4;
widy=4;
s2=padarray(s1,[0,0,0,widx,widy],'circular');

% s3 for storing initial model
s3=s2(:,:,:,widx+1:widx+nx,widy+1:widy+ny)*0;

% linear index for using parfor
parfor lin_num=1:nx*ny
    [it,jt]=ind2sub([nx,ny],lin_num);
    i=it+widx;
    j=jt+widy;
    %define the local area
    tp1=s2(:,:,:,i-widx:i+widx,j-widy:j+widy);
    %prepare the initial model
    tp11=ini_mod(tp1,0);
    s3(:,:,:,lin_num)=tp11;
    lin_num./(nx*ny)% processing percent
end

y=s3;
save('y1ini.mat','y','-v7.3');