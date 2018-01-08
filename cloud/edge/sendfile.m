function sendfile(f, p)

if f~=0  

    oldpath=cd
    
    eval(['cd ', '''',p, ''''])
    FileList=dir;
    eval(['cd ', '''',oldpath, '''']);
    n=size(FileList,1);
    for i=1:n
        if strcmp(FileList(i).name,f)
            if FileList(i).bytes>6000000
                error('??????5M?')
            end
        end
    end
    fid=fopen([p f]);
    data=fread(fid);
    fclose(fid);

    tcp=tcpip('0.0.0.0',1314,'networkrole','server');          
    set(tcp,'OutputBufferSize',6000000);                        
    fopen(tcp);                                             
    fwrite(tcp,abs(f),'uint16');                           
    while tcp.BytesAvailable~=2     
        pause(0.1);
    end

    fwrite(tcp,length(data),'uint32');     
    while tcp.BytesAvailable~=4             
        pause(0.1);
    end

    fwrite(tcp,data,'uint8');
    while tcp.BytesAvailable~=6                         
        pause(0.1);
    end

    fclose(tcp);
end