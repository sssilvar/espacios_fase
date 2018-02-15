function D = distChiSq( X, Y )
f1=X;
f2=Y;
dd=((f1-f2).^2/(f1+f2));
dd=sum(dd(:))/2;
D=dd;
