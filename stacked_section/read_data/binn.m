function cmpxy=binn(cmp3,cmpgridsize,minline,mxline)
% assign cmp number for each trace and plot fold map

% input 
% cmp3: shifted cmp coordinates
% minline,mxline: total number of the inlines and xlines
% cmpgridsize: cmp bin size

% output
% cmpxy: cmp number

cmpxy=cmp3*0;
foldmap=zeros(minline,mxline);
for i=1:size(cmp3,1)
    cmpxy(i,1)=floor(cmp3(i,1)/cmpgridsize(1))+1;
    cmpxy(i,2)=floor(cmp3(i,2)/cmpgridsize(2))+1;
    foldmap(cmpxy(i,2),cmpxy(i,1))=foldmap(cmpxy(i,2),cmpxy(i,1))+1;
end
figure;imagesc(foldmap);set(gca,'YDir','normal');
xlabel('xline','FontName','Arial','FontWeight','Bold','FontSize',14);
ylabel('inline','FontName','Arial','FontWeight','Bold','FontSize',14);
title('fold map','FontName','Arial','FontWeight','Bold','FontSize',14);