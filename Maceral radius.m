clc;clear; close all;
% INPUTS
A=imread('Input.png');
Resolution=20; % micron/pixel
Number_of_categories=10;

% CALCULATIONS
A=im2bw(A,graythresh(A));
Conn=8;
[s1,s2]=size(A);
A=bwmorph(A,'majority',10);
Poro=sum(sum(~A))/(s1*s2);
D=-bwdist(A,'cityblock');
B=medfilt2(D,[3 3]);
B=watershed(B,Conn);
Pr=zeros(s1,s2);

for I=1:s1
    for J=1:s2
        if A(I,J)==0 && B(I,J)~=0
            Pr(I,J)=1;
        end
    end
end
Pr=bwareaopen(Pr,9,Conn);
[Pr_L,Pr_n]=bwlabel(Pr,Conn);
V=zeros(Pr_n,1);
for I=1:s1
    for J=1:s2
        if Pr_L(I,J)~=0
            V(Pr_L(I,J))=V(Pr_L(I,J))+1;
        end
    end
end
R=Resolution.*(V./pi).^0.5; % Pore radius


%Outputs
Average_pore_radius_micron=mean(R)
Standard_deviation_of_pore_radius_micron=std(R)
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
imshow(label2rgb(Pr_L))
imwrite(label2rgb(Pr_L),'Output.png')
subplot(1,2,2)
Rel_Frequencies=hist(R,[1:round(max(R)/Number_of_categories):round(max(R))])./sum(sum(hist(R,[1:round(max(R)/Number_of_categories):round(max(R))]))); 
bar([1:round(max(R)/Number_of_categories):round(max(R))],Rel_Frequencies); 
xlabel('pore-rdius/¦Ìm '); ylabel('Frequency (%)'); axis([1 max(R) 0 max(Rel_Frequencies)]); axis square;
annotation('textbox',[.2 .85 .1 .1], 'String', [ 'Average pore radius = ' num2str(Average_pore_radius_micron) ' ¦Ìm '])