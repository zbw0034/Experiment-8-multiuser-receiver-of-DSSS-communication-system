clc;clear all;
A1=[1,0,0,1,0,1];%
A2=[1,1,1,1,0,1];
A3=[1,1,0,1,1,1];
initial_state=[0,0,0,0,1];
M1=m_series(A1,initial_state);
M2=m_series(A2,initial_state);
M3=m_series(A3,initial_state);
error_code1_sum=zeros(1,36);
error_code2_sum=zeros(1,36);
error_code3_sum=zeros(1,36);
for jj=1:10
    source1 = randi ( [ 0 , 1 ] , 1 , 1000 );
    source2 = randi ( [ 0 , 1 ] , 1 , 1000 );
    source3 = randi ( [ 0 , 1 ] , 1 , 1000 );
    BPSK_data1 = 2 * source1-1;
    BPSK_data2 = 2 * source2-1;
    BPSK_data3 = 2 * source3-1;
    DSSS_data1 = DSSS_ec8(M1,BPSK_data1);
    DSSS_data2 = DSSS_ec8(M2,BPSK_data2);
    DSSS_data3 = DSSS_ec8(M3,BPSK_data3);
    DSSS_data11=DSSS_data1;%1用户
    DSSS_data22=DSSS_data1+DSSS_data2;%2用户
    DSSS_data33=DSSS_data1+DSSS_data2+DSSS_data3;%3用户
    SNR=-30:5;
    for i=1:length(SNR)
        Awgn_data1(i,:)=awgn(DSSS_data11,SNR(i),'measured');
        Awgn_data2(i,:)=awgn(DSSS_data22,SNR(i),'measured');
        Awgn_data3(i,:)=awgn(DSSS_data33,SNR(i),'measured');
    end
    %解扩
    for z=1:1000
        for i=1:length(SNR)
            o_BPSK1(i,z)= Awgn_data1(i,31*(z-1)+(1:31))/M1;%恢复用户1
            o_BPSK2(i,z)= Awgn_data2(i,31*(z-1)+(1:31))/M2;%恢复用户2
            o_BPSK3(i,z)= Awgn_data3(i,31*(z-1)+(1:31))/M3;%恢复用户3
        end
    end
    Rec_Bpsk1=sign(o_BPSK1);
    Rec_Bpsk2=sign(o_BPSK2);
    Rec_Bpsk3=sign(o_BPSK3);
    error_code1=error_code_ec8(BPSK_data1,Rec_Bpsk1,SNR);
    error_code2=error_code_ec8(BPSK_data2,Rec_Bpsk2,SNR);
    error_code3=error_code_ec8(BPSK_data3,Rec_Bpsk3,SNR);
    error_code1_sum=error_code1_sum+error_code1;
    error_code2_sum=error_code2_sum+error_code2;
    error_code3_sum=error_code3_sum+error_code3;
end
error_code1_av=error_code1_sum/jj;
error_code2_av=error_code2_sum/jj;
error_code3_av=error_code3_sum/jj;
semilogy(SNR,error_code1_av);
hold on
semilogy(SNR,error_code2_av);
hold on
semilogy(SNR,error_code3_av);
xlabel('SNR');ylabel('误码率');
legend('用户在1个用户情况下','用户在2个用户情况下','用户在3个用户情况下');
grid on;
title('在不同数量用户情况下的误码率');