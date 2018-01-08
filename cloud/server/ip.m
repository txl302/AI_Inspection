function ip
[s r]=system('ipconfig')
r=regexp(r,'IPv4 Address. . . . . . . . . . . : \d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}','match')
r=r{1};
r=regexp(r,'\d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}','match');
lip=r{1};
disp(['IP is ',lip]);