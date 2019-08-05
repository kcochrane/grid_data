function[PeakHeightImgs,PeakPosImgs,PeakWidthImgs,Chi2] = FitPeaksToPoint(IVdata,V,startV,stopV,N)
%Fits Gaussians to the state for each pixel in a grid
%---Inputs---
% IVdata: 3D matrix with normalized dI/dV
% V: Vector with bias voltages
% startV: Start of voltage range to fit
% stopV: Stop of voltage range to fit
% N: Number of Gaussians to fit

% IVdata=norm_dIdV_mask;
%  startV = .7;
%  stopV = 1.2;
%  N = 2;

clear PeakHeightImgs PeakPosImgs PeakWidthImgs

[~,startpos] = min(abs(V-startV));
[~,stoppos] = min(abs(V-stopV));
smoothing = 2;

lowlim = startV;
uplim = stopV;

if startpos < stoppos
    Vred = V(startpos:stoppos);
    DataRed = IVdata(startpos:stoppos,:,:);
else
    Vred = V(stoppos:startpos);
    DataRed = IVdata(stoppos:startpos,:,:);
end

% if smoothing %convolves each image with a Gaussian filter
%     flt = fspecial('gaussian',smoothing*5,smoothing);
%     for k = 1:size(Vred,1)
%         DataRed(k,:,:) = imfilter(squeeze(DataRed(k,:,:)),flt,'replicate');
%     end
% end
% 
% PeakHeightImgs = NaN(size(IVdata,2),size(IVdata,3),N);
% PeakPosImgs = PeakHeightImgs;
% PeakWidthImgs = PeakHeightImgs;

if N == 1

            f = fit(Vred,squeeze(DataRed),'gauss1','Lower',[0,lowlim,0],'Upper',[inf,uplim,inf]);
            PeakHeightImgs = f.a1;
            PeakPosImgs = f.b1;
            PeakWidthImgs= f.c1;

elseif N == 2

            [f,g] = fit(Vred,squeeze(DataRed),'gauss2','Lower',[0,lowlim,0],'Upper',[inf,uplim,inf]);
            PeakHeightImgs(1) = f.a1;
            PeakPosImgs(1) = f.b1;
            PeakWidthImgs(1)= f.c1;
            PeakHeightImgs(2) = f.a2;
            PeakPosImgs(2) = f.b2;
            PeakWidthImgs(2)= f.c2;

elseif N == 3

            f = fit(Vred,squeeze(DataRed),'gauss3','Lower',[0,lowlim,0],'Upper',[inf,uplim,inf]);
            PeakHeightImgs(1) = f.a1;
            PeakPosImgs(1) = f.b1;
            PeakWidthImgs(1)= f.c1;
            PeakHeightImgs(2) = f.a2;
            PeakPosImgs(2) = f.b2;
            PeakWidthImgs(2)= f.c2;
            PeakHeightImgs(3) = f.a3;
            PeakPosImgs(3) = f.b3;
            PeakWidthImgs(3)= f.c3;
% elseif N == 4
% 
%             f = fit(Vred,squeeze(DataRed(:,k1,k2)),'gauss4','Lower',[0,lowlim,0,0,lowlim,0,0,lowlim,0,0,lowlim,0],'Upper',[inf,uplim,inf,inf,uplim,inf,inf,uplim,inf,inf,uplim,inf]);
%             PeakHeightImgs(k1,k2,1) = f.a1;
%             PeakPosImgs(k1,k2,1) = f.b1;
%             PeakWidthImgs(k1,k2,1) = f.c1;
%             PeakHeightImgs(k1,k2,2) = f.a2;
%             PeakPosImgs(k1,k2,2) = f.b2;
%             PeakWidthImgs(k1,k2,2) = f.c2;
%             PeakHeightImgs(k1,k2,3) = f.a3;
%             PeakPosImgs(k1,k2,3) = f.b3;
%             PeakWidthImgs(k1,k2,3) = f.c3;
%             PeakHeightImgs(k1,k2,4) = f.a4;
%             PeakPosImgs(k1,k2,4) = f.b4;
%             PeakWidthImgs(k1,k2,4) = f.c4;
% 
% elseif N == 5
%             f = fit(Vred,squeeze(DataRed(:,k1,k2)),'gauss5','Lower',[0,lowlim,0,0,lowlim,0,0,lowlim,0,0,lowlim,0,0,lowlim,0],'Upper',[inf,uplim,inf,inf,uplim,inf,inf,uplim,inf,inf,uplim,inf,inf,uplim,inf]);
%             PeakHeightImgs(k1,k2,1) = f.a1;
%             PeakPosImgs(k1,k2,1) = f.b1;
%             PeakWidthImgs(k1,k2,1) = f.c1;
%             PeakHeightImgs(k1,k2,2) = f.a2;
%             PeakPosImgs(k1,k2,2) = f.b2;
%             PeakWidthImgs(k1,k2,2) = f.c2;
%             PeakHeightImgs(k1,k2,3) = f.a3;
%             PeakPosImgs(k1,k2,3) = f.b3;
%             PeakWidthImgs(k1,k2,3) = f.c3;
%             PeakHeightImgs(k1,k2,4) = f.a4;
%             PeakPosImgs(k1,k2,4) = f.b4;
%             PeakWidthImgs(k1,k2,4) = f.c4;
%             PeakHeightImgs(k1,k2,5) = f.a5;
%             PeakPosImgs(k1,k2,5) = f.b5;
%             PeakWidthImgs(k1,k2,5) = f.c5;
end


clear g
figure
hold on
plot(Vred,DataRed)
    for kg = 1:length(PeakHeightImgs)
        g(:,kg) = PeakHeightImgs(kg)*exp(-((Vred-PeakPosImgs(kg))./PeakWidthImgs(kg)).^2);
        plot(Vred,g(:,kg))
    end

plot(Vred,sum(g,2))

end