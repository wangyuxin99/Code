clc;clear;
files=dir(['E:\data-wang\all grid\3/*.mat']);
filenumber=length(files);
filename=sort_nat({files.name}');%读取的文件名
filedz={files.folder}';
for k=1:filenumber
    filedz{k,2}=char('\');
    filedz{k,3}=strcat(filedz{k,1},filedz{k,2},filename{k,1});
end
for i=1:filenumber
    filename_1=filename{i,1}(:,1:end-4);
    grid_data=importdata(filedz{i,3});
    k=0;
    for jj=1:23:size(grid_data,1)
        k=k+1;
        hour_data=grid_data(jj:jj+22,:);
        H=double(hour_data(:,4)/1000);%单位为KM
        pwv=double(hour_data(:,5));%单位为mm
        string=['a*exp(b*H)'];
        f=fittype(string,'independent',{'H'},'coefficients',{'a','b'});
        func=fit(H,pwv,f,'StartPoint',[52.29,-0.000481]);%拟合函数
        T=func.b;%mm/km
        year_lapse(k,1:3)=hour_data(1,1:3);
        year_lapse(k,4)=T;
        clear hour_data H pwv T
    end
    file='E:\data-wang\pwv_lapse\3\year\';
    name=[filename_1,'lapse.mat'];
    savepath=[file,name];
    save(savepath,'year_lapse');
    %分小时存储
    for k=1:24
        n=0;
        for kk=k:24:size(year_lapse,1)
            n=n+1;
            hour_lapse{k,1}=k;
            hour_lapse{k,2}(n,:)=year_lapse(kk,:);
        end
        clear n
    end
    name=[filename_1,'hour_lapse.mat'];
    save(name,'hour_lapse');
    clear  filename_1  grid_data 
end
