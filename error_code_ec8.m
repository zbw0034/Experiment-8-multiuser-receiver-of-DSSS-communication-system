function error_code=error_code_ec8(source,Y_RE,SNR)
%ŒÛ¬Î¬ Õ≥º∆
n=length(source)*2;
Y_ERRO=zeros(length(SNR),1000);
error_code=zeros(1,length(SNR));
for i=1:length(SNR)
    Y_ERRO(i,:)=abs(Y_RE(i,:)-source);
    error_code(i)=sum(Y_ERRO(i,:))/n;
end
