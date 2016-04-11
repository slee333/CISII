function X=backtrace(P,x)
%Trangulate 3D location of M markers, given a series of 2D projected locations
%and corresponding camera matrices.
%
%    XX=backtrace(P,xx)
%
%in:
%
%    P: 3x4xN stack of camera matrices
%   x: 2xMxN array of 2D projected locations or 2xNx1 is permissible 
%      if M=1. Values can be NaN, in which case those projection views
%      won't be included in the estimation.
%
%out:
%
%  X: 3D triangulated locations as 3xM matrix


    N=size(P,3);
    if N<2, error 'Need at least 2 views'; end
    [~,n,p]=size(x);

    if p==1 && n==N %x is a single trajectory

        x=reshape(x,2,1,[]);
    end


    nanmap=~any(isnan(x),1);

    M=size(x,2);
    X=nan(4,M);



    col=@(Z,i) reshape(Z(:,i,:),[],1);

    for m=1:M

               idx=nanmap(:,m,:);

                xx=x(:,m,idx);    %% all positions of marker m


                Pij=P(1:2,:,idx);
                Pk=P(3,:,idx);

                Z=Pij-bsxfun(@times,xx,Pk);

                A=[col(Z,1), col(Z,2),col(Z,3),col(Z,4)];

                [~,~,V]=svd(A,0);

                X(:,m)=V(:,end);

    end

    X=bsxfun(@rdivide, X(1:3,:), X(4,:) );
    

end
