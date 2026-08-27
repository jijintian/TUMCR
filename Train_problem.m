function [labels,U,Z,G,P,converge_Z,converge_Z_G] = Train_problem(X, cls_num, anc,alpha,gamma,theta,delta,Zc)
% X is a cell data, each cell is a matrix in size of d_v *N,
% each column is a sample

nV = length(X);
N = size(X{1},2);
t=anc; %The number of the anchors
Nt = length(t);

nC=cls_num;
%% ============================ Initialization ============================
for k=1:nV
    X{k}=X{k}';
    P{k} = eye(N);
    G{k}= zeros(N,nC);
    J{k} = zeros(N,nC);
    I{k} = zeros(N,nC);
end

for q = 1: Nt
    for k=1:nV
        Z{q,k} = zeros(N,t(q));
        H{q,k} = zeros(t(q),size(X{k},2));
    end
end
beta = zeros(1,q);
for q=1:Nt
    W{q}= zeros(nC,t(q));
    beta(q)=1/Nt;
end

Ii = zeros(N*nC*nV,1);
j = zeros(N*nC*nV,1);
sX = [N, nC, nV];


Isconverg = 0;epson = 1e-4;
iter = 0;
pho_mu = 2;
rho = 0.0001;
max_rho = 10e12;
pho_rho = 2;

converge_Z=[];
converge_Z_G=[];


%% ================================ Upadate ===============================
while(Isconverg == 0)
    
    %% ============================== Upadate Z^k =============================
    for q =1:Nt
        for k =1:nV
            if k==Zc
                tmp = alpha*beta(q)*P{k}'*G{k}*W{q}+2*gamma*X{k}*H{q,k}';
                [Zu,Zs,Zv] = svd(tmp,'econ');
                Z{q,k}=Zu*Zv';
            else
                tmp = alpha*beta(q)*P{k}'*G{k}*W{q}+2*gamma*X{k}*H{q,k}'+2*theta*P{k}'*Z{q,Zc};
                [Zu,Zs,Zv] = svd(tmp,'econ');
                Z{q,k}=Zu*Zv';
            end
        end
    end
    clear k
    
    %% =========================== Upadate G^k ===========================
    for k =1:nV
        tmpG = zeros(N,nC);
        for q =1:Nt
        tmpG = tmpG + alpha*beta(q)*P{k}*Z{q,k}*W{q}';
        end
        tmpG = tmpG-I{k}-J{k};
        [Gu,Gs,Gv] = svd(tmpG,'econ');
        G{k}=Gu*Gv';
    end
    %% ============================= Upadate P^k ==============================
    for k =1:nV
        if k == Zc
            P{k}=eye(N);
        else
            tmpP = zeros(N,N);
            for q =1:Nt
                tmpP = tmpP +alpha*beta(q)*G{k}*W{q}*Z{q,k}'+2*theta*Z{q,Zc}*Z{q,k}';
            end
            tmpP =tmpP';
            [Pu,Ps,Pv] = svd(tmpP,'econ');
            P{k}=Pu*Pv';
          %  [P{k}] = DSPFP(tmpP);
        end
    end
    %% ============================= Upadate J^k ==============================
        
        G_tensor = cat(3, G{:,:});
        I_tensor = cat(3, I{:,:});
        g = G_tensor(:);
        Ii = I_tensor(:);
        
        J_tensor = solve_G(G_tensor + 1/rho*I_tensor,rho,sX,delta);
        j = J_tensor(:);
        
        %nuclear
%          [j,objV] = wshrinkObj(G_tensor + 1/rho*I_tensor,1/rho,sX,0,3);
%          J_tensor=reshape(j, sX);  

        %% ============================== Upadate I ===============================
        Ii = Ii + rho*(g - j);
        I_tensor = reshape(Ii, sX);
        for k=1:nV
            I{k} = I_tensor(:,:,k);
        end
    
    %%================ Update H{q,v}=========================
    for q =1:Nt
        for k = 1 :nV
            H{q,k} = Z{q,k}'*X{k};
        end
    end
    
    
    %%================== Update W{q}===========================================
      for q =1:Nt
          tmpW = zeros(nC,t(q));
          for k =1:nV
              tmpW = tmpW+G{k}'*P{k}*Z{q,k};
          end
        [Wu,~,Wv] = svd(tmpW,'econ');
        W{q}=Wu*Wv';
      end
     %%================== Update beta===========================================
     yita = zeros(1,Nt);
     for q = 1:Nt
         for k = 1:nV
         yita(q) = yita(q)+ trace(G{k}*W{q}*Z{q,k}'*P{k}');
         end
     end
     yita_sum = sqrt(sum(yita.^2));
          for q = 1:Nt
              beta(q)=yita(q)/yita_sum;
          end 
    %% ====================== Checking Coverge Condition ======================
    max_Z_G=0;
    Isconverg = 1;
        for k=1:nV
            J{k} = J_tensor(:,:,k);
            if (norm(G{k}-J{k},inf)>epson)
                history.norm_Z_G = norm(G{k}-J{k},inf);
                Isconverg = 0;
                max_Z_G=max(max_Z_G, history.norm_Z_G);
            end
        end
    converge_Z_G=[converge_Z_G max_Z_G];
    
    
    if (iter>25)
        Isconverg  = 1;
    end
    
    iter = iter + 1;
    rho = min(rho*pho_rho, max_rho);
end 
Sbar=[];
for i = 1:nV
    Sbar=cat(1,Sbar,1/sqrt(nV)*G{i}');
end

[U,Sig,V] = mySVD(Sbar',nC);

rand('twister',5489)
labels=litekmeans(U, nC, 'MaxIter', 100,'Replicates',10);%kmeans(U, c, 'emptyaction', 'singleton', 'replicates', 100, 'display', 'off');
end
