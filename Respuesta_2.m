clc;
clear all;
close all;
%Carga de la imagen
X = imread('monedas.jpg');
%Inicializar figura
figure('name','Respuesta 2');
%Mostrar imagen original
subplot(2,2,1),subimage(X),title('Original');

Xgray = rgb2gray(X);

Xedges=edge(Xgray,'canny',[0.25],1.5);

Xd=imdilate(Xedges,strel('disk',31));

Xf=imfill(Xd,'holes');

Xe=imerode(Xf,strel('disk',59));

Xo=imopen(Xe,strel('disk',15));

Xdd=imdilate(Xo,strel('disk',25));

[L,num]=bwlabel(Xdd);
LColor=label2rgb(L,jet(num),[0.5,0.5,0.5]);

stats=regionprops(L,'Area','Perimeter',...
        'Centroid','BoundingBox');
areas=cat(1, stats.Area);
perimeters=cat(1,stats.Perimeter);
bbox = cat(1,stats.BoundingBox);
compacidad=perimeters.^2./areas;
L2=L;
indmonedas=find(compacidad<14);
inddados=find(compacidad>=14);
nummonedas=length(indmonedas);
numdados=length(inddados);
for kk=1:length(indmonedas)
    L2(L==indmonedas(kk))=-1;
end
for kk=1:length(inddados)
    L2(L==inddados(kk))=-5;
end
clasif=label2rgb(abs(L2),jet(num),[0.5,0.5,0.5]);

subplot(2,2,2),subimage(clasif),title('Diferenciar entre monedas y dados');

L3=L;
for kk=1:length(inddados)
    L3(L==inddados(kk))=0;
end
Xmonedas = label2rgb(L3, jet(num), [0.5,0.5,0.5]);

hold on
statsMonedas=regionprops(L3,'Area','Perimeter',...
        'Centroid','BoundingBox');
centroids = cat(1,statsMonedas.Centroid);

plot (centroids(:,1),centroids(:,2),'r*')
for k=1:length(indmonedas)
    text(centroids(indmonedas(k),1)+100,...
        centroids(indmonedas(k),2),['Moneda'],...
        'color','r','fontsize',7,'fontweight','bold');
end

    
