function sr=rd_sxy_rxy(filname,M,N)
% read the x and y coordinates of the shots and receviers
% input 
% filname: segy file name in ieee little-endian format
%       M: sample number in each trace
%       N: total trace number of this file

% output 
% sr: extracted coordinates (4*N)
fp1=fopen(filname,'r');
Q1=3672;
Q2=3676;
Q3=3680;
Q4=3684;

sr=zeros(4,N);
for i=0:N-1
    fseek(fp1,Q1+i*(M*4+240),'bof');
    sr(1,i+1)=fread(fp1,[1,1],'int32');
    fseek(fp1,Q2+i*(M*4+240),'bof');
    sr(2,i+1)=fread(fp1,[1,1],'int32');
    fseek(fp1,Q3+i*(M*4+240),'bof');
    sr(3,i+1)=fread(fp1,[1,1],'int32');
    fseek(fp1,Q4+i*(M*4+240),'bof');
    sr(4,i+1)=fread(fp1,[1,1],'int32');
%     disp(i);
end
fclose(fp1);
end