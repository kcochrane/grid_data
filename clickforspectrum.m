%creates a window where spectra from points you click are displayed
function [] = clickforspectrum(IVdata,V,imV,n)
%----Inputs----
%IVdata: 3D Matrix with data
%V: Vector with bias voltages
%imV: Voltage at which to display image
%n: Number of point spectra to plot

smoothing = 0; %standard deviation (pixels) of the Gaussian filter for spatial smoothing of data
offset = 0; %for offsetting the plots vertically

Vred = V(1:size(IVdata,1));
if smoothing %convolves each image with a Gaussian filter
    flt = fspecial('gaussian',smoothing*5,smoothing);
    for k = 1:size(IVdata,1)
        IVdata(k,:,:) = imfilter(IVdata(k,:,:),flt,'replicate');
    end
end

if Vred(length(Vred) > Vred(1)) %finds the image you want to display
    imN = find(Vred>imV,1);
else
    imN = find(Vred<imV,1);
end

img = figure;imagesc(squeeze(IVdata(imN,:,:)));colormap('gray');hold on
axis image
spec = figure; hold on

R = 2; %defining circles that will be drawn in image
xx = -R:.01:R;
yy = sqrt(R^2-xx.^2);

colours = 'rgbcmyk';
for k = 1:n
    figure(img)
    pos = round(ginput(1)); %click where you want the spectrum
    plot(pos(1)+xx,pos(2)+yy,colours(mod(k-1,7)+1))
    plot(pos(1)+xx,pos(2)-yy,colours(mod(k-1,7)+1))
    
    figure(spec)
    plot(Vred,squeeze(IVdata(:,pos(2),pos(1)))+(k-1)*offset,colours(mod(k-1,7)+1))
end
    