%Limpieza de elementos previos
clc;
clear all;
close all;
%Carga de la imagen
OriginalImg = imread('letras.tif');
%Inicializar figura
figure('name','Respuesta 1');
% Pasando a la escala de grises
img=rgb2gray(OriginalImg);
% Eliminación de ruido con el filtro med
MedImg = medfilt2(img,[5 5]);
%Mostrar imagen original
subplot(2,2,1),subimage(OriginalImg),title('Original');
%Mostrar imagen mejorada
subplot(2,2,2),subimage(MedImg),title('Mejorada');
%Calcular el umbral (se normaliza en el rango [0, 1]) utilizando graythresh.
Umbral = graythresh(MedImg);
%Convertir la imagen en escala de grises en imagen binaria BW
ImagenBw = im2bw(MedImg, Umbral * 1.5);
%Convertir valores numéricos en lógicos
LogicalValues = logical(ImagenBw);
%Mostrar imagen segmentada
subplot(2,2,3),subimage(LogicalValues),title('Segmentada');
%Obtener las mediciones del conjunto de propiedades de cada objeto
Propiedades = regionprops(LogicalValues);
%Recorrer todos los objetos
for i = 1 : length(Propiedades)
   caja = Propiedades(i).BoundingBox;
   %Mostrar rectangulo de color rojo para cada objeto
   rectangle('Position', [caja(1), caja(2), caja(3), caja(4)],...
        'EdgeColor', 'r', 'LineWidth', 1)
end




