clc
clear all
close all

import java.awt.Robot;
import java.awt.event.*;

robot = java.awt.Robot;

%u_mobile = udp('192.168.0.126', 4013, 'LocalPort', 8013);
u_mobile = udp('169.254.125.42', 4013, 'LocalPort', 8013);

u_mobile.timeout = 1000;
u_mobile.OutputBufferSize=8192;
u_mobile.InputBufferSize=8192;

fopen(u_mobile)

n_cap = 0;

current_image_c = '';
current_image_d = '';
% 
% try
    
    while 1
        
        B = fread(u_mobile,10);
        
        switch B
            
            case 10
                fprintf('Initializating...')
                
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
                
                source = 'D:\astra_TTT\AstraSDK-0.5.0-20160426T102744Z-vs2015-win64\samples\vs2015\bin\Debug\sc.png';
                
                while exist(source)
                    
                    delete 'D:\astra_TTT\AstraSDK-0.5.0-20160426T102744Z-vs2015-win64\samples\vs2015\bin\Debug\sc.png';
                    
                end
                
                fwrite(u_mobile, 10)
                
                fprintf('done!\n')
                
            case 101
                
                fprintf('receiving dot set...\n')
                
                for i = 1:n_parts
                    
                    %fread(u_mobile, 100, 'float')
                    c(:,i) = fread(u_mobile, 100, 'float')
                    r(:,i) = fread(u_mobile, 100, 'float')
                    
                    BW(:,:,i) = roipoly(standard_img, c(:,i), r(:,i));
                    
                end
                
                %set the timeout time and continue progress
                
                fprintf('receiving done!')
                
                %imshow(BW(:,:,1));
                
            case 102
                
                fprintf('n_parts setting...')
                
                n_parts = fread(u_mobile, 100)
                
                for i = 1:n_parts
                    
                    eval(['didb.sample',num2str(i),'.data','=','[]',';']);
                    eval(['didb.sample',num2str(i),'.label','=','[]',';']);
                    eval(['didb.sample',num2str(i),'.set','=','[]',';']);
                    
                end
                
                fprintf('n_parts setting done!')
                
            case 103
                
                fprintf('weights setting')
                
                weights = [];
                
                for i = 1:n_parts
                    
                    weights(:,i) = fread(u_mobile, 10);
                    
                end
                
            case 104
                
                
                fprintf('uploading ok sample ...')
                
                d_train_OK_d = 'D:\Midea_AI_Inspection\train\Depth\0\';
                d_train_OK_c = 'D:\Midea_AI_Inspection\train\Color\0\';
                
                d_raw = 'D:\Midea_AI_Inspection\raw\'
                
                copyfile(strcat(d_raw, filename_d), d_train_OK_d);
                copyfile(strcat(d_raw, filename_c), d_train_OK_c);
                
                fprintf('uploading done!')
                
                
                
            case 105
                
                fprintf('uploading ng sample...')
                
                part_n = fread(u_mobile, 10);
                
                d_train_NG_d = 'D:\Midea_AI_Inspection\train\Depth\';
                d_train_NG_c = 'D:\Midea_AI_Inspection\train\Color\';
                d_raw = 'D:\Midea_AI_Inspection\raw\'
                
                copyfile(strcat(d_raw, filename_d), strcat(d_train_NG_d, num2str(part_n), '\'));
                copyfile(strcat(d_raw, filename_c), strcat(d_train_NG_c, num2str(part_n), '\'));
                
                fprintf('uploading done!')
                
            case 106
                
                fprintf('setting standard image...')
                
                source = current_image_c;
                destination = 'D:\Midea_AI_Inspection\standard';
                
                copyfile(source,destination)
                
                b = dir('D:\Midea_AI_Inspection\standard');
                n = length(b);
                
                source_standard_img = strcat(strcat(b(n).folder, '\', b(n).name));
                standard_img = imread(source_standard_img);
                
            case 11
                
                fprintf('capturing...\n')
                
                source = 'D:\astra_TTT\AstraSDK-0.5.0-20160426T102744Z-vs2015-win64\samples\vs2015\bin\Debug\sc.png';
                destination_dir = 'D:\Midea_AI_Inspection\raw\';
                
                
                robot.keyPress    (java.awt.event.KeyEvent.VK_F1);
                robot.keyRelease  (java.awt.event.KeyEvent.VK_F1);
                
                dt = fix(clock);
                
                org_name = strcat(num2str(dt(1)), num2str(dt(2)), num2str(dt(3)), num2str(dt(4)), num2str(dt(5)), num2str(dt(6)));
                filename = strcat(org_name,  '.png');
                
                while ~exist(source)
                    
                    pause(0.1);
                    
                end
                
                movefile(source, strcat(destination_dir, filename));
                
                org = imread(strcat(destination_dir, filename));
                depth = org(:,1:900,:);
                color = org(:,901:1800,:);
                
                filename_c = strcat(org_name,  '_c.png');
                filename_d = strcat(org_name,  '_d.png');
                
                
                imwrite(color, strcat(destination_dir, filename_c));
                imwrite(depth, strcat(destination_dir, filename_d));
                
                fwrite(u_mobile, 111)
                
                sendfile(filename_c, destination_dir);
                
                current_image_c = strcat(destination_dir, filename_c);
                current_image_d = strcat(destination_dir, filename_d);
                
                %fwrite(u_mobile, 112)
                
                
            case 12
                
                %capture image
                
                fprintf('capturing...\n')
                
                source = 'D:\astra_TTT\AstraSDK-0.5.0-20160426T102744Z-vs2015-win64\samples\vs2015\bin\Debug\sc.png';
                destination_dir = 'D:\Midea_AI_Inspection\raw\';
                
                
                robot.keyPress    (java.awt.event.KeyEvent.VK_F1);
                robot.keyRelease  (java.awt.event.KeyEvent.VK_F1);
                
                dt = fix(clock);
                
                org_name = strcat(num2str(dt(1)), num2str(dt(2)), num2str(dt(3)), num2str(dt(4)), num2str(dt(5)), num2str(dt(6)));
                filename = strcat(org_name,  '.png');
                
                while ~exist(source)
                    
                    pause(0.5);
                    
                end
                
                movefile(source, strcat(destination_dir, filename));
                
                org = imread(strcat(destination_dir, filename));
                depth = org(:,1:900,:);
                color = org(:,901:1800,:);
                
                filename_c = strcat(org_name,  '_c.png');
                filename_d = strcat(org_name,  '_d.png');
                
                imwrite(color, strcat(destination_dir, filename_c));
                imwrite(depth, strcat(destination_dir, filename_d));
                
                fwrite(u_mobile, 111)
                
                sendfile(filename_c, destination_dir);
                
                current_image_c = strcat(destination_dir, filename_c);
                current_image_d = strcat(destination_dir, filename_d);
                
                %detection
                
                fprintf('detection\n')
                
                img = imread(current_image_d);
                
                gray_detect = rgb2gray(img);
                
                DS = [];
                
                %dddddddddddddddddddddddddd
                for i = 1:1
                    
                    gray_detect_c = double(gray_detect).*double(BW(:,:,i));
                    
                    %gray = mat2gray(gray);
                    
                    xt = Bfx_lbp(gray_detect_c, [], options);
                    
                    %ds = Bcl_svm(Xt,op)
                    eval(['ds','=','Bcl_svm(xt, op',num2str(i),')',';']);
                    
                    DS = [DS, ds];
                end
                
                %cccccccccccccccccccccccc
                
                img = imread(current_image_c);
                
                gray_detect = rgb2gray(img);
                
                for i = 2:n_parts
                    
                    gray_detect_c = double(gray_detect).*double(BW(:,:,i));
                    
                    %gray = mat2gray(gray);
                    
                    xt = Bfx_lbp(gray_detect_c, [], options);
                    
                    %ds = Bcl_svm(Xt,op)
                    eval(['ds','=','Bcl_svm(xt, op',num2str(i),')',';']);
                    
                    DS = [DS, ds];
                end
                
                %
                
                fwrite(u_mobile, 12)
                
                fwrite(u_mobile, DS)
                
                
                
                fprintf('Detection done!\n')
                
            case 13
                fprintf('trainning\n')
                
                options.vdiv = 1;
                options.hdiv = 1;
                options.semantic = 0;
                options.samples  = 8;
                options.mappingtype = 'u2';
                
                for j = 1:n_parts
                    
                    X = [];
                    
                    eval(['i1','=','find','(','didb.sample',num2str(j),'.set<=2',')',';']);
                    
                    for i = 1:1:length(i1)
                        
                        eval(['im','=','didb.sample',num2str(j),'.data(:,:,i1(i))',';']);
                        
                        x = Bfx_lbp(im, [], options);
                        X = [X; x];
                        
                        p = i/length(i1);
                        fprintf('train data Feature extraction.......%5.2f%%\n\n',p*100);
                    end
                    
                    %d = didb.images.label(i1)';
                    eval(['d','=','didb.sample',num2str(j),'.label(i1)',';']);
                    
                    eval(['op',num2str(j),'.kernel','=','1',';']);
                    
                    fprintf('Training.......');
                    
                    eval(['op',num2str(j),'=','Bcl_svm(X,d,op',num2str(j),')',';']);
                    
                end
                %
                % fprintf('Testing.......');
                % ds = Bcl_svm(Xt,op);
                
                fwrite(u_mobile, 13)
                
                fprintf('Trainning done!\n')
                
            case 14
                
                fprintf('feature setting\n')
                
                
                
            case 15
                
                fprintf('saving model\n')
                
                save op op;
                
                fprintf('model saved\n')
                
            case 16
                
                fprintf('loading model\n')
                
                load('op.mat');
                
                fprintf('load model done!\n')
                
            case 17
                
                fprintf('making dataset\n')
                %a = dir('D:\Midea_AI_Inspection\train\');
                
                o_path_d = strcat('D:\Midea_AI_Inspection\train\Depth\', num2str(0), '\')
                
                o_dir_d = dir(o_path_d);
                
                %dddddddddddddddd
                for j = 1:1
                    
                    n_current = 0;
                    
                    for i = 3:length(o_dir_d)
                        n_current = n_current + 1;
                        
                        img = imread(strcat(o_dir_d(i).folder, '\', o_dir_d(i).name));
                        gray_train = rgb2gray(img);
                        
                        gray_train_c = double(gray_train).*double(BW(:,:,j));
                        
                        %gray = mat2gray(gray);
                        
                        eval(['didb.sample',num2str(j),'.data(:,:,n_current)','=','gray_train_c',';']);
                        eval(['didb.sample',num2str(j),'.label','=','[didb.sample',num2str(j),'.label, 1]',';']);
                        eval(['didb.sample',num2str(j),'.set','=','[didb.sample',num2str(j),'.set, 1]',';']);
                        
                    end
                    
                    n_path_d = strcat('D:\Midea_AI_Inspection\train\Depth\', num2str(j), '\')
                    
                    n_dir_d = dir(n_path_d)
                    
                    for i = 3:length(n_dir_d)
                        n_current = n_current + 1;
                        img = imread(strcat(n_dir_d(i).folder, '\', n_dir_d(i).name));
                        gray_train = rgb2gray(img);
                        
                        gray_train_c = double(gray_train).*double(BW(:,:,j));
                        
                        eval(['didb.sample',num2str(j),'.data(:,:,n_current)','=','gray_train_c',';']);
                        eval(['didb.sample',num2str(j),'.label','=','[didb.sample',num2str(j),'.label, 2]',';']);
                        eval(['didb.sample',num2str(j),'.set','=','[didb.sample',num2str(j),'.set, 1]',';']);
                    end
                    
                end
                
                %cccccccccccccccc
                
                o_path_c = strcat('D:\Midea_AI_Inspection\train\Color\', num2str(0), '\')
                
                o_dir_c = dir(o_path_c);
                
                for j = 2:n_parts
                    
                    n_current = 0;
                    
                    for i = 3:length(o_dir_c)
                        n_current = n_current + 1;
                        
                        img = imread(strcat(o_dir_c(i).folder, '\', o_dir_c(i).name));
                        gray_train = rgb2gray(img);
                        
                        gray_train_c = double(gray_train).*double(BW(:,:,j));
                        
                        %gray = mat2gray(gray);
                        
                        eval(['didb.sample',num2str(j),'.data(:,:,n_current)','=','gray_train_c',';']);
                        eval(['didb.sample',num2str(j),'.label','=','[didb.sample',num2str(j),'.label, 1]',';']);
                        eval(['didb.sample',num2str(j),'.set','=','[didb.sample',num2str(j),'.set, 1]',';']);
                        
                    end
                    
                    n_path_c = strcat('D:\Midea_AI_Inspection\train\Color\', num2str(j), '\')
                    
                    n_dir_c = dir(n_path_c)
                    
                    for i = 3:length(n_dir_c)
                        n_current = n_current + 1;
                        img = imread(strcat(n_dir_c(i).folder, '\', n_dir_c(i).name));
                        gray_train = rgb2gray(img);
                        
                        gray_train_c = double(gray_train).*double(BW(:,:,j));
                        
                        eval(['didb.sample',num2str(j),'.data(:,:,n_current)','=','gray_train_c',';']);
                        eval(['didb.sample',num2str(j),'.label','=','[didb.sample',num2str(j),'.label, 2]',';']);
                        eval(['didb.sample',num2str(j),'.set','=','[didb.sample',num2str(j),'.set, 1]',';']);
                    end
                    
                end
                
                %save didb didb
                
                fwrite(u_mobile, 17)
                
                fprintf('data set making done!\n')
                
            case 20
                
                fwrite(u_mobile, 20)
                
                fprintf('disconnect\n')
                
                fclose(u_mobile)
                break
                
        end
        
    end
    
% catch
%     
%     fclose(u_mobile)
%     
%     fprintf('disconnect\n')
%     
% end