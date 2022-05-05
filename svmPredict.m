function predic = svmPredict(model, d)
if (size(d, 2) == 1)
  d = d';
end
n = size(d, 1);
re = zeros(n, 1);
predic = zeros(n, 1);
if strcmp(func2str(model.kernelFunction), 'linearKernel') 
    re = d * model.w + model.b;
elseif strfind(func2str(model.kernelFunction), 'gaussianKernel') 
    X1 = sum(d.^2, 2);
    X2 = sum(model.X.^2, 2)';
    Kl = bsxfun(@plus, X1, bsxfun(@plus, X2, - 2 * d * model.X'));
    Kl = model.kernelFunction(1, 0) .^ Kl;
    Kl = bsxfun(@times, model.y', Kl);
    Kl = bsxfun(@times, model.alphas', Kl);
    re = sum(Kl, 2);
else
    for i = 1:n
        prediction = 0;
        for j = 1:size(model.X, 1)
            prediction = prediction + ...
                model.alphas(j) * model.y(j) * ...
                model.kernelFunction(d(i,:)', model.X(j,:)');
        end
        re(i) = prediction + model.b;
    end
end
predic(re >= 0) =  1;
predic(re <  0) =  0;
end

