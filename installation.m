clc
clear all 
close all

if ~exist('D:\Midea_AI_Inspection')
    mkdir('D:\Midea_AI_Inspection');
    mkdir('D:\Midea_AI_Inspection\train');
    mkdir('D:\Midea_AI_Inspection\test');
    mkdir('D:\Midea_AI_Inspection\raw');
    mkdir('D:\Midea_AI_Inspection\standard')
else
    if ~exist('D:\Midea_AI_Inspection\train')
        mkdir('D:\Midea_AI_Inspection\train');
    end
    if ~exist('D:\Midea_AI_Inspection\test')
        mkdir('D:\Midea_AI_Inspection\test');
    end
    if ~exist('D:\Midea_AI_Inspection\raw')
        mkdir('D:\Midea_AI_Inspection\raw');
    end
    if ~exist('D:\Midea_AI_Inspection\standard')
        mkdir('D:\Midea_AI_Inspection\standard');
    end

end

fprintf("Installation successful! Thanks!\n")



fprintf("Installing the the following part")