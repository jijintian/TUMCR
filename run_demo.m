
%Code for TUMCR, MATLAB R2021a;

clear;
clc
folder_now = pwd;
addpath([folder_now, '\funs']);
addpath([folder_now, '\dataset']);
dataname=["Yale","MSRCv1","NGs","BBCSport","Caltech101-7","Caltech101-20"];

for it_name = 1:length(dataname)
%%========load unligned dataset and parameters============================
    load(strcat('unaligned_data/Unaligned_',dataname(it_name),'.mat'));
    load(strcat('result/result_',dataname(it_name),'.mat'));   
    cls_num=length(unique(gt));
    nV = length(X_new);
    Zc=1;
    
    anc =[2*cls_num,3*cls_num,4*cls_num];   
    
    alpha = record(1);
    gamma = record(2);
    theta = record(3);
    delta = record(4);
    p = record(5);
    [y,U,Z,G,P,converge_Z,converge_Z_G] = Train_problem(X_new, cls_num, anc(1:p),alpha,gamma,theta,delta,Zc);
    time = toc;
    [result,res]=  ClusteringMeasure(gt, y);
    disp('Result for '+dataname(it_name)+':')    
    disp(result)    
    %% ============================ For new datasets==============================
     %%==============Construct new unligned dataset============================
     
%     load(strcat('dataset/',dataname(it_name),'.mat'));
%     cls_num=length(unique(truelabel{1}));
%     X=data';
%     gt = truelabel{1};
%     nV = length(X);
%     for v=1:nV
%         [X{v}]=NormalizeData(X{v});
%     end
%     Zc=1;
%     [X_new,mapping] = shuffle_data(X,Zc);
%     save('.\unaligned_data\Unaligned_'+dataname(it_name),'X_new','gt','Zc','mapping')
% 
%     result=[];
%     num = 0;
%     max_val=0;
%     record_num = 0;
%     ii=0;
%     max_i =0;
%     anc =[2*cls_num,3*cls_num,4*cls_num];  
%     
%     for i_alpha = -3:1:0
%         for i_gamma = -3:1:3
%             for i_theta = -3:1:0
%                 for i_delta = -3:1:0
%                     for a =1 :3
%                         alpha = 10^(i_alpha);
%                         gamma = 10^(i_gamma);
%                         theta = 10^(i_theta);
%                         delta=10^(i_delta);
%                         ii=ii+1;
%                         tic;
%                         [y,U,Z,G,P,converge_Z,converge_Z_G] = Train_problem(X_new, cls_num, anc(1:a),alpha,gamma,theta,delta,Zc);
%                         time = toc;
%                         [result(ii,:),res]=  ClusteringMeasure(gt, y);
%                         if result(ii,1) >= max_val
%                             max_val = result(ii,1);
%                             record = [alpha,gamma,theta,delta,a,time];
%                             record_result = result(ii,:)
%                             record_time = time;
%                         end
%                     end
%                 end
%             end
%         end
%     end
%  save('.\result\result_'+dataname(it_name),'record','max_val','record_result','time')
end
