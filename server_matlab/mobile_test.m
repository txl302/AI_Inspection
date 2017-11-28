clc
clear all
close all

%command:

%10: initialization

%101: dot set

%11: capture image
%12: detection

%13: trainning
%14: testing

%15: load model
%16: unload model

%17: dataset making 

%14: extra command
%20: disconnect

command = 101;

n = 5

u3 = udp('127.0.0.1', 'RemotePort', 8013, 'LocalPort', 4013);

fopen(u3)

fwrite(u3, 10)

fwrite(u3, 101)

fwrite(u3, n)

for i = 1:n
    
    c = [i, i+1, i+2, i+3]
    
    fwrite(u3, c)
    
    r = [i, 2*i, 3*i, 4*i]
    
    fwrite(u3, r)
    
end

fwrite(u3, 20)

fclose(u3)

