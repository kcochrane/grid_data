%creates a window where spectra from points you click are displayed
function spectra = clickforspectrumfit(IVdata,h,p,w,V,imV,n,offset)
%----Inputs----
%IVdata: 3D Matrix with data
%V: Vector with bias voltages
%imV: Voltage at which to display image
%n: Number of point spectra to plot

smoothing = 2; %standard deviation (pixels) of the Gaussian filter for spatial smoothing of data
offset = offset; %for offsetting the plots vertically

Vred = V(1:size(IVdata,1));
if smoothing %convolves each image with a Gaussian filter
    flt = fspecial('gaussian',smoothing*5,smoothing);
    for k = 1:size(IVdata,1)
        IVdataS(k,:,:) = imfilter(squeeze(IVdata(k,:,:)),flt,'replicate');
    end
else
    IVdataS = IVdata;
end

[~,imN] = min(abs(Vred-imV));

img = figure;imagesc(squeeze(IVdataS(imN,:,:)));colormap('gray');hold on
axis image
%xlim([19 30]);ylim([27 37]);
spec = figure; hold on

R = 2; %defining circles that will be drawn in image
xx = -R:.01:R;
yy = sqrt(R^2-xx.^2);

spectra = NaN(size(IVdataS,1),n);

colours = 'rgbcmyk';
for k = 1:n
    figure(img)
    pos = round(ginput(1)); %click where you want the spectrum
    plot(pos(1)+xx,pos(2)+yy,colours(mod(k-1,7)+1))
    plot(pos(1)+xx,pos(2)-yy,colours(mod(k-1,7)+1))
    
    spectra(:,k) = squeeze(IVdataS(:,pos(2),pos(1)));
    
    figure(spec)
    plot(Vred,spectra(:,k)+(k-1)*offset,[colours(mod(k-1,7)+1) '.'])
    g = zeros(size(IVdataS,1),size(h,3));
    for kg = 1:size(h,3)
        g(:,kg) = h(pos(2),pos(1),kg)*exp(-((Vred-p(pos(2),pos(1),kg))./w(pos(2),pos(1),kg)).^2);
        plot(Vred,g(:,kg)+(k-1)*offset,colours(mod(k-1,7)+1))
    end
    plot(Vred,sum(g,2)+(k-1)*offset,colours(mod(k-1,7)+1))
    disp(pos)
end
    
xlabel('Bias /V')
ylabel('Norm dI/dV')
