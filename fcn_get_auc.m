function [auc,sens,spec] = fcn_get_auc(svmo, grp)
AA=unique(grp);
AA=sort(AA,'descend');
th = linspace(min(svmo), max(svmo), 100);
N1 = length(find(grp==AA(1))); N2 = length(find(grp==AA(2)));
sens = zeros(1,100); spec = zeros(1,100);
for ii = 1:100
    sens(ii) = length(find(svmo>=th(ii) & grp==AA(1)))/N1;
    spec(ii) = length(find(svmo<th(ii) & grp==AA(2)))/N2;
end
auc = polyarea([0 spec 1 0], [1 sens 0 0]);
end
