
clc;clear; close all;
A=imread('Input.png');
Resolution=1; % micron/pixel
if size(A,3)==3
    A=rgb2gray(A);
end
A=im2bw(A,graythresh(A));
A=bwmorph(A,'majority',5);
Conn=8;
[s1,s2]=size(A);
P=bwperim(A);
At=s1*s2;       % Total surface
Ag=sum(sum(A)); %Area of grains
Ap=sum(sum(~A)); %Area of non-grains
Perim=sum(sum(P));

Specific_surface_macerals_2D=Perim/Resolution/Ap
Porosity=Ap/At


%Outputs

figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
imshow(A)
imwrite(P,'Output.png')
subplot(1,2,2)
imshow(P)
annotation('textbox',[.2 .85 .1 .1], 'String', [ 'Porosity = ' num2str(Porosity) ' (ratio)'])