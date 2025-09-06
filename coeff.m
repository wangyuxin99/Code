clc;clear;
files=dir(['F:\2global\02pwv lapse rate\5\year_hour/*.mat']);%修改路径
filenumber=length(files);
filename=sort_nat({files.name}');%读取的文件名
filedz={files.folder}';%读取的文件地址
for i=1:filenumber
    filedz{i,2}=char('\');
    filedz{i,3}=strcat(filedz{i,1},filedz{i,2},filename{i,1});
    filename_1=filename{i,1}(:,1:end-4);
    grid_hour_lapse=importdata(filedz{i,3});
    a=linspace(2008,2018,300)';
    for j=1:size(grid_hour_lapse)
        t=double(grid_hour_lapse{j,2}(:,1)+grid_hour_lapse{j,2}(:,2)/365.25);%年加年积日
        r_t=double(grid_hour_lapse{j,2}(:,4));%递减率
        string=['A1+A2*(t)+A3*cos(2*pi*(t))+A4*sin(2*pi*(t))+A5*cos(4*pi*(t))+A6*sin(4*pi*(t))'];
        f=fittype(string,'independent',{'t'},'coefficients',{'A1','A2','A3','A4','A5','A6'});
        func=fit(t,r_t,f,'StartPoint',[-1.188,0.0003641,-0.01887,0.003444,0.01008,0.0157]);
        result{j,1}=func(a);
        result{j,2}=r_t;
        coeff(j,1)=func.A1;
        coeff(j,2)=func.A2;
        coeff(j,3)=func.A3;
        coeff(j,4)=func.A4;
        coeff(j,5)=func.A5;
        coeff(j,6)=func.A6;
        clear r_t func
    end
    file='F:\2global\03coeff\coeff_1(A)\5\';
    name_1=[filename_1,'coeff_1.mat'];
    savepath=[file,name_1];
    save(savepath,'coeff');
    hod=double((1:24)');
    hod_smooth=linspace(1,24,288)';
    for k=1:size(coeff,2)
        A=double(coeff(:,k));
        string1=['a1+a2*cos(2*pi*(hod/24))+a3*sin(2*pi*(hod/24))+a4*cos(4*pi*(hod/24))+a5*sin(4*pi*(hod/24))'];
        f=fittype(string1,'independent',{'hod'},'coefficients',{'a1','a2','a3','a4','a5'});
        func1=fit(hod,A,f,'StartPoint',[-1.638,0.2099,-0.7858,0.07509,0.06007]);
        result_2{k,1}=A;
        result_2{k,2}=func1(hod_smooth);
        coeff_2(k,1)=func1.a1;
        coeff_2(k,2)=func1.a2;
        coeff_2(k,3)=func1.a3;
        coeff_2(k,4)=func1.a4;
        coeff_2(k,5)=func1.a5;
        clear A func1
    end
    name_2=[filename_1,'coeff_2.mat'];
    save(name_2,'coeff_2')
    clear filename_1 grid_hour_lapse
end



