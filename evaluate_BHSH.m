function evaluation_info=evaluate_BHSH(XKTrain,YKTrain,LTrain,XKTest,YKTest,LTest,param,B)
    tic;
    addpath(genpath('./utils/'));
    addpath(genpath('markSchmidt/'));
	% Hash functions learning
   %% linear function
    XW =pinv(XKTrain'*XKTrain+param.theta*eye(size(XKTrain,2)))   *   (XKTrain'*B');
    YW =pinv(YKTrain'*YKTrain+param.theta*eye(size(YKTrain,2)))   *   (YKTrain'*B');
    
%     tBX = compactbit(sign(XKTest*XW)>=0);    
%     tBY = compactbit(sign(YKTest*YW)>=0);
%     dBX = compactbit(sign(B')>=0);
%     dBY = compactbit(sign(B')>=0);
    t1 = clock;
    BxTest = sgn(XKTest*XW); 
    DHamm1 = BxTest*B;
	% Cross-Modal Retrieval
%     DHamm1 = hammingDist(tBX, dBX); 
    [~, orderH1] = sort(DHamm1, 2,'descend');

        evaluation_info.Image_VS_Text_MAP = mAP(orderH1',LTrain,LTest);
%         evaluation_info.Image_VS_Text_MAP = perf_metric4Label(LTrain,LTest, DHamm1');
        evaluation_info.I2Ttop = mean(precision_at_k(orderH1', LTrain, LTest,100,100));
%          [evaluation_info.I_VS_T_precision, evaluation_info.I_VS_T_recall] = precision_recall(orderH1', LTrain, LTest);
%         evaluation_info.I_VS_T_TopK=precision_at_k(orderH1', LTrain, LTest,2001,20);
    ByTest = sgn(YKTest*YW); 
    DHamm2 = ByTest*B;
%     DHamm2 = hammingDist(tBY, dBY);
       [~, orderH2] = sort(DHamm2, 2,'descend');
       evaluation_info.Text_VS_Image_MAP = mAP(orderH2',LTrain,LTest);
%         evaluation_info.Text_VS_Image_MAP = perf_metric4Label(LTrain,LTest,DHamm2');        
        evaluation_info.T2Itop = mean(precision_at_k(orderH2', LTrain, LTest,100,100));
    t2 = clock;
    T1 = etime(t2,t1);
%         [evaluation_info.T_VS_I_precision,evaluation_info.T_VS_I_recall] = precision_recall(orderH2', LTrain, LTest);
%    evaluation_info.T_VS_I_TopK=precision_at_k(orderH2', LTrain, LTest,2001,20);
    compressiontime=toc;
    evaluation_info.Time = T1;
    evaluation_info.BX = BxTest;
    evaluation_info.BY = BxTest;
    evaluation_info.compressT=compressiontime;
%     evaluation_info.B = B;

    
   
    clear B XW YW
end