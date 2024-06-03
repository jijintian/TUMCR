function y = rank_fun_derivative1(x,delta)
%y  = (exp(-x./delta).*x+2*delta*exp(-x./delta))./(2*delta.*(x.^2+exp(-x./delta)).*sqrt(x.^2+exp(-x./delta)));
y  = delta*exp(delta^2)./((x+delta).^2+eps);
%y = delta./(delta+x).^2;
%y = exp(-x./delta)/delta;
end
