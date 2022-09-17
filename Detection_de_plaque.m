close all;
clear all;


%img = imread('Immatriculation/image2.png'); 
img = imread('Immatriculation/image2.png');
imgray = rgb2gray(img);
BW = im2bw(imgray);
img = edge(imgray, 'prewitt');

%Les étapes ci-dessous consistent à trouver l'emplacement de la plaque
%d'immatriculation
Iprops=regionprops(bwlabel(img),'BoundingBox','Area', 'Image');
area = Iprops.Area;
count = numel(Iprops);
maxa= area;
boundingBox = Iprops.BoundingBox;
for i=1:count
   if maxa<Iprops(i).Area
       maxa=Iprops(i).Area;
       boundingBox=Iprops(i).BoundingBox;
   end
end    

img = imcrop(BW, boundingBox);%recadrer la zone de la plaque d'immatriculation
img = bwareaopen(~img, 490); %supprimer un objet si sa largeur est trop longue ou trop petite que 490
 [h, w] = size(img);%obtenir la largeur d'image

imshow(img);

Iprops=regionprops(bwlabel(img),'BoundingBox','Area', 'Image'); %lire la lettre
count = numel(Iprops);
noPlate=[]; %Initialisation de la variable de la chaîne de la plaque d'immatriculation.

for i=1:count
   Ws = length(Iprops(i).Image(1,:));
   Hs = length(Iprops(i).Image(:,1));
   if Ws<(h/2) & Hs>(h/3)
       letter=Detection_de_lettre(Iprops(i).Image); % Lecture de la lettre correspondant à l'image binaire 'N'.
       noPlate=[noPlate letter] % Ajout de chaque caractère suivant dans la variable noPlate.
   end
end