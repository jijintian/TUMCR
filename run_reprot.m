
clear;
clc

folder_now = pwd;
addpath([folder_now, '\funs']);
dataname=["MSRCv1"];                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
%% ==================== Load Datatset and Normalization ===================
for it_name = 1:length(dataname)
    load(strcat('unaligned_data/Unaligned_',dataname(it_name),'.mat'));
    load(strcat('result/result_6_',dataname(it_name),'.mat'));
    cls_num=length(unique(gt));

    nV = length(X_new);
    Zc=1;
    
    
    %% ========================== Parameters Setting ==========================
    result=[];
    num = 0;
    max_val=0;
    record_num = 0;
    ii=0;
    max_i =0;
    anc =[2*cls_num,3*cls_num,4*cls_num];
    %% ============================ Optimization ==============================
      alpha = record(1);
    gamma = record(2);
    theta = record(3)
    delta = record(4);
    p = record(5);
     [y,U,Z,G,P,converge_Z,converge_Z_G] = Train_problem3(X_new, cls_num, anc(1:p),alpha,gamma,theta,delta,Zc);
    time = toc;
    [result,res]=  ClusteringMeasure(gt, y);
    result
     save('.\result\result_6_Geman_'+dataname(it_name),'result')
    for v = 1: length(X_new)
    a1{v} = mappingsACC(P{v},mapping{v},1);
    a2{v} = mappingsACC(P{v},mapping{v},3);
    a3{v} = mappingsACC(P{v},mapping{v},3);
    end
end

