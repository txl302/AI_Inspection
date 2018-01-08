function getfile(ip)
tcp=tcpip(ip,1314);
set(tcp,'InputBufferSize',6000000);
fopen(tcp);
while tcp.BytesAvailable==0
    pause(0.1);
end
filename=fread(tcp,tcp.BytesAvailable/2,'uint16');
filename=char(filename);
filename=filename';
fwrite(tcp,1314,'uint16');
while tcp.BytesAvailable==0
    pause(0.1);
end

filesize=fread(tcp,1,'uint32')

fwrite(tcp,1314,'uint16'); 
while tcp.BytesAvailable~=filesize
    pause(0.5);
end
data=fread(tcp,filesize,'uint8');
fwrite(tcp,1314,'uint16');

fid=fopen(filename,'w');
fwrite(fid,data,'uint8');
fclose(fid);
fclose(tcp);