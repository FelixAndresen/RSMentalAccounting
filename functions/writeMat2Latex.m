function writeMat2Latex( matrix, filename,varargin )
%writeMat2Latex writes a matrix to latex file
%   
%   * writes a matrix to latex file
%
%   Input:
%   matrix:     matrix to write to latex
%   filename:   string, filename (including whole path)
%   (before):   equation before matrix (e.g., before = matrix)
%   (format):   format of matrix
%   (size):     textsize (large, small, ... )

%% Settings
rowLabels = [];
colLabels = [];
alignment = 'l';
format = [];
textsize = [];
if ( nargin > 6)
    error('matrix2latex: ', 'Incorrect number of arguments to %s.', mfilename);
end

okargs = {'before', 'format', 'size'};
for j=1:2:(nargin-2)
    pname = varargin{j};
    pval = varargin{j+1};
    k = strmatch(lower(pname), okargs);
    if isempty(k)
        error('matrix2latex: ', 'Unknown parameter name: %s.', pname);
    elseif length(k)>1
        error('matrix2latex: ', 'Ambiguous parameter name: %s.', pname);
    else
        switch(k)
            case 1  % before
                beforeLabel = pval;
                if isnumeric(beforeLabel)
                    beforeLabel = cellstr(num2str(beforeLabel(:)));
                end
            case 2  % format
                format = lower(pval);
            case 3  % format
                textsize = pval;
        end
    end
end

%% Write to file
fid = fopen(filename, 'w');

width = size(matrix, 2);
height = size(matrix, 1);

if isnumeric(matrix)
    matrix = num2cell(matrix);
    for h=1:height
        for w=1:width
            if(~isempty(format))
                matrix{h, w} = num2str(matrix{h, w}, format);
            else
                matrix{h, w} = num2str(matrix{h, w});
            end
        end
    end
end

if(~isempty(textsize))
    fprintf(fid, '\\begin{%s}', textsize);
end
if(~isempty(beforeLabel))
    fprintf(fid, '%s', beforeLabel{1});
end
fprintf(fid, '\\begin{pmatrix}');

for h=1:height
    for w=1:width -1
        fprintf(fid, '%s&', matrix{h, w});
    end
    fprintf(fid, '%s\\\\\r\n', matrix{h, width});
end
fprintf(fid, '\\end{pmatrix}\r\n');

if(~isempty(textsize))
    fprintf(fid, '\\end{%s}', textsize);
end

fclose(fid);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This source code is part of RSMentalAccounting.
%
% Copyright(c) 2014 Felix Andresen
% All Rights Reserved.
%
% This program shall not be used, rewritten, or adapted as the basis of a commercial software
% or hardware product without first obtaining written permission of the author. The author make
% no representations about the suitability of this software for any purpose. It is provided
% "as is" without express or implied warranty.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Written by
%   Felix Andresen  
%   Master Thesis:  Regime Switching Models and the Mental Accounting Framework
%   Advisors:       Prof. Jan Vecer, Prof. Sebastien Lleo
%   Master of Science in Quantitative Finance, Frankfurt School of Finance and Management
%   Frankfurt am Main, Germany
%   02/2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contact
%   E-mail: Felix.Andresen@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

