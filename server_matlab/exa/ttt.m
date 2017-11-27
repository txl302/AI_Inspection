echoudp('on',4012)
u = udp('127.0.0.1',4012);
%Connect the UDP object to the host.
fopen(u)
%Write to the host and read from the host.
fwrite(u,65:74) %??????????????????????????
A = fread(u,10);
%Stop the echo server and disconnect the UDP object from the host.
echoudp('off')
fclose(u)