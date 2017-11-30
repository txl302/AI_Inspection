clc
clear all
close all

capture = 10;

u_edge = udp('127.0.0.1', 4012, 'LocalPort', 8012);
u_mobile = udp('127.0.0.1', 4013, 'LocalPort', 8013);

u_edge.timeout = 1000;
u_edge.OutputBufferSize=8192;
u_edge.InputBufferSize=8192;

u_mobile.timeout = 1000;
u_mobile.OutputBufferSize=8192;
u_mobile.InputBufferSize=8192;

fopen(u_edge)
fopen(u_mobile)

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
            
            fwrite(u_mobile, 10)
            
            fprintf('done!\n')
            
        case 101
            
            fprintf('receiving dot set...\n')
            
            for i = 1:n_parts
                c(:,i) = fread(u_mobile, 100, 'float')
                r(:,i) = fread(u_mobile, 100, 'float')
                
                BW(:,:,i) = roipoly(standard_img, c(:,i), r(:,i));
 
            end
            
            fprintf('receiving done!')
            
            %imshow(BW(:,:,1));
            
        case 102
            
            fprintf('setting...')
            
            n_parts = fread(u_mobile, 100)
            
            for i = 1:n_parts
                
                eval(['didb.sample',num2str(i),'.data','=','[]',';']);
                eval(['didb.sample',num2str(i),'.label','=','[]',';']);
                eval(['didb.sample',num2str(i),'.set','=','[]',';']);
                
            end
            
        case 11
            
            fprintf('capturing...\n')
            fwrite(u_edge,capture)
            
            fprintf('capturing...done!')
            
        case 12
            
            fprintf('detection\n')
            
            a = dir('D:\Midea_AI_Inspection\raw');
            n = length(a);
            
            img = imread(strcat(a(n).folder, '\', a(n).name));
            %imshow(img);
            
            gray_detect = rgb2gray(img);
 
            DS = [];
            
            for i = 1:n_parts
                
                gray_detect_c = double(gray_detect).*double(BW(:,:,i));
                
                %gray = mat2gray(gray);
                
                xt = Bfx_lbp(gray_detect_c, [], options);
                
                %ds = Bcl_svm(Xt,op)
                eval(['ds','=','Bcl_svm(xt, op',num2str(i),')',';']);
                
                DS = [DS, ds];
            end
            
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
            
            fprintf('extra command\n')
            
        case 15
            
            fprintf('loading model\n')
            
            fprintf('model loaded\n')
            
        case 16
            
            fprintf('unloading model\n')
            
        case 17
            
            fprintf('making dataset\n')
            a = dir('D:\Midea_AI_Inspection\train\');

            o_path = strcat('D:\Midea_AI_Inspection\train\', num2str(0), '\')
            
            o_dir = dir(o_path);
            
            for j = 1:n_parts
                
                n_current = 0;
                
                for i = 3:length(o_dir)
                    n_current = n_current + 1;
                    
                    img = imread(strcat(o_dir(i).folder, '\', o_dir(i).name));
                    gray_train = rgb2gray(img);
                    
                    gray_train_c = double(gray_train).*double(BW(:,:,j));
                    
                    %gray = mat2gray(gray);
                    
                    eval(['didb.sample',num2str(j),'.data(:,:,n_current)','=','gray_train_c',';']);
                    eval(['didb.sample',num2str(j),'.label','=','[didb.sample',num2str(j),'.label, 1]',';']);
                    eval(['didb.sample',num2str(j),'.set','=','[didb.sample',num2str(j),'.set, 1]',';']);

                end
                
                n_path = strcat('D:\Midea_AI_Inspection\train\', num2str(j), '\')
                
                n_dir = dir(n_path)
                
                for i = 3:length(n_dir)
                    n_current = n_current + 1;
                    img = imread(strcat(n_dir(i).folder, '\', n_dir(i).name));
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

            fclose(u_edge)
            fclose(u_mobile)
            break
            
    end
    
end

fclose(u_edge)
fclose(u_mobile)