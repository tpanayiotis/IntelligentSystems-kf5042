function [model] = svmTrain(X, S, N, kernelFunction, ...
                            tE, maxPASS)
if ~exist('tol', 'var') || isempty(tE)
    tE = 1e-3;
end
if ~exist('max_passes', 'var') || isempty(maxPASS)
    maxPASS = 5;
end
k = size(X, 1);
n = size(X, 2);
S(S==0) = -1;
a = zeros(k, 1);
c = 0;
e = zeros(k, 1);
pass = 0;
estimatedta = 0;
o = 0;
r = 0;
if strcmp(func2str(kernelFunction), 'linearKernel')
    q = X*X';
elseif strfind(func2str(kernelFunction), 'gaussianKernel')
    X2 = sum(X.^2, 2);
    q = bsxfun(@plus, X2, bsxfun(@plus, X2', - 2 * (X * X')));
    q = kernelFunction(1, 0) .^ q;
else
    q = zeros(k);
    for t = 1:k
        for j = t:k
             q(t,j) = kernelFunction(X(t,:)', X(j,:)');
             q(j,t) = q(t,j);
        end
    end
end
fprintf('\nTraining ...');
dots = 12;
while pass < maxPASS,
   numberchangea = 0;
    for t = 1:k,
        e(t) = c + sum (a.*S.*q(:,t)) - S(t);
        if ((S(t)*e(t) < -tE && a(t) < N) || (S(t)*e(t) > tE && a(t) > 0)),
            j = ceil(k * rand());
            while j == t, 
                j = ceil(k * rand());
            end
            e(j) = c + sum (a.*S.*q(:,j)) - S(j);
            aiold = a(t);
            ajold = a(j); 
            if (S(t) == S(j)),
                o = max(0, a(j) + a(t) - N);
                r = min(N, a(j) + a(t));
            else
                o = max(0, a(j) - a(t));
                r = min(N, N + a(j) - a(t));
            end
            if (o == r),
                continue;
            end
            estimatedta = 2 * q(t,j) - q(t,t) - q(j,j);
            if (estimatedta >= 0),
                continue;
            end
            a(j) = a(j) - (S(j) * (e(t) - e(j))) / estimatedta;
            a(j) = min (r, a(j));
            a(j) = max (o, a(j));
            if (abs(a(j) - ajold) < tE),
                a(j) = ajold;
                continue;
            end
            a(t) = a(t) + S(t)*S(j)*(ajold - a(j));
            b1 = c - e(t) ...
                 - S(t) * (a(t) - aiold) *  q(t,j)' ...
                 - S(j) * (a(j) - ajold) *  q(t,j)';
            b2 = c - e(j) ...
                 - S(t) * (a(t) - aiold) *  q(t,j)' ...
                 - S(j) * (a(j) - ajold) *  q(j,j)';
            if (0 < a(t) && a(t) < N),
                c = b1;
            elseif (0 < a(j) && a(j) < N),
                c = b2;
            else
                c = (b1+b2)/2;
            end
            numberchangea = numberchangea + 1;
        end
    end
    if (numberchangea == 0),
        pass = pass + 1;
    else
        pass = 0;
    end
    fprintf('.');
    dots = dots + 1;
    if dots > 78
        dots = 0;
        fprintf('\n');
    end
    if exist('OCTAVE_VERSION')
        fflush(stdout);
    end
end
fprintf(' Done! \n\n');
idx = a > 0;
model.X= X(idx,:);
model.y= S(idx);
model.kernelFunction = kernelFunction;
model.b= c;
model.alphas= a(idx);
model.w = ((a.*S)'*X)';
end
