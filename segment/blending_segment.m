function im_draw = blending_segment(im_rgb, thresh, k, gd_thresh, se_size, gamma, level, sigma_color, amplitude, sigma_g)
% 'blending_segment' picture2drawing blending using color reduction from region segmentation
%
% Args:
%   'im_rgb' (3D double array): original image
%   'thresh' (double): threshold for edge extraction
% increasing 'thresh' decreases the amount of edge detected
%   'k' (int): size of the dilatation structuring element
% increasing 'k' increases the width of the edges
%   'gd_thresh' (double): threshold for region boundaries detection
% decreasing 'gd_thresh' increases the number of regions and thus the closeness to the initial image
%   'se_size' (int): size of structural element used for Open-Close operation
% decreasing 'se_size' increases the number of regions and thus the closeness to the initial image
%   'gamma' (double): color adjustment parameters
% increasing 'gamma' makes the color less saturated
%   'level' (double): gray level of edges
% 0 = black ; 1 = white
%   'sigma_color' (double): gaussian std for color smoothering
% increasing 'sigma_color' increases the blur
%   'amplitude' (double): importance factor of color gradient information
% 0 = only cluster colors ; 1 = contrast info from grayscale image
%   'sigma_g' (double): gaussian std for color gradient
%
% Returns:
%   'im_draw' (3D double array): processed image

    % grayscale
    im_g = rgb2gray(im_rgb);

    % edges
    edges_d = edge_extractor(im_rgb, thresh, k);

    % recolorized image
    im_color = segment_color(im_rgb, gd_thresh, se_size, gamma);

    % add edges in black on image
    im_edge = im_color .* (1-edges_d)  + level*edges_d;

    % use smoothered grayscale for color gradient effect
    color_gradient =  amplitude * imgaussfilt(im_g, sigma_g); 
    % center in 0.5
    color_gradient = color_gradient + (0.5 - mean(color_gradient(:)));

    % apply the color gradient information
    im_gc = imgaussfilt(im_edge, sigma_color) .* color_gradient;
    im_draw = im_gc / max(im_gc(:));
end

