function im_draw = drawing_pipeline_hp(im_rgb, lic_path, varargin)
% 'blending_segment_hp' is a wrapper for 'blending_segment'
% Set the hyperparameters according to a Struct argument if specified otherwise set to default values
%
% Args:
%   'im_rgb' (3D double array): original image
%   'lic_path' (String): path to the precomputed LIC line sketches
%   'hp' (Struct): structure gathering all the hyperparameters as its fields
%
% Returns:
%   'im_draw' (3D double array): processed image

    if ~isempty(varargin) % 'hp' has been provided
        hp = varargin{1};
        % retrieve the hyperparameters
        kw = hp.kw; % kernel width used in the Line Integral Convolution operation
        gd_thresh = hp.gd_thresh; % threshold for region boundaries detection
        se_size = hp.se_size; % size of structural element
        gamma_2 = hp.gamma_2; % color adjustement

        sigma_color = hp.sigma_color; % std for color smoothering
        amplitude = hp.amplitude; % importance of color gradient
        sigma_g = hp.sigma_g; % std for color gradient
        
    else % set to default values
        kw = 12; % kernel width used in the Line Integral Convolution operation
        gd_thresh = 0.1; % threshold for region boundaries detection
        se_size = 15; % size of structural element
        gamma_2 = 0.8; % color adjustement
        sigma_color = 0.1; % std for color smoothering
        amplitude = 0.5; % importance of color gradient
        sigma_g = 5; % std for color gradient
    end
    
    im_draw = drawing_pipeline(im_rgb, lic_path, kw, gd_thresh, se_size, gamma_2, sigma_color, amplitude, sigma_g);
end
