function [newIms,newFeatures,newWeights,newgtDensities,newindiv]= halfSplit (ims,features,weights,gtDensities,indiv)
ind=1;
for i=1:length(ims)
    resSize=floor(size(ims{i},1)/2);
    newIms{ind}=ims{i}(1:resSize,1:resSize,:);
    newFeatures{ind}=features{i}(1:resSize,1:resSize,:);
    newWeights{ind}=weights{i}(1:resSize,1:resSize,:);
    newgtDensities{ind}=gtDensities{i}(1:resSize,1:resSize,:);
    newindiv{ind}=indiv{i}(1:resSize,1:resSize,:);
    ind=ind+1;
    
    newIms{ind}=ims{i}(1:resSize,1+resSize:2*resSize,:);
    newFeatures{ind}=features{i}(1:resSize,1+resSize:2*resSize,:);
    newWeights{ind}=weights{i}(1:resSize,1+resSize:2*resSize,:);
    newgtDensities{ind}=gtDensities{i}(1:resSize,1+resSize:2*resSize,:);
    newindiv{ind}=indiv{i}(1:resSize,1+resSize:2*resSize,:);
    ind=ind+1;
    
    newIms{ind}=ims{i}(1+resSize:2*resSize,1:resSize,:);
    newFeatures{ind}=features{i}(1+resSize:2*resSize,1:resSize,:);
    newWeights{ind}=weights{i}(1+resSize:2*resSize,1:resSize,:);
    newgtDensities{ind}=gtDensities{i}(1+resSize:2*resSize,1:resSize,:);
    newindiv{ind}=indiv{i}(1+resSize:2*resSize,1:resSize,:);
    ind=ind+1;
    
    newIms{ind}=ims{i}(1+resSize:2*resSize,1+resSize:2*resSize,:);
    newFeatures{ind}=features{i}(1+resSize:2*resSize,1+resSize:2*resSize,:);
    newWeights{ind}=weights{i}(1+resSize:2*resSize,1+resSize:2*resSize,:);
    newgtDensities{ind}=gtDensities{i}(1+resSize:2*resSize,1+resSize:2*resSize,:);
    newindiv{ind}=indiv{i}(1+resSize:2*resSize,1+resSize:2*resSize,:);
    ind=ind+1;
end


end