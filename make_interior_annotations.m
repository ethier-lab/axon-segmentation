clc
clear
close all

%mkdir("images and masks")
%load data
data=load("centerpoints.mat");
images=data.images;
points=data.annotations;

for i=1:length(images)
    nAnnot = size(points{i},3); %how many annotators here
    if nAnnot==1
       nAnnot; 
    end
    vote_thresh = 0; %how many votes to count as yes
    score = zeros (size(images{i})); 
    
    image = double(images {i})/255;
    simplebin = imfill(imbinarize(image,adaptthresh(image)-.00),'holes'); %binarize from the image
    
    %simplebin = imfill(activecontour(adapthisteq(image,'distribution','exponential'),score==0,500),'holes');
    %simplebin = imfill(activecontour((image),score==0,500),'holes');
    %simplebin = (activecontour((image),score==0,500));
%     figure()
%     imshow(simplebin)
%     title('active contour');
%     figure()
%     imshow(imfill(imbinarize(image,adaptthresh(image)),'holes'))
%     title('adaptive thresh');
%     
%     pause()
%     close all
    region_ids = bwlabel(simplebin,4); %make unique region ids
    for j=1:max(region_ids(:))
        a=region_ids==j;
        if sum(a,'all')>800 || sum(a,'all')<3
            region_ids(a)=0;
        end
    end
    %out is the ID of the larest region, the connected background
    out=mode(region_ids,'all');
    
    for j=1:nAnnot
        annots = points {i}(:,:,j);
        toUse=region_ids(annots==1);
        toUse(toUse==out)=[];
        thisUserScored=((ismember(region_ids,toUse)));
        score(thisUserScored)=score(thisUserScored)+1;
    end
    
    mask=(score>vote_thresh);
%     mask=conv2(mask,[0,1,0;1,1,1;0,1,0],'same')>1;
%     mask=conv2(mask,[0,1,0;1,1,1;0,1,0],'same')>1;
    mask=conv2(mask,[1,1,1;1,1,1;1,1,1],'same')>2;
    mask=conv2(mask,[1,1,1;1,1,1;1,1,1],'same')>2;
    %mask(image<median(image,'all')-.05)=0;
    %mask=conv2(mask,[1,1,1;1,1,1;1,1,1],'same')>1;
    %mask=uint8(mask);
    [mask] = getRemainingPixels(mask, image);
    
%     imshow([image, score]);
%     pause();
    imwrite(image,['images and masks/',num2str(i,'%04.f'), '_image','.tiff'], 'Compression', 'none') ;
    imwrite(mask,['images and masks/',num2str(i,'%04.f'),'_mask','.png'], 'Compression', 'none') ;
    overlay=cat(3,image,image,image);
    image(mask)=image(mask)-100;
    overlay(:,:,2)=image;
    imwrite(overlay,['images and masks/',num2str(i,'%04.f'),'_overlay','.png'], 'Compression', 'none') ;
    if mod(i,10)==0
        fprintf("\n\n\n\n\n\n\n\ncompleted %d of %d", i, length(images));
    end
    %niftiwrite(mask,['images and masks/','nii_',num2str(i,'%04.f'),'.nii'], 'Compression', 'none') ;
       
end


function [mask] = getRemainingPixels (mask, image)
    %feats: intensity, entropy, laplacian, hessian
    ent = entropyfilt(image);
    [Gmag,Gdir] = imgradient(image);
    [gx, gy] = gradient(double(image));
    [gxx, gxy] = gradient(gx);
    [gyx, gyy] = gradient(gy);
    
    
    featvecs={ent, Gmag, Gdir, gx, gy, gxx, gxy, gyx, gyy};
    feats=zeros(size(image,1)*size(image,2),length(featvecs));

end




