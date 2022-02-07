function offxy=off_binn(off3,offgridsize,ninline,nxline)
offxy=off3*0;
off_map=zeros(ninline,nxline);
for i=1:size(off3,1)
    offxy(i,1)=floor(off3(i,1)/offgridsize(1))+1;
    offxy(i,2)=floor(off3(i,2)/offgridsize(2))+1;
    off_map(offxy(i,2),offxy(i,1))=off_map(offxy(i,2),offxy(i,1))+1;
end
% figure;imagesc(off_map);set(gca,'YDir','normal');