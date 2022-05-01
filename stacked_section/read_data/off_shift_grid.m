function [off3,ninline,nxline]=off_shift_grid(off,N,off_coormin,off_coormax,offgridsize)

off3=off-repmat(off_coormin,[N,1]);
figure;plot(off3(:,1),off3(:,2),'linestyle','none','marker','o','markersize',6,'color','red');
xlabel('X offset (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y offset (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('offset points','FontName','Arial','FontWeight','Bold','FontSize',14);
title('shifted offset points','FontName','Arial','FontWeight','Bold','FontSize',14);




ninline=floor(off_coormax(2)/offgridsize(2))+1;
nxline=floor(off_coormax(1)/offgridsize(1))+1;


px=zeros(nxline,1);
py=zeros(ninline,1);
for i=1:nxline
    px(i)=offgridsize(1)*i;
end
for i=1:ninline
    py(i)=offgridsize(2)*i;
end
for i=1:nxline
    pxy((i-1)*ninline+1:i*ninline,:)=[repmat(px(i),[ninline,1]),py];
end

figure;plot(pxy(:,1),pxy(:,2),'linestyle','none','marker','.','markersize',6,'color','red');
hold on;plot(off3(:,1),off3(:,2),'linestyle','none','marker','o','markersize',6,'color','green');
xlabel('X offset (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('Y offset (m)','FontName','Arial','FontWeight','Bold','FontSize',14);
legend('offset bins','offset points','FontName','Arial','FontWeight','Bold','FontSize',14);
title('four red points form a offset bin','FontName','Arial','FontWeight','Bold','FontSize',14);

end

