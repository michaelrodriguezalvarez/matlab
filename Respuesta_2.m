clc;
clear all;
close all;
%Carga de la imagen
X = imread('monedas.jpg');
%Inicializar figura
figure('name','Respuesta 2');
%Mostrar imagen original
subplot(2,2,1),subimage(X),title('Original');
%Convertir a escala de grises
Xgray = rgb2gray(X);
%Usar el método Canny para detectar lineas
Xedges=edge(Xgray,'canny',[0.25],1.5);
%Expandir los discos
Xd=imdilate(Xedges,strel('disk',31));
%Rellenar los huecos
Xf=imfill(Xd,'holes');
%Hacer que los objetos sean delgados para que evitar intercepción
Xe=imerode(Xf,strel('disk',59));
%Se realiza una apertura morfológica en la imagen binaria luego de la
%expación y reducción
Xo=imopen(Xe,strel('disk',15));
%Expandir los discos
Xdd=imdilate(Xo,strel('disk',25));
%Para identificar la cantidad de elementos
[L,num]=bwlabel(Xdd);
%Convertir la imagen de etiqueta, L, en una imagen de color RGB 
%con el fin de visualizar las regiones etiquetadas.
LColor=label2rgb(L,jet(num),[0.5,0.5,0.5]);
%Se extraen las propiedades de los elementos
stats=regionprops(L,'Area','Perimeter',...
        'Centroid','BoundingBox');
%Se obtienen las las areas
areas=cat(1, stats.Area);
%Se obtienen los perímetros
perimeters=cat(1,stats.Perimeter);
%Se obtienen los limites
bbox = cat(1,stats.BoundingBox);
%Se calcula el tamaño de los elementos para poder clasificarlos
compacidad=perimeters.^2./areas;
L2=L;
%Se separan las monedas
indmonedas=find(compacidad<14);
%Se separan los dados
inddados=find(compacidad>=14);
%Se cuentan las monedas
nummonedas=length(indmonedas);
%Se cuentan los datos
numdados=length(inddados);
%Se diferencias ambos para clasificarlos
for kk=1:length(indmonedas)
    L2(L==indmonedas(kk))=-1;
end
for kk=1:length(inddados)
    L2(L==inddados(kk))=-5;
end
clasif=label2rgb(abs(L2),jet(num),[0.5,0.5,0.5]);

subplot(2,2,2),subimage(clasif),title('Diferenciar entre monedas y dados');

L3=L;
%Se ocultan los dados para poder marcar solo las monedas
for kk=1:length(inddados)
    L3(L==inddados(kk))=0;
end
Xmonedas = label2rgb(L3, jet(num), [0.5,0.5,0.5]);

%Mantengo la imagen anterior para poder etiquetar las monedas
hold on
statsMonedas=regionprops(L3,'Area','Perimeter',...
        'Centroid','BoundingBox');
%Extraigo la propiedad de centro para las monedas
%Con el objetivo de marcarlas
centroids = cat(1,statsMonedas.Centroid);

%Para cada moneda se especifica en el centro un asterisco de color rojo
%Además de la palabra moneda de color rojo y tamaño de fuente 7
plot (centroids(:,1),centroids(:,2),'r*')
for k=1:length(indmonedas)
    text(centroids(indmonedas(k),1)+100,...
        centroids(indmonedas(k),2),['Moneda'],...
        'color','r','fontsize',7,'fontweight','bold');
end

    
