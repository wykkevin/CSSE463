function [hori,veti,sum,grad,edge,clean_edge]=sobel(img)
    hori_m=[-1/8 0 1/8; -1/4 0 1/4; -1/8 0 1/8];
    veti_m=[1/8 1/4 1/8; 0 0 0; -1/8 -1/4 -1/8];
    hori=filter2(hori_m,img);
    veti=filter2(veti_m,img);
    sum=hori+veti;
    grad=sqrt(hori.^2+veti.^2);
    edge=atan2(veti,hori);
    clean_edge=edge;
    clean_edge(clean_edge<1.6&clean_edge>-1.6)=0;
    