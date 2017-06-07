function  numbers = VtachToTransientValues( Vtach )
% returns percent overshoot, rise-time,
% peak time, and settling time 
    Time = Vtach(:,2);
    Signal = Vtach(:,1);
    %Chop data
    Signal = Signal(find(Time==1):end);
    Time = Time(find(Time==1):end);
    Vss = mean(Signal(end-10:end)); %get the steady-state value
    [Vmax,imax] = max(Signal); % get the max of the signal and its index
    POS = 0;
    Tp = 0;
    if(Vmax > Vss) % if there is overshoot
       POS = (Vmax-Vss)/Vss*100; %Calculate percent overshoot
       Tp = Time(imax)-1; %Calculate peak time
    end
    % settling time
    V_2p = Vss*1.02;
    V_2m = Vss*0.98;
    i_high = find(Signal>V_2p);
    i_low = find(Signal<V_2m);
    [m,n]=size(i_high);
    if(m>0)
        if(Signal(i_low(end))<Signal(i_high(1)))
            Ts=abs(Time(i_low(end))-Time(i_high(1)));
        end 
        if(Signal(i_low(end))>Signal(i_high(1)))
            Ts=abs(Time(i_high(1))-1);
        end
    end
    if(m==0)
        Ts=i_low(1);
    end
    %rise time
    V_90 = Vss*0.9;
    V_10 = Vss*0.1; % added in 0.5V for deadzone
    i_90 = find( Time<(Tp+1));
    i_10 = find(Signal>V_10);
    %90% time minius 10% time
    Tr = Time(i_90(end))-Time(i_10(1));
    
    numbers=[POS, Ts, Tr, Tp,Vss] ;
end

