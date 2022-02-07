function y=rd_sgy(y,traceidcut,filename,cmpcut1,offcut1,lm,M)
% read traces based on the cmp and offset number

% input
% y: empty matrix
% traceidcut: corresponding trace id
% filename: segy filename
% cmpcut1,offcut1: cmp and offset bin number (cut)
% lm: time range
% M: original trace length

% output
% y: extracted data


N=length(traceidcut);
Q=3840;
fp=fopen(filename,'r');
for i=1:N
    fseek(fp,Q+(traceidcut(i)-1)*(M*4+240),'bof');
    tr=fread(fp,[M,1],'single');
    y(:,offcut1(i,1),offcut1(i,2),cmpcut1(i,1),cmpcut1(i,2))=tr(lm);
end
end