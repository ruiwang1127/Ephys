A=creatNaN2;
F=[];
for i=1:6
    a=A(:,i)
     f= fillmissing(a,'movmedian',10);
     F=[F,f]
end

