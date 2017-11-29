clc
clear all
close all

import java.awt.Robot;
import java.awt.event.*;

robot = java.awt.Robot;

u2 = udp('127.0.0.1', 8012, 'LocalPort', 4012);






robot.keyPress    (java.awt.event.KeyEvent.VK_F1);
robot.keyRelease  (java.awt.event.KeyEvent.VK_F1);