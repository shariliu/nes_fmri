function [feat, pc, latent] = pca(features, N)

% custom pca from TK's gist feature-gathering code.

%m = mean(features, 2);
fm = features;% - repmat(mean(features, 2), 1, size(features,2));
X= fm*fm'; size(X);
[pc, latent] = eigs(X, N);
feat = (pc' * features);

