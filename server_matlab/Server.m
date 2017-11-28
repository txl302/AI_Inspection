clc
clear all
close all

capture = 10;

u_edge = udp('127.0.0.1', 4012, 'LocalPort', 8012);
u_mobile = udp('127.0.0.1', 4013, 'LocalPort', 8013);

fopen(u_edge)
fopen(u_mobile)

didb.images.data = [];
didb.images.label = [];
didb.images.set = [];

while 1
    
    B = fread(u_mobile,10);
    
    switch B
        
        case 10
            fprintf('Initializating...')
            
            fwrite(u_edge, capture)
            
            a = dir('D:\Midea_AI_Inspection\raw');
            n = length(a);
            
            source = strcat(strcat(a(n).folder, '\', a(n).name));
            destination = 'D:\Midea_AI_Inspection\standard';
            
            copyfile(source,destination)
            
            b = dir('D:\Midea_AI_Inspection\standard');
            n = length(b);
            
            source_standard_img = strcat(strcat(b(n).folder, '\', b(n).name));
            standard_img = imread(source_standard_img);
            
            fwrite(u_mobile, 101)
            
            fprintf('done!\n')
            
        case 101
            
            fprintf('receiving dot set...\n')
            
            n_parts = fread(u_mobile, 100)
            
            for i = 1:n_parts
                c(:,i) = fread(u_mobile, 100)
                r(:,i) = fread(u_mobile, 100)
                
                BW(:,:,i) = roipoly(standard_img, c(:,i), r(:,i));
                
            end
            
            
            fprintf('receiving done!')
            
        case 11
            
            fprintf('capturing...\n')
            fwrite(u_edge,capture)
            
            fprintf('capturing...done!')
            
        case 12
            
            fprintf('detection\n')
            
            a = dir('D:\camera\raw');
            n = length(a);
            
            img = imread(strcat(a(n).folder, '\', a(n).name));
            imshow(img);
            
        case 13
            fprintf('trainning\n')
            
        case 14
            
            fprintf('extra command\n')
            
        case 15
            
            fprintf('loading model\n')
            
            fprintf('model loaded\n')
            
        case 16
            
            fprintf('unloading model\n')
            
        case 17
            
            fprintf('making dataset\n')
            a = dir('D:\camera\train\0');
            
            n_current = 0;
            
            for j = 1:n_parts

                for i = 3:length(a)
                    n_current = n_current + 1;
                    img = imread(strcat(a(i).folder, '\', a(i).name));
                    gray = rgb2gray(img);
                    
                    didb.images.data(:,:,n_current) = gray;
                    didb.images.label = [didb.images.label, 2];
                    didb.images.set = [didb.images.set, 1];
                end
                
            end
            
            fwrite(u_mobile, 121)
            
        case 20
            
            fprintf('disconnect\n')
            fclose(u_edge)
            fclose(u_mobile)
            break
            
    end
    
end

fclose(u_edge)
fclose(u_mobile)