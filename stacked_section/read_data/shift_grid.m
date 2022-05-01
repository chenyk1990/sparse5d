function [cmp3,sr3,minline,mxline]=shift_grid(sr2,cmp,N,ori_coormin,ori_coormax,cmpgridsize)
% shift the sr2 and cmp again, and plot the geometry
% input
% sr2: shots and receivers coordinates from last step
% cmp: cmp coordinates from last step
%  N : total trace number
% ori_coormin: min coordinates in x and y directions
% ori_coormax: max ...
% cmpgridsize: cmp bin size

% output
% cmp3, sr3: shifted coordinates
% minline,mxline: total number of the inlines and xlines

% plot shots, receivers and cmps
sr3=sr2-repmat([ori_coormin,ori_coormin],[N,1]);
cmp3=cmp-repmat(ori_coormin,[N,1]);
figure;plot(cmp3(:,1),cmp3(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
hold on;plot(sr3(:,1),sr3(:,2),'linestyle','none','marker','x','markersize',6,'color','green');
hold on;plot(sr3(:,3),sr3(:,4),'linestyle','none','marker','o','markersize',6,'color','blue');
xlabel('X coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('cmp points','source','recevier','FontName','Arial','FontWeight','Bold','FontSize',14);
title('source, receiver and cmp points (shifted)','FontName','Arial','FontWeight','Bold','FontSize',14);


% calculate total number of the inlines and xlines
minline=floor(ori_coormax(2)/cmpgridsize(2));
mxline=floor(ori_coormax(1)/cmpgridsize(1));

% plot cmp bins and cmp points
px=zeros(mxline,1);
py=zeros(minline,1);
for i=1:mxline
    px(i)=cmpgridsize(1)*i;
end
for i=1:minline
    py(i)=cmpgridsize(2)*i;
end
for i=1:mxline
    pxy((i-1)*minline+1:i*minline,:)=[repmat(px(i),[minline,1]),py];
end
figure;plot(pxy(:,1),pxy(:,2),'linestyle','none','marker','.','markersize',6,'color','red');
hold on;plot(cmp3(:,1),cmp3(:,2),'linestyle','none','marker','o','markersize',6,'color','green');
xlabel('X coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y coordinate (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('cmp bins','cmp points','FontName','Arial','FontWeight','Bold','FontSize',14);
title('four red points form a cmp bin','FontName','Arial','FontWeight','Bold','FontSize',14);
end

