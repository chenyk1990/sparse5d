%This is the manuscript that reads data segment from original segy file
%and bins it onto a regular grid and saves it as mat file.

clear;close all;

% four corner coordinates of this survey area
xy=[273507	4572239;
285327	4563004;
279633	4580080;
291453	4570845];
% get direction vector, shift and rotate the four corners
[ag,xy1,xy2]=shft_rot_corners(xy);

% read the x and y coordinates of the shots and receviers for each trace
filename='ieee1.sgy';%
M=3001;%sample number in each trace
N=342720;%total trace number of this file
sr=floor(rd_sxy_rxy(filename,M,N)'./10);%extracted coordinates
% shift and rotate the coordinates of the shots and receviers
[sr1,sr2]=shft_rot_sr(sr,ag,xy);


% plot shifted geometry
figure;plot(xy1(:,1),xy1(:,2),'linestyle','none','marker','*','markersize',6,'color','red');
hold on;plot(sr1(:,1),sr1(:,2),'linestyle','none','marker','x','markersize',6,'color','green');
hold on;plot(sr1(:,3),sr1(:,4),'linestyle','none','marker','o','markersize',6,'color','blue');
xlabel('X coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('four corner','source','recevier','FontName','Arial','FontWeight','Bold','FontSize',14);

% plot shifted and then rotated geometry
figure;plot(xy2(:,1),xy2(:,2),'linestyle','none','marker','*','markersize',6,'color','red');
hold on;plot(sr2(:,1),sr2(:,2),'linestyle','none','marker','x','markersize',6,'color','green');
hold on;plot(sr2(:,3),sr2(:,4),'linestyle','none','marker','o','markersize',6,'color','blue');
xlabel('X coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('four corner','source','recevier','FontName','Arial','FontWeight','Bold','FontSize',14);

%%
% bin cmpx and y

% calculate cmpx and y (shifted)
cmpx=(sr1(:,1)+sr1(:,3))/2;
cmpy=(sr1(:,2)+sr1(:,4))/2;

% rotated cmp coordinates
sta=-angle(ag);
rot=[cos(sta)   sin(sta);
    -sin(sta)   cos(sta);];
cmp=[cmpx cmpy]*rot;

figure;plot(cmp(:,1),cmp(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
hold on;plot(sr2(:,1),sr2(:,2),'linestyle','none','marker','x','markersize',6,'color','green');
hold on;plot(sr2(:,3),sr2(:,4),'linestyle','none','marker','o','markersize',6,'color','blue');
xlabel('X coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('cmp points','source','recevier','FontName','Arial','FontWeight','Bold','FontSize',14);
title('source, receiver and cmp points','FontName','Arial','FontWeight','Bold','FontSize',14);


% set the coordinate range for cmp binning
ori_coormin=[-5000,9500];ori_coormax=[11000,2500];
cmpgridsize=[25,50];
% shift cmp coordinate again and plot grid
[cmp3,sr3,minline,mxline]=shift_grid(sr2,cmp,N,ori_coormin,ori_coormax,cmpgridsize);
% assign cmp number for each trace and plot fold map
cmpxy=binn(cmp3,cmpgridsize,minline,mxline);
%%
% bin offsetx and y

% calculate offset and plot
off(:,1)=sr3(:,3)-sr3(:,1);
off(:,2)=sr3(:,4)-sr3(:,2);
figure;plot(off(:,1),off(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
xlabel('X offset (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y offset (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('offset points','FontName','Arial','FontWeight','Bold','FontSize',14);
title('offset points','FontName','Arial','FontWeight','Bold','FontSize',14);

% shift and bin in the same way as cmp dimensions
off_coormin=[-3975,-1500];off_coormax=[9000,3000];offgridsize=[50,100];%[50,100];
[off3,ninline,nxline]=off_shift_grid(off,N,off_coormin,off_coormax,offgridsize);
offxy=off_binn(off3,offgridsize,ninline,nxline);
%%
% define a patch to cut, save corresponding cmp bin number, offset bin number and
% trace id

% cmp bin range
cr1=71;
cr2=390;
in1=28;
in2=37;
% offset bin range
ox1=40;
ox2=100;
oy1=10;
oy2=20;

clear cmpcut offcut traceidcut;% sr3cut;
N=size(cmpxy,1);
k=1; % count the total number of cut traces

% assign a unique id for each trace
traceid=(1:N)';
for i=1:N
    if cmpxy(i,1)>=cr1&&cmpxy(i,1)<=cr2&&cmpxy(i,2)>=in1&&cmpxy(i,2)<=in2 ...
    && offxy(i,1)>=ox1&&offxy(i,1)<=ox2&&offxy(i,2)>=oy1&&offxy(i,2)<=oy2
        cmpcut(k,:)=cmpxy(i,:);
        offcut(k,:)=offxy(i,:);
        traceidcut(k)=traceid(i);
%         sr3cut(k,:)=sr3(i,:);
        k=k+1;
    end
end
Ncut=k-1; % total number of cut traces

% plot the cut area (both cmp and offset)
figure;plot(cmpcut(:,1),cmpcut(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
xlabel('xline','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('inline','FontName','Arial','FontWeight','Bold','FontSize',14);
figure;plot(offcut(:,1),offcut(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
xlabel('xoffset bin number','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('yoffset bin number','FontName','Arial','FontWeight','Bold','FontSize',14);


% shift the cut area
cmpcut1=cmpcut-repmat(min(cmpcut),[Ncut,1])+1;
offcut1=offcut-repmat(min(offcut),[Ncut,1])+1;

% plot the shifted cut area
figure;plot(cmpcut1(:,1),cmpcut1(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
xlabel('xline','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('inline','FontName','Arial','FontWeight','Bold','FontSize',14);
figure;plot(offcut1(:,1),offcut1(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
xlabel('xoffset bin number','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('yoffset bin number','FontName','Arial','FontWeight','Bold','FontSize',14);
%%
% extract the corresponding traces in the cut area, save it to mat
%
nx=max(cmpcut1(:,1));
ny=max(cmpcut1(:,2));
cx=max(offcut1(:,1));
cy=max(offcut1(:,2));

% time range
lm=1:3:1500;

m=length(lm);

y=single(zeros(m,cx,cy,nx,ny));
y=rd_sgy(y,traceidcut,filename,cmpcut1,offcut1,lm,M);

save('y.mat','y','-v7.3');
%%
%%%%%%%%%%% save offset infomation for the latter 2D filtering processing
offx_correction=(ox1-2)*offgridsize(1)+offgridsize(1)/2+off_coormin(1);
offy_correction=(oy1-2)*offgridsize(2)+offgridsize(2)/2+off_coormin(2);
save('OffInfo.mat','offx_correction','offy_correction','offgridsize');