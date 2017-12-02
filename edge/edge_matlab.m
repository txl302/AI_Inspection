clc
clear all
close all

pause(5)

import java.awt.Robot;
import java.awt.event.*;

robot = java.awt.Robot;

u2 = udp('192.168.0.147', 8012, 'LocalPort', 4012);
u2.timeout = 1000;

fopen(u2)

source = 'D:\astra_TTT\AstraSDK-0.5.0-20160426T102744Z-vs2015-win64\samples\vs2015\bin\Debug\sc.png'
destination_dir = 'D:\Midea_AI_Inspection\raw\'

n_cap = 0

while 1
    
    cmd = fread(u2, 100);
    
    if cmd == 11
        
        n_cap = n_cap + 1
        
        robot.keyPress    (java.awt.event.KeyEvent.VK_F1);
        robot.keyRelease  (java.awt.event.KeyEvent.VK_F1);
        
        filename = strcat(date, '-',num2str(n_cap), '.png');
        
        pause(2)

        movefile(source, strcat(destination_dir, filename))
        
        fwrite(u2, 111)
        
        sendfile(filename, destination_dir)
        
        
        
    else if cmd == 20
            
            fclose(u2)
            break
            
        end
        
        
    end

end

