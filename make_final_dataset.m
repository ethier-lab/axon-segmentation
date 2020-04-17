%this script creates the .mat file which holds all of our ground truth
%annotations and dataset images. 


clc
clear
close all

sigma=8;

%% load all files from constitutive datasets
%%these were created with 'create_andrew_indivcounts.m' and 'create_gs_indivcounts.m' 
as=load('count files\andrew_set_all.mat');
gs=load('count files\G_set_all_correct.mat');
bs=load('count files\B_set_all_new.mat');
aL=length(as.images);
gL=length(gs.images); 
bL=length(bs.images);
images=[as.images',gs.images',bs.images'];
counts=[as.counts',gs.counts',bs.counts];

    
    
%create density maps from manual image annotations
for j=1:length(counts)
    %calculate original sum, average count across all counters
    s1=sum(sum(sum(counts{j}/size(counts{j},3))));
    if s1==0
       counts{j}=sum(counts{j},3);
       continue
    end
    
    %call blurring function
    %counts{j} = imgaussfilt(counts{j}, sigma); 
    %counts{j} = adaptiveBlur2(counts{j});
    %calculate count after blurring
    s2=sum(sum(sum(counts{j})))/size(counts{j},3);
    %report to user
    fprintf('%i blurred of %i\n',j,length(counts));
    fprintf('%i axons before, %i axons after\n',s1,s2);
    %display
%     if any(j==[110:146])
%         figure();
%         imshow(images{j});
%         figure();
%         c=sum(counts{j},3);
%         imshow(c/max(max(c)));
%         pause()
%     end
end

imsAll=[];
countsAll=[];
csAll=[];

%% split images so that all have roughly the same dimensions
%split larges, andrew dataset has 750x750 pixels by default
[splitIms,splitCounts,~,~,~]= halfSplit (images(1:50),counts(1:50),counts(1:50),counts(1:50),counts(1:50));
[splitIms,splitCounts,~,~,~]= halfSplit (splitIms,splitCounts,splitCounts,splitCounts,splitCounts);
imsAll=[imsAll,splitIms];
countsAll=[countsAll,splitCounts];
for i=1:50  
    for j=1:16
        csAll=[csAll,1];
    end
end
%split meds, g dataset has 375x375 pixels by default
[splitIms,splitCounts,~,~,~]= halfSplit (images(51:146),counts(51:146),counts(51:146),counts(51:146),counts(51:146));
imsAll=[imsAll,splitIms];
countsAll=[countsAll,splitCounts];
for i=51:146  
    for j=1:4
        csAll=[csAll,2];
    end
end
%add smalls. B dataset is proper size.
imsAll=[imsAll, images(147:end)];
countsAll=[countsAll,counts(147:end)];
for i=147:length(images) 
    csAll=[csAll,3];
end
images=imsAll;
annotations=countsAll;

%% misc dataset tasks
%this range of images was mistakenly deleted at one point. Make the
%annotation arrays have no axons marked to match the blank images now occupying these positions.
annotations(821:824)={zeros(size(annotations{821}))};
%find total counts for the dataset images
for i=1:length(annotations)
    countTotals(i) = sum(sum(sum(annotations{i})))/size(annotations{i},3);
end
for i=1:length(annotations)
    gt{i}=annotations{i};
    %division is done here
    gt{i}=sum(gt{i},3)/size(gt{i},3);
    
end


save('centerpoints.mat','images', 'annotations');


%% resize all images and ground truths to be 192x192 pixels
% images=imsAll;
% for j=1:length(images)
%     images{j} = imresize(images{j},[192 192]); 
%     
%     %resize gt but ensure that gt count does not change with the resizing. 
%     s1=sum(sum(sum(gt{j})));
%     gt{j} = imresize(gt{j},[192 192],'bicubic');
%     gt{j}(gt{j}<0)=0;
%     s2=sum(sum(sum(gt{j})));
%     if s2~=0
%         gt{j}=(s1/s2)*gt{j};
%     end
%     
% end
% 
% %% save .mat with the dataset
% c=csAll;
% save(['data_updated_3-22-2020'  '.mat'],'images','annotations','gt','countTotals','c');
% indivs=annotations;
% 
% %% create confidence interval for images with 4 counts
% back=indivs;
% all=[];
% indivs=back;
% counts=[];
% yes=0;
% for i=1:length(indivs)
%     if size(indivs{i},3)~=1
%         for j=1:4
%             if true
%                 indivs{i}(:,:,j)=indivs{i}(:,:,j)/max(max(indivs{i}(:,:,j)));
%                 check=isnan(indivs{i}(:,:,j));
%                 temp=indivs{i}(:,:,j);
%                 temp(check)=0;
%                 indivs{i}(:,:,j)=temp;
%             end
%         end
%         new=[sum(sum(indivs{i}(:,:,1)));sum(sum(indivs{i}(:,:,2)));sum(sum(indivs{i}(:,:,3)));sum(sum(indivs{i}(:,:,4)))];
%         counts=[counts,mean(new)];
%         all=[all;new'];
%         ci=paramci(fitdist(new,'Normal'),'parameter','mu');
%     else
%         ci(1)=0;
%         ci(2)=0;
%         new=[sum(sum(indivs{i}(:,:,1)))];
%         all=[all;[0,0,0,0]];
%         counts=[counts,new];
%     end
%     low(i)=ci(1);
%     high(i)=ci(2);
% end
% comp=[low;high];
% out=[comp',c',counts'];
% randVec=load('randVec.mat');
% randVec=randVec.randVec;
% out=out(randVec,:);
% all=all(randVec,:);