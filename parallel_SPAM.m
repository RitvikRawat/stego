function F = parallel_SPAM()
% -------------------------------------------------------------------------
% Takes 40s if inner is parfor
% Takes 1s if outer is parfor
% -------------------------------------------------------------------------

prefix = 'images/';
postfix = '.pgm';

size = 5;

H = zeros(size,686);

parfor i = 1:size
    fprintf('haha\n');
    
    IMG = strcat(prefix,int2str(i),postfix);
    
    F = spam_extract_2(double(imread(IMG)),3);
    
    G = F.';    
    disp(G);
    disp(IMG);
    %filename = 'output/SPAM_686_features.mat';
    %m = matfile(filename, 'Writable', true);
    %m.F(str2double(i), 1:686) = G;
    
    %Works
    %H(i,1:686) = G;
    
    for j = 1:686
        H(i,j) = G(j);
    end
    
    fprintf('hoho\n');
end

disp(H);

names = cell( size , 1);
endpart = '.pgm';

parfor i = 1:size
    frontpart = int2str(i);
	names{i, 1} = strcat(frontpart, endpart);
end

filename = 'output/SPAM_686_features.mat';
m = matfile(filename, 'Writable', true);
m.F = H;
m.names = names;

%F = spam_extract_2(double(imread(IMG)),3);

% append F to our mat file
%G is the transpose of F (column store)
%G = F.';    
%disp(G);
%disp(IMG);
%filename = 'output/SPAM_686_features.mat';
%m = matfile(filename, 'Writable', true);
%m.F(str2double(OUT), 1:686) = G;


function F = spam_extract_2(X,T)

% horizontal left-right
D = X(:,1:end-1) - X(:,2:end);
L = D(:,3:end); C = D(:,2:end-1); R = D(:,1:end-2);
Mh1 = GetM3(L,C,R,T);

% horizontal right-left
D = -D;
L = D(:,1:end-2); C = D(:,2:end-1); R = D(:,3:end);
Mh2 = GetM3(L,C,R,T);
% vertical bottom top
D = X(1:end-1,:) - X(2:end,:);
L = D(3:end,:); C = D(2:end-1,:); R = D(1:end-2,:);
Mv1 = GetM3(L,C,R,T);

% vertical top bottom
D = -D;
L = D(1:end-2,:); C = D(2:end-1,:); R = D(3:end,:);
Mv2 = GetM3(L,C,R,T);

% diagonal left-right
D = X(1:end-1,1:end-1) - X(2:end,2:end);
L = D(3:end,3:end); C = D(2:end-1,2:end-1); R = D(1:end-2,1:end-2);
Md1 = GetM3(L,C,R,T);

% diagonal right-left
D = -D;
L = D(1:end-2,1:end-2); C = D(2:end-1,2:end-1); R = D(3:end,3:end);
Md2 = GetM3(L,C,R,T);

% minor diagonal left-right
D = X(2:end,1:end-1) - X(1:end-1,2:end);
L = D(1:end-2,3:end); C = D(2:end-1,2:end-1); R = D(3:end,1:end-2);
Mm1 = GetM3(L,C,R,T);

% minor diagonal right-left
D = -D;
L = D(3:end,1:end-2); C = D(2:end-1,2:end-1); R = D(1:end-2,3:end);
Mm2 = GetM3(L,C,R,T);

F1 = (Mh1+Mh2+Mv1+Mv2)/4;
F2 = (Md1+Md2+Mm1+Mm2)/4;
F = [F1;F2];

function M = GetM3(L,C,R,T)
% marginalization into borders
L = L(:); L(L<-T) = -T; L(L>T) = T;
C = C(:); C(C<-T) = -T; C(C>T) = T;
R = R(:); R(R<-T) = -T; R(R>T) = T;

% get cooccurences [-T...T]
M = zeros(2*T+1,2*T+1,2*T+1);
for i=-T:T
    C2 = C(L==i);
    R2 = R(L==i);
    for j=-T:T
        R3 = R2(C2==j);
        for k=-T:T
            M(i+T+1,j+T+1,k+T+1) = sum(R3==k);
        end
    end
end

% normalization
M = M(:)/sum(M(:));
