tic; 
load('data_test.mat');
s=cell(200,200); %????????
for i=1:200;
    for j=1:200;
        for k=1:201;
            b(k)=data_test_im(i,j,k);%?????
        end
    s(i,j)={[11,i,j,b]};%?????
    end
    
end
u1 = udp('127.0.0.1', 'RemotePort', 8866, 'LocalPort', 8844);%??udp????ip
u1.OutputBufferSize=8192;%???buffer??
u1.Timeout=1000;%??????
fopen(u1); 
     for i=1:200;
        for j=1:200;
            aa=s(i,j);
            A=aa{:};
           fwrite(u1,A,'float32'); %???
           pause(0.003);
        end
     end
fclose(u1);
delete(u1);
clear u1;
toc;
     