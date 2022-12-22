function dneudt = lpnnlca(t, neu, anc, ri1, rho, thrs1, thrs2, thrs3)

%t: time
%Neurons are held in neu = [x', d', w', u', lambda']' \in R^{6L+k-2}
%anc: receiver (anchor) position matrix \in R^{k \times L} 
%ri1: TDOA-based RD measurement vector \in R^{L-1}
%rho: augmented Lagrangian parameter
%thrs1, thrs2, thrs3 are predefined parameters of the thresholding function

[k, L] = size(anc);

D = [-ones(L-1,1),eye(L-1)];


dneudt = zeros(6*L+k-2, 1);


%dx/dt
for i = 1:L
    dneudt(1:k) = dneudt(1:k) - 2*neu(k+L+L+L-1+L-1+i)*(anc(:,i) - neu(1:k)) - 2*rho*(neu(k+i)^2 - norm(neu(1:k) - anc(:,i))^2)*(anc(:,i)-neu(1:k));
end

e_vec = zeros(L-1,1);

for i = 2:L
    e_vec(i-1) = sign(neu(k+L+L+i-1))*((abs(neu(k+L+L+i-1))-thrs1*thrs3)/(1+exp((-thrs2)*(abs(neu(k+L+L+i-1))-thrs3))));
end

%ddi/dt
for i = 1:L
    xb1 = D'*neu(k+L+L+L-1+1:k+L+L+L-1+L-1);
    xb2 = D'*(ri1 - e_vec - D*neu(k+1:k+L));
    dneudt(k+i) = xb1(i) - 2*neu(k+L+L+L-1+L-1+i)*neu(k+i) + rho*( xb2(i) - 2*(neu(k+i)^2 - norm(neu(1:k) - anc(:,i))^2)*neu(k+i) - (neu(k+i) - neu(k+L+i)^2) )  - neu(k+L+L+L-1+2*L-1+i);
end


%dwi/dt
for i = 1:L
    dneudt(k+L+i) = 2*neu(k+L+L+L-1+2*L-1+i)*neu(k+L+i) + 2*rho*(neu(k+i) - neu(k+L+i)^2)*neu(k+L+i);
end


%du/dt
dneudt(k+L+L+1:k+L+L+L-1) = -neu(k+L+L+1:k+L+L+L-1) + e_vec + neu(k+L+L+L-1+1:k+L+L+L-1+L-1) + (ri1 - e_vec - D*neu(k+1:k+L))*rho;





for i = 2:L
    e_vec(i-1) = sign(neu(k+L+L+i-1))*((abs(neu(k+L+L+i-1))-thrs1*thrs3)/(1+exp((-thrs2)*(abs(neu(k+L+L+i-1))-thrs3))));
end
%dlambda{i-1}/dt
for i = 2:L
    dneudt(k+L+L+L-1+i-1) = ri1(i-1) - e_vec(i-1) - neu(k+i) + neu(k+1);
end

%dlambda{L-1+i}/dt
for i = 1:L
    dneudt(k+L+L+L-1+L-1+i) = (neu(k+i)^2-norm(neu(1:k) - anc(:,i))^2);
end

%dlambda{2L-1+i}/dt
for i = 1:L
    dneudt(k+L+L+L-1+2*L-1+i) = (neu(k+i)-neu(k+L+i)^2);
end

end

