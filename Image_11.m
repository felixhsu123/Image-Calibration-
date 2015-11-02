clc;
clear all;
img_BMP = imread('2015.6.3_1.bmp','bmp');
subplot(2,2,1),imshow(img_BMP);
img_TS1 = zeros(120,160);
img_TS2 = zeros(120,160);
img_l1 = zeros(120,1);

l1 = 0.0;   %��ԭ��X��
l2 = 0.0;   %��ԭ��Y��
pi = 3.1415926; %Բ����

a = 25;       %����ͷ�ӽ�
offset_a = 35;  %����ͷƫ�ƽǶ�
h = 35;         %����ͷ�߶�
X = 160;        %ͼ����
Y = 120;         %ͼ�񳤶�
l1min = 0;
l2max = 0;
chaa = 0;
chab = 0;

for i = 1 : Y
    for j = 1 : X
        l1 = h * cot((2.0*a/Y*i - a + offset_a)*pi/180) * sin((2*a/X*j - a)*pi/180);
        l2 = h * cot((2.0*a/Y*i - a + offset_a)*pi/180);
        if(l1 < l1min)
            l1min = l1;
        end
        if(l2 > l2max)
            l2max = l2;
        end
        img_l1(i) = l1;
        img_TS1(i,j) = l1;
        img_TS2(i,j) = l2;
    end
end

mode = 1;
% 1:���ͼ������ 2:�������е�У����
subVal = 1.5;   %�е�ƫ��ֵ
startRow = 15;   %��ʼ��
curRow = img_TS2(startRow-1,1); %��
curCol = startRow-1;            %��

if(mode == 1)%���ͼ��ȼ��������ͷ��ȼ���������Լ���ʵ�м��
    fprintf('�ȼ�������飺\n');
    fanRow = zeros(Y,1);
    fprintf('{');
    for i = startRow : Y
        if(curRow - img_TS2(i,1) > subVal)
            curRow = img_TS2(i,1);
            curCol = i;
            fprintf('%2d,',curCol-1);
            fanRow(i) = i;
            for j = 1 : X
                img_reb(int16(-img_TS2(i,j)+l2max+1),int16(img_TS1(i,j)-l1min+1)) = img_BMP(i,j);
                %img_reb(i,j) = img_BMP(i,j);%���Դͼ����вɼ���Ч��
            end
        end
    end
    fprintf('};\n');
    fprintf('���ȼ�������飺\n');
    fprintf('{');
    for i = 1:Y
        if(fanRow(i)~=0)
            fprintf('%d,',uint16(fanRow(i)-1));
        else
            fprintf('0,');
        end
    end
    fprintf('};\n');
    
    curRow = img_TS2(startRow-1,1); %��
    curCol = startRow-1;            %��
    heigh = img_TS2(startRow,1) - img_TS2(Y,1);
    fprintf('�м�ࣺ\n');
    fprintf('{');
    for i = startRow:Y
        if(curRow - img_TS2(i,1) > subVal)
            curRow = img_TS2(i,1);
            curCol = i;
            fprintf('%d,',uint16(((img_TS2(i,1)-img_TS2(Y,1))/heigh)*220));
        end
    end
    fprintf('};');
elseif(mode == 2)%�������е�У����
    fprintf('{\n');
    band = 1.576;
    for i = startRow : Y
        if(curRow - img_TS2(i,j) > subVal)
            curRow = img_TS2(i,j);
            curCol = i;
            fprintf('{');
            for j = 1 : X
                %img_reb(int16(-img_TS2(i,j)+l2max+1),int16(img_TS1(i,j)-l1min+1)) = img_BMP(i,j);
                %temp = int16(img_TS1(i,j)-l1min+1);
                %(img_TS1(i,j)-l1min+1) - double(temp)
                if 0
                    if((img_TS1(i,j)-l1min+1) - double(temp) > 0.25)
                        temp = double(img_TS1(i,j)-l1min) + 1;
                    else
                        temp = double(img_TS1(i,j)-l1min);
                    end
                else
                     temp = double(img_TS1(i,j)-l1min);
                end
                img_reb(int16((-img_TS2(i,j)+l2max)+1),uint16(temp*band+1)) = img_BMP(i,j);
                fprintf('%d',uint16(temp*band-46.28));
                if(j == X)
                    fprintf('},');
                else
                    fprintf(',');
                end
            end
            fprintf('\n');
        end
    end
    fprintf('};');
elseif(mode == 3)
    fprintf('{');
    for i = startRow : Y
        if(curRow - img_TS2(i,1) > subVal)    
            curRow = img_TS2(i,1);
            fprintf('%.2f,',(3.5/(cot((2.0*a/Y*i - a + offset_a)*pi/180))));
        end
    end
    
    fprintf('};\n');
    
curRow = img_TS2(startRow-1,1); %��
    fprintf('{');
    for i = startRow : Y
        if(curRow - img_TS2(i,1) > subVal)    
            curRow = img_TS2(i,1);
            fprintf('%.2f,',2.54/(3.5/(cot((2.0*a/Y*i - a + offset_a)*pi/180))));
        end
    end
    
    fprintf('};\n');
    fprintf('%.2f',40/15.7776);
end

if 1
subplot(4,1,1);plot(img_l1);
subplot(4,1,2);plot(img_TS1,img_TS2);
subplot(4,1,3),imshow(img_BMP);
subplot(4,1,4),imshow(img_reb);
else
subplot(1,1,1),imshow(img_reb);
end
