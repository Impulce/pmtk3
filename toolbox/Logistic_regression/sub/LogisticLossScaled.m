function [nll,g,H] = LogisticLossScaled(w,X,y)
% Average negative log likelihood for binary logistic regression
% w: d*1
% X: n*d
% y: n*1, should be -1 or 1

N = size(X,1);
y01 = (y+1)/2;
mu = sigmoid(X*w);
mu = max(mu, eps); % bound away from 0
mu = min(1-eps, mu); % bound away from 1
nll = -sum(y01 .* log(mu) + (1-y01) .* log(1-mu));
nll = nll/N;

if nargout > 1
  g = (1/N)*X'*(mu-y01);
end

if nargout > 2
  H = (1/N)*X'*diag(mu.*(1-mu))*X;
end

end