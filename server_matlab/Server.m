clc
clear all
close all

capture = 10;

u_server = udp('127.0.0.1','RemotePort', 4012, 'LocalPort', 8012);


fopen(u_server)

while 1

B = fread(u_server,10)

fwrite(u_server,capture)

end

fclose(u_server)