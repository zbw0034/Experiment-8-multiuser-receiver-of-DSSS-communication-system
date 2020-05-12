function DSSS_data=DSSS_ec8(m,s_BPSK)
%–Ú¡–¿©’π
z=length(s_BPSK);
zz=length(m);
DSSS_data=zeros(1,zz*z);
for z=1:1000
   DSSS_data(31*(z-1)+(1:31))=m*s_BPSK(z);
end


