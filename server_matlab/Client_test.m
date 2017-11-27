clc
clear all
close all


u2 = udp('127.0.0.1', 'LocalPort', 4012);

fopen(u2)

while 1

A = fread(u2,10)

end

fclose(u2)