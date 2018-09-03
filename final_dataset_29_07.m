%%%DATASET finale per ogni gruppo di numeri 
%%%prima bw e poi resize 
%myFolder = 'C:\Users\Admin\Desktop\VITTORIA\dataset_imgs\venti'; %%change
myFolder = 'C:\Users\Vittoria\Desktop\immagini_per_numero\tre';
number = 3;
proportion = 0.21  %.125 110, .25 219 too big, .22 184
%imagesList = (fullfile(myFolder, '*.png'));
imagesList = imageDatastore(fullfile(myFolder, '*.png'));
imagesList.Files;
%pngfiles_order = dir(imagesList);
%random order of images
pgnfiles = shuffle(imagesList);
pgnfiles.Files;
%train = 75 percent test = 25 percent
train = ceil(length(imagesList.Files)*0.75)
test = floor(length(imagesList.Files)*0.25)
%create empty list
convex = [];
area = [];
images = [];
convex_test_list = [];
area_test_list = [];
images_test_list = [];
%labels for reference number
n_train = repelem(number,length(train)).';  %con transpose  %change
n_test = repelem(number,length(test)).';
%test file
for i = 1:train
    %baseFileName = pngfiles(i).name;
    %fullFileName = fullfile(myFolder, baseFileName);
    img = readimage(pgnfiles, i);
    %img = imread(fullFileName);
    I = img(:,:,1);
    I = reshape(I,[],1);
    I(I~=128)=255;
    I(I==128)=0;  %%%I è l'immagine flatten di 765625 trasformata in B e N 0=SFONDO
    RE = reshape(I,[875,875]); %%RE immagine con reshape per poter fare convexhull perchè prende 2D img 
    J = imresize(RE, proportion, 'nearest');  %resize dell'immagine con comando di default with bicubic interpolation.
    I_res = reshape(J,[],1); %immagine resize and reshape per essere solo un array 
    BINARY = I_res./255;
    CH = bwconvhull(J);
    n = nnz(CH); %%area convexhull quelli che non sono zero /che non sono sfondo
    A = nnz(I);  %%area di quelli che non sono zero 
    convex=[convex,n];
    area=[area,A];
    images=[images, BINARY];
    %subplot(2,2,1);
    %imshow(img);
    %title('Original 875x875');
    %subplot(2,2,2);
    %imshow(RE);
    %title('Black and White');
    %subplot(2,2,3);
    %imshow(J);
    %title('Black and White 110x110 nearest');
    %subplot(2,2,4);
    %imshow(CH);
    %title('Convex Hull');
end 
convex_train = convex.';
area_train = area.';
imm_train = images.';
file_name = sprintf('train_%d.mat', number)
save(file_name ,'imm_train', 'n_train', 'area_train', 'convex_train')


for i = train+1:train+test

    %baseFileName = pngfiles(i).name;
    %fullFileName = fullfile(myFolder, baseFileName);
    img = readimage(pgnfiles, i);
    %img = imread(fullFileName);
    I = img(:,:,1);
    I = reshape(I,[],1);
    I(I~=128)=255;
    I(I==128)=0;  %%%I è l'immagine flatten di 765625 trasformata in B e N 0=SFONDO
    RE = reshape(I,[875,875]); %%RE immagine con reshape per poter fare convexhull perchè prende 2D img 
    J = imresize(RE, proportion, 'nearest');  %resize dell'immagine con comando di default with bicubic interpolation.
    I_res = reshape(J,[],1); %immagine resize and reshape per essere solo un array 
    BINARY = I_res./255;
    CH = bwconvhull(J);
    n = nnz(CH); %%area convexhull quelli che non sono zero /che non sono sfondo
    A = nnz(I);  %%area di quelli che non sono zero 
    convex_test_list=[convex_test_list, n];
    area_test_list=[area_test_list, A];
    images_test_list=[images_test_list, BINARY];   
end 
convex_test = convex_test_list.';
area_test = area_test_list.';
imm_test = images_test_list.';
file_name = sprintf('test_%d.mat', number)
save(file_name ,'imm_test', 'n_test', 'area_test', 'convex_test')