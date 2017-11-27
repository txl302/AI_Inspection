clc
clear all
close all

command = 11;

u3 = udp('127.0.0.1', 'RemotePort', 8012, 'LocalPort', 4013);

fopen(u3)

fwrite(u3, command)

fclose(u3)

