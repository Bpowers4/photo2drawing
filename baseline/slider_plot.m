function slider_plot(im_path)

    % reshape and save the original image
    im = im2double(imread(im_path));
    S.im = imresize(im, 250/size(im,1));
    
    % define the initial hyperparameters
    hp.thresh = 0.2; % threshold for edge detection
    hp.k = 2; % size of dilatation structuring element
    hp.n_cluster = 4; % number of output colors
    hp.gamma = 0.5; % color adjustement
    hp.isLAB = true; % space in which to perform the clustering

    hp.gd_thresh = 0.1; % threshold for region boundaries detection
    hp.se_size = 15; % size of structural element
    hp.gamma_2 = 0.8; % color adjustement

    hp.level = 0.5; % color of edges
    hp.sigma_color = 0.1; % std for color smoothering
    hp.amplitude = 1; % importance of color gradient
    hp.sigma_g = 5; % std for color gradient
        % store the hyperparamters
    S.hp = hp;
    
    % compute and save the drawing image
    S.im_draw = blending_baseline_hp(S.im, S.hp);
    
    % plot different blended images according to the sliders location
        % create the figure
    S.f = figure('units','pixels','position',[300 300 300 300],'menubar','none',...
                  'name','slider_plot','numbertitle','off','resize','off');   
       % initial blending = original image 
    S.lambda_r = 1;
    S.im_blend = S.im;
        % set the axis position
    S.ax = axes('unit','pix','position',[40 80 260 210]);
        % plot the image
    S.LN = imshow(S.im_blend);
        % set the blend slider controller
    S.bl = uicontrol('style','slide','unit','pix','position',[60 40 200 20],...
                     'min',0,'max',1,'val',1,'sliderstep',[1/20 1/20],...
                     'callback',{@bl_call,S},'Tag','slider_bl');  
        % print the slider informations
    bgcolor = S.f.Color;
    bl1 = uicontrol('Style','text','unit','pix','position',[45 35 10 20],...
                    'String','0','BackgroundColor',bgcolor);
    bl2 = uicontrol('Style','text','unit','pix','position',[265 35 10 20],...
                    'String','1','BackgroundColor',bgcolor);
    bl3 = uicontrol('Style','text','Position',[110,15,100,23],...
                    'String','Realistic axis','BackgroundColor',bgcolor);
        % set the details slider controller
    S.draw = uicontrol('style','slide','unit','pix','position',[40 80 20 200],...
                     'min',0,'max',1,'val',0.8,'sliderstep',[1/20 1/20],...
                     'callback',{@draw_call,S},'Tag','slider_draw');  
        % print the slider informations
    bgcolor = S.f.Color;
    draw1 = uicontrol('Style','text','unit','pix','position',[45 55 10 20],...
                    'String','0','BackgroundColor',bgcolor);
    draw2 = uicontrol('Style','text','unit','pix','position',[45 275 10 20],...
                    'String','1','BackgroundColor',bgcolor);
    draw3 = uicontrol('Style','text','Position',[0,130,35,100],...
                    'String','Details axis','BackgroundColor',bgcolor);
end

function bl_call(varargin)
    % Callback for the slider.
    [h,S] = varargin{[1,3]};  % calling handle and data structure
    
    % get the drawing from the other slider
	h_draw = findobj('Tag','slider_draw');
	im_draw = h_draw.UserData;
        
    if isempty(im_draw)
        im_draw = S.im_draw;
    end
    
    % adapt the blending with respect to the slider parameter
    S.lambda_r = get(h, 'value');
    S.im_blend = blend_screen(S.im, im_draw, S.lambda_r);
    % display the modified image
    S.LN = imshow(S.im_blend);
    
    % store the value for the other slider
    h.UserData = S.lambda_r;
end

function draw_call(varargin)
    % Callback for the slider.
    [h,S] = varargin{[1,3]};  % calling handle and data structure.
    
    % get the value from the other slider
	h_bl = findobj('Tag','slider_bl');
	lambda_r = h_bl.UserData;
    
    if isempty(lambda_r)
        lambda_r = S.lambda_r;
    end
    
    % adapt the drawing hyperparameters with respect to the slider parameter
    lambda_d = get(h, 'value');
    S.hp = set_details_hp(S.hp, lambda_d);
    % recompute the drawing image
    S.im_draw = blending_baseline_hp(S.im, S.hp);
    % display the blended result
    S.im_blend = blend_screen(S.im, S.im_draw, lambda_r);
    S.LN = imshow(S.im_blend);
    
    % store the drawing for the other slider
    h.UserData = S.im_draw;
end