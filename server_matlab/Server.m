clc
clear all
close all

u_edge = udp('192.168.0.126', 4012, 'LocalPort', 8012);
u_mobile = udp('127.0.0.1', 4013, 'LocalPort', 8013);

u_edge.timeout = 1000;
u_edge.OutputBufferSize=8192;
u_edge.InputBufferSize=8192;

u_mobile.timeout = 1000;
u_mobile.OutputBufferSize=8192;
u_mobile.InputBufferSize=8192;

fopen(u_edge)
fopen(u_mobile)

current_image_c = '';
current_image_d = '';

try
    
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
                
                fwrite(u_edge, 10)

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
                
                a = dir('D:\Midea_AI_Inspection\raw');
                n = length(a);
                
                source = strcat(strcat(a(n).folder, '\', a(n).name));
                destination = 'D:\Midea_AI_Inspection\standard';
                
                copyfile(source,destination)
                
                b = dir('D:\Midea_AI_Inspection\standard');
                n = length(b);
                
                source_standard_img = strcat(strcat(b(n).folder, '\', b(n).name));
                standard_img = imread(source_standard_img);
                
            case 11
                
                fprintf('capturing...\n')
                fwrite(u_edge, 11)
                
                rec = fread(u_edge, 100)
                
                if  rec == 111
                    
                    getfile('192.168.0.126')
                    
                    fprintf('capturing...done!')
                    
                end
                
                source = 'D:\astra_TTT\AstraSDK-0.5.0-20160426T102744Z-vs2015-win64\samples\vs2015\bin\Debug\sc.png';
                destination_dir = 'D:\Midea_AI_Inspection\raw\'; 
                
                dt = fix(clock);
                
                org_name = strcat(num2str(dt(1)), num2str(dt(2)), num2str(dt(3)), num2str(dt(4)), num2str(dt(5)), num2str(dt(6)));
                filename = strcat(org_name,  '.png');
                
                movefile(c(3).name, 'D:\Midea_AI_Inspection\raw')
                
                fwrite(u_mobile, 111)
                
                
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
                
                fwrite(u_edge, 20)
                
                fwrite(u_mobile, 20)
                
                fprintf('disconnect\n')
                
                fclose(u_edge)
                fclose(u_mobile)
                break
                
        end
        
    end
    
catch
    
    fclose(u_edge)
    fclose(u_mobile)
    
    fprintf('disconnect\n')
    
end