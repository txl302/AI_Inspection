clc
clear all
close all

a = dir('train/0/');

I = imread(strcat('train/0/', a(3).name));

n = input('The number of parts: ');


for i = 1:n
    
    [BW, cn(:,i), rn(:,i)] = roipoly(I);

    r = I(:,:,1);
    g = I(:,:,2);
    b = I(:,:,3);
    
    r1 = double(r).*double(BW);
    g1 = double(g).*double(BW);
    b1 = double(b).*double(BW);
    
    I_f(:,:,:,i) = cat(3, r1, g1, b1);

end

for i = 1:n
    
    num = str2double(strcat('23',num2str(i)));

    subplot(num),imshow(mat2gray(I_f(:,:,:,i)));

end

%make training dataset for each part

didb.images.data = [];
didb.images.label = [];
didb.images.set = [];

Dtrain_o = dir(strcat('train/0/'));
Dtest_o = dir(strcat('test/0/'));

for j = 1:n
    
    didb.images.data = [];
    didb.images.label = [];
    didb.images.set = [];
    
    BW = roipoly(I, cn(:,j), rn(:,j));

    n_current = 0;
    
    %make train dataset

    Dtrain_n = dir(strcat('train/', num2str(j), '/'));
    
    for i = 3:length(Dtrain_o)
        
        n_current = n_current + 1;
        
        img = imread(strcat('train/0/', Dtrain_o(i).name));
        gray = rgb2gray(img);
        
        gray = double(gray).*double(BW);
        
        didb.images.data(:,:,n_current) = gray;
        didb.images.label = [didb.images.label, 1];
        didb.images.set = [didb.images.set, 1];
    end
    
    for i = 3:length(Dtrain_n)
        
        n_current = n_current + 1;
        
        img = imread(strcat('train/', num2str(j), '/', Dtrain_n(i).name));
        gray = rgb2gray(img);
        
        gray = double(gray).*double(BW);
        
        didb.images.data(:,:,n_current) = gray;
        didb.images.label = [didb.images.label, 2];
        didb.images.set = [didb.images.set, 1];
    end
    
    %make test dataset
    
    Dtest_n = dir(strcat('test/', num2str(j), '/'));
    
    for i = 3:length(Dtest_o)
        
        n_current = n_current + 1;
        
        img = imread(strcat('test/0/', Dtest_o(i).name));
        gray = rgb2gray(img);
        
        gray = double(gray).*double(BW);
        
        didb.images.data(:,:,n_current) = gray;
        didb.images.label = [didb.images.label, 1];
        didb.images.set = [didb.images.set, 3];
    end
    
    for i = 3:length(Dtest_n)
        
        n_current = n_current + 1;
        
        img = imread(strcat('test/', num2str(j), '/', Dtest_n(i).name));
        gray = rgb2gray(img);
        
        gray = double(gray).*double(BW);
        
        didb.images.data(:,:,n_current) = gray;
        didb.images.label = [didb.images.label, 2];
        didb.images.set = [didb.images.set, 3];
    end
    
    %test
    
%     subsampling = 1;
%     im1         = didb.images.data(:,:,1);
     i1          = find(didb.images.set<=2)';
     i2          = find(didb.images.set==3)';
%     i1          = i1(1:subsampling:end);
%     i2          = i2(1:subsampling:end);
%     ix_train    = [didb.images.label(i1)' i1];
%     ix_test     = [didb.images.label(i2)' i2];
%     imageMean   = mean(didb.images.data(:)) ;
    
    options.vdiv = 1;
    options.hdiv = 1;
    options.semantic = 0;
    options.samples  = 8;
    options.mappingtype = 'u2';
    
    X = [];
    for i = 1:1:size(i1)
        im = didb.images.data(:,:,i1(i));
        x = Bfx_lbp(im, [], options);
        X = [X; x];
        p = i/size(i1,1);
        fprintf('train data Feature extraction.......%5.2f%%\n\n',p*100);
    end
    d = didb.images.label(i1)';
    
    Xt = [];
    for j = 1:1:size(i2)
        imt = didb.images.data(:,:,i2(j));
        xt = Bfx_lbp(imt, [], options);
        Xt = [Xt; xt];
        pt = j/size(i2,1);
        fprintf('test data Feature extraction.......%5.2f%%\n\n',pt*100);
    end
    dt = didb.images.label(i2)';
    
    op.kernel = 1;
%     fprintf('Training.......');
%     op = Bcl_svm(X,d,op);
    %
    % fprintf('Testing.......');
    % ds = Bcl_svm(Xt,op);
    
    fprintf('Training & Testing.......');
    ds = Bcl_svm(X,d,Xt,op);
    
    p = Bev_performance(ds,dt)
    
    %save the dataset
    
    %save(num2str(j), 'didb');
    
    clear didb
end


