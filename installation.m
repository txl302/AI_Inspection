clc
clear all 
close all

a = 'C:\Users\txl30\Desktop\Midea_AI_Inspection';
if ~exist(a)
    mkdir('C:\Users\txl30\Desktop\Midea_AI_Inspection');
    mkdir('C:\Users\txl30\Desktop\Midea_AI_Inspection\train');
    mkdir('C:\Users\txl30\Desktop\Midea_AI_Inspection\test');
    mkdir('C:\Users\txl30\Desktop\Midea_AI_Inspection\detection');
end

fprintf("Installation successful! Thanks!\n")