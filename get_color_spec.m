function [out_colors] = get_color_spec(colornumbs)
%function [ColorSpec,colornumbs,numColors] = get_color_spec(colornumbs)
% a color number of '2.6' means color number 2 (green) that is  (2*.6 - 1 =) 0.2 brighter
% blue, green, red,
% orange, yellow, purple
% pink/maroon, tourquise/cyan, dark blue

    %% colors from eaton2020 paper
    %ColorSpec = {[0    0.4470    0.7410],[0.4660    0.6740    0.1880],[0.6350    0.0780    0.1840],...
    %[0.8500    0.3250    0.0980],[0.9290    0.6940    0.1250],[0.4940    0.1840    0.5560],...
    %[.9    0.15    0.5],[.157, .819, .576], [.25   .17    .58 ], [.5, .5, .5] };

    %%  colors modified to match Christina's colors
    ColorSpec = {[13    132    196]/256,[129    183    70]/256,[182    39    62]/256,...
    [0.8500    0.3250    0.0980],[0.9290    0.6940    0.1250],[0.4940    0.1840    0.5560],...
    [.9    0.15    0.5],[.157, .819, .576], [.25   .17    .58 ], [.5, .5, .5],[186,186,186]/256 };

totnum_colors = 11;

out_colors = {};
for ii=1:length(colornumbs)
    colnum = colornumbs(ii);
    if colnum<0
        darken = 1;
    else
        darken = 0;
    end
    colnum = abs(colnum);
    
    if colnum == 0
       out_colors{ii} = [0,0,0];
    else 
       colnum = mod(colnum-1,totnum_colors)+1;
       out_colors{ii} = ColorSpec{fix(colnum)};
   end
   
   if mod(colnum,1) > 0
       gamma =  mod(colnum,1); 
       if darken
            out_colors{ii} = brighten(out_colors{ii},-1*gamma); 
       else
            out_colors{ii} = brighten(out_colors{ii},gamma); 
       end
    end
   
end
   




numColors = length(ColorSpec);
for ii=1:numColors
    %ColorSpec{ii+numColors} = brighten(ColorSpec{ii},-.4);
    %ColorSpec{ii+numColors} = brighten(ColorSpec{ii},-.2);
    ColorSpec{ii+numColors} = brighten(ColorSpec{ii},.3);
end

for ii=1:numColors
    %ColorSpec{ii+numColors+numColors} = brighten(ColorSpec{ii},.3);
    ColorSpec{ii+numColors+numColors} = brighten(ColorSpec{ii},-.3);
end

for ii=1:numColors
    ColorSpec{ii+numColors+numColors+numColors} = brighten(ColorSpec{ii},-.6);
end


ColorSpec{end+1} = [0,0,0];
numTotColors = length(ColorSpec);

if length(out_colors) < 2
    out_colors = out_colors{1};
end

for ii=1:length(colornumbs)
    if colornumbs(ii)<1
        colornumbs(ii) = numTotColors + colornumbs(ii);
    end
end


end