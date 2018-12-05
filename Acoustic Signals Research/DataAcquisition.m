%%REMINDER: DO NOT RICK ROLL
disp('Hello. Welcome to ACA (ACOUSTIC COLLECTION AND ANALYSIS)')
disp('Written and Tested by Mike DeLeo')
disp('With Guidance from Prof. David Loker')
while true
    disp('To begin, choose an option. Options are case sensitive')
    disp('NOTE: typing EE into any prompt will stop the program')
    disp('DATA COLLECTION MENU:')
    prompt = 'A: Collect data from Microphone Array\nB: Use existing data in a .txt file\nC: HELP';
    choice = input(prompt,'s');
    
    strSEP = '-----------------------------------------------------------------';
    if (strcmp(choice,'EE'))
        return;
    end
    %while loop is flipped. idk why matlab does this, but when the loop is true
    %it does not execute loop
    while  ~((choice == 'a' || choice == 'A') || (choice == 'b' || choice == 'B') || (choice == 'c' || choice == 'C'))
        disp('Invalid input.\n');
        choice = input(prompt,'s');
        if (strcmp(choice,'EE'))
            return;
        end
    end
    if choice == 'a' || choice == 'A'
        choice = 'A';
    elseif choice == 'b' || choice == 'B'
        choice = 'B';
    else
        web('https://www.youtube.com/watch?v=dQw4w9WgXcQ')
    end
    disp(strSEP);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if choice == 'A'
        disp('PREPARING...');
        disp('Duration in seconds:');
        prompt = '->';
        x = input(prompt);
        
        daq.reset;
        %gets a mx1 array of devices on system
        devices = daq.getDevices;
        %TODO, find a way to select the expresscard
        
        %doing the microphones in order is not correct. Flip the first
        %device and the second such that mic 1 has channel 17
        MIChanels = ["ai0" "ai1" "ai2" "ai3" "ai4" "ai5" "ai6" "ai7" "ai8" "ai9" "ai10" "ai11" "ai12" "ai13" "ai14" "ai15"];
        disp('CONNECTING CHANNELS');
        num = 1;
        sess = daq.createSession('ni');%2
        for i = 2:-1:1
            expresscard = devices(1,i);
            for j = 1:1:16
                disp(num);
                num = num + 1;
                sess.addAnalogInputChannel(expresscard.ID,MIChanels(j),'Voltage');
            end
        end
        
        %mPa/div is not supported by the device. must be converted from voltage
        %addTriggerConnection%4
        %5
        disp('CONFIGURING...');
        sess.Rate = 48000;  %48KHz
        sess.DurationInSeconds = x; %duration of 2 seconds
        DURATION = x;
        SAMPLERATE = sess.Rate;
        NUMSAMPLES = sess.NumberOfScans;
        disp(strSEP);
        disp('COLLECTING...');
        sess.startForeground();
        %read ans before the startForeground for details on how it will execute
        disp('CONVERTING...');
        n = 1:1:sess.NumberOfScans;
        for i =1:1:sess.NumberOfScans
            for j = 1:1:32
                ans(i,j) = ans(i,j) / 0.0424;
            end
        end
        Mics = ans;
        disp('COLLECTION COMPLETE');
        disp(strSEP);
        %the above converts from microvolts to mPA
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        clear Mics;
        prompt = 'Enter the file name without quotes (only .txt is supported)';
        file = input(prompt,'s');
        while exist(file,'file') ~= 2
            str = strcat('----Invalid file: ', file, '----');
            disp(str);
            file = input(prompt,'s');
        end
        disp(strSEP);
        disp('IMPORTING...');
        fileID = fopen(file,'r');   %open file for reading
        formatSpec = '%c';                      %every character
        A = fscanf(fileID,formatSpec);          %scan
        fclose(fileID);                         %close
        %array now has every char
        disp('PROCESSING...');
        A = split(A,',');    %split words and numbers
        UNITS = A(9,1);
        SAMPLERATE = str2double(A(10,1));
        NUMSAMPLES = split(A(11,1),';');
        NUMSAMPLES = str2double(NUMSAMPLES(1,1));
        Mics = zeros(NUMSAMPLES,32);
        disp("MICS")
        for i = 1:1:32
            disp(i);
            start = NUMSAMPLES*(i-1);
            end_ = i*NUMSAMPLES;
            weirdDataList(1,i) = A(start+166);
            weirdDataList(2,i) = A(end_+166);
            %weird data list gets the first piece of data that is mixed in
            %with strings. This is done so that Mics may be a number matrix
            %immediately instead of converting it later
            A(start+166)={0};
            A(end_+166)={0};
            Mics(1:NUMSAMPLES+1,i) = str2double(A(start+166:end_+166));
        end
        %the above takes the mic data from the raw list, and puts it into an array
        %every column is a microphone n
        %with the subsequent rows being the data
        disp('CONVERTING...');
        for i =1:1:32
            temp = split(weirdDataList(2,i),';');
            weirdDataList(2,i)=temp(end);
            Mics(1,i) = str2double(weirdDataList(2,i));
        end
        %corrects for some weird data strings
        Mics = Mics(1:end-1,:);%same correction, but at the end
        n = 1:1:NUMSAMPLES;
        DURATION = NUMSAMPLES/SAMPLERATE;
        %mic data is now ready
        disp('FILE IMPORT COMPLETE');
        disp(strSEP);
    end
    
    Ts = 1/SAMPLERATE;
    TIME = 0:Ts:double(NUMSAMPLES)*Ts - Ts;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    while true

        
        disp('ANALYSIS MENU:');
        disp('A: Display specific Microphone Data, or all data');
        disp('B: FFT of specific Microphone');
        disp('C: Power Spectrum');
        disp('D: Spectrogram using STFT');
        disp('E: Listen to Specific Microphone');
        disp('F: Redo Collection');
        prompt = '->';
        
        choice = input(prompt,'s');
        if strcmp(choice,"EE")
            return;
        end
        
        while  ~((choice == 'a' || choice == 'A') || (choice == 'b' || choice == 'B') || (choice == 'c' || choice == 'C') || (choice == 'd' || choice == 'D') ||(choice == 'e' || choice == 'E') || (choice == 'f' || choice == 'F'))
            disp('Invalid input.\n');
            disp('A: Display specific Microphone Data, or all data');
            disp('B: FFT of specific Microphone');
            disp('C: Power Spectrum');
            disp('D: Spectrogram using STFT');
            disp('E: Listen to Specific Microphone');
            disp('F: Redo Collection');
            choice = input(prompt,'s');
            if (strcmp(choice,"EE"))
                return;
            end
        end
        if choice == 'a' || choice == 'A'
            choice = 'A';
        elseif choice == 'c' || choice == 'C'
            choice = 'C';
        elseif choice == 'b' || choice =='B'
            choice = 'B';
        elseif choice == 'd' || choice == 'D'
            choice = 'D';
        elseif choice == 'e' || choice =='E'
            choice = 'E';
        else
            break;
        end
        disp(strSEP);
        
        
        %choice A is the microphone menu
        if choice == 'A'
            while true
                disp('MICROPHONE DATA MENU:');
                disp('1-32: Choose a specific microphone to display');
                disp('ALL: Display all microphones');
                disp('BACK: Go back to Analysis Menu');
                choice = input(prompt,'s');
                if (strcmp(choice,"EE"))
                    return;
                end
                %gets a good sample by redoing
                if str2double(choice) == 'NaN'
                    num = 0;
                else
                    num = str2double(choice);
                end
                testVal = num >=1 && num <=32;
                
                while  ~(testVal || strcmp(choice,'ALL') || strcmp(choice,'BACK'))
                    disp('Invalid input');
                    disp('1-32: Choose a specific microphone to display');
                    disp('ALL: Display all microphones');
                    disp('BACK: Go back to Analysis Menu');
                    choice = input(prompt,'s');
                    if str2double(choice) == 'NaN'
                        num = 0;
                    else
                        num = str2double(choice);
                    end
                    if (strcmp(choice,"EE"))
                        return;
                    end
                end
                %plots each microphone
                
                if strcmp(choice,'ALL')
                    for i=1:1:32
                        figure(i);
                        plot(TIME,Mics(:,i))
                        xlabel("Seconds")
                        ylabel("20 mPa/div");
                        title("Microphone " + i)
                    end
                elseif strcmp(choice,'BACK')
                    break;
                else
                    i = str2double(choice);
                    figure(i);
                    plot(TIME,Mics(:,i))
                    xlabel("Seconds")
                    ylabel("20 mPa/div");
                    title("Microphone " + i)
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif choice == 'B'
           % clear i j N freq Fs Ts;
            while true
                disp('FFT DATA MENU:');
                disp('1-32: Choose a specific microphone FFT to display');
                disp('ALL: Display all microphone FFTs');
                disp('BACK: Go back to Analysis Menu');
                choice = input(prompt,'s');
                if (strcmp(choice,"EE"))
                    return;
                end
                if str2double(choice) == 'NaN'
                    num = 0;
                else
                    num = str2double(choice);
                end
                %gets a good sample by redoing
                while  ~((num >= 1 && num <= 32) || strcmp(choice,'ALL') || strcmp(choice,'BACK'))
                    disp('Invalid input');
                    disp('1-32: Choose a specific microphone FFT to display');
                    disp('ALL: Display all microphone FFTs');
                    disp('BACK: Go back to Analysis Menu');
                    choice = input(prompt,'s');
                    if str2double(choice) == 'NaN'
                        num = 0;
                    else
                        num = str2double(choice);
                    end
                    if (strcmp(choice,"EE"))
                        return;
                    end
                end
                %plots each microphone FFT
                
                if strcmp(choice,'ALL')
                    for i=1:1:32
                        Fs = SAMPLERATE;
                        len = length(TIME);
                        freq = Fs*(0:(len/2))/len;
                        
                        X = fft(Mics(:,i));
                        if size(freq,2) < size(X,1)
                            X(end)=[];
                        end
                        if size(freq,2) > size(X,1)
                            freq(end) = [];
                        end
                        freq(1,1)=0;
                        X = abs(X)
                        X = X(1:len/2+1);
                        X(1:10)=0;
                        plot(freq, X);
                        %use bode plot or special function to plot FFT
                        xaxis('Frequency Hz');
                        yaxis('x(f)');
                        xlim([0 24000])
                    end
                    %go back
                elseif strcmp(choice,'BACK')
                    break;
                    %choose the FFT
                else
                    
                    i = str2double(choice);
                    
                    figure(i+32);
                    Fs = SAMPLERATE;
                    len = length(TIME);
                    freq = Fs*(0:(len/2))/len;
                    
                    X = fft(Mics(:,i));
                    if size(freq,2) < size(X,1)
                        X(end)=[];
                    end
                    if size(freq,2) > size(X,1)
                        freq(end) = [];
                    end
                    freq(1,1)=0;
                    X = abs(X)
                    X = X(1:len/2+1);
                    X(1:10)=0;
                    plot(freq, X);
                    %use bode plot or special function to plot FFT
                    xaxis('Frequency Hz');
                    yaxis('x(f)');
                    xlim([0 24000])
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif choice =='C'
            while true
                disp('POWER SPECTRUM MENU:');
                disp('1-32: Choose a specific microphone spectrum to display');
                disp('ALL: Display all microphone spectrums');
                disp('BACK: Go back to Analysis Menu');
                choice = input(prompt,'s');
                if (strcmp(choice,"EE"))
                    return;
                end
                if str2double(choice) == 'NaN'
                    num = 0;
                else
                    num = str2double(choice);
                end
                %gets a good sample by redoing
                while  ~((num >= 1 && num <= 32) || strcmp(choice,'ALL') || strcmp(choice,'BACK'))
                    disp('Invalid input');
                    disp('1-32: Choose a specific microphone FFT to display');
                    disp('ALL: Display all microphone FFTs');
                    disp('BACK: Go back to Analysis Menu');
                    choice = input(prompt,'s');
                    if str2double(choice) == 'NaN'
                        num = 0;
                    else
                        num = str2double(choice);
                    end
                    if (strcmp(choice,"EE"))
                        return;
                    end
                end
                
                t = 0:1/SAMPLERATE:1-1/SAMPLERATE;
                
                if strcmp(choice,'ALL')
                    for i=1:1:32
                        i = str2double(choice);
                        figure(i+32);
                        N = NUMSAMPLES;
                        Fs = SAMPLERATE;
                        x = Mics(:,i)';
                        xdft = fft(x);
                        xdft = xdft(1:N/2+1);
                        psdx = (1/(Fs*N)) * abs(xdft).^2;
                        psdx(2:end-1) = 2*psdx(2:end-1);
                        freq = 0:Fs/length(x):Fs/2;
                        
                        plot(freq,10*log10(psdx))
                        grid on
                        title('Periodogram Using FFT')
                        xlabel('Frequency (Hz)')
                        ylabel('Power/Frequency (dB/Hz)')
                    end
                    %go back
                elseif strcmp(choice,'BACK')
                    break;
                    %choose the FFT
                else
                    i = str2double(choice);
                    figure(i+32);
                    N = NUMSAMPLES;
                    Fs = SAMPLERATE;
                    x = Mics(:,i)';
                    xdft = fft(x);
                    xdft = xdft(1:N/2+1);
                    psdx = (1/(Fs*N)) * abs(xdft).^2;
                    psdx(2:end-1) = 2*psdx(2:end-1);
                    freq = 0:Fs/length(x):Fs/2;
                    
                    plot(freq,10*log10(psdx))
                    grid on
                    title('Periodogram Using FFT')
                    xlabel('Frequency (Hz)')
                    ylabel('Power/Frequency (dB/Hz)')
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif choice == 'D'
            while true
                disp('SPECTROGRAM MENU:');
                disp('1-32: Choose a specific microphone spectrogram to display');
                disp('ALL: Display all microphone spectrograms');
                disp('BACK: Go back to Analysis Menu');
                choice = input(prompt,'s');
                if (strcmp(choice,"EE"))
                    return;
                end
                if str2double(choice) == 'NaN'
                    num = 0;
                else
                    num = str2double(choice);
                end
                %gets a good sample by redoing
                while  ~((num >= 1 && num <= 32) || strcmp(choice,'ALL') || strcmp(choice,'BACK'))
                    disp('Invalid input');
                    disp('1-32: Choose a specific microphone spectrogram to display');
                    disp('ALL: Display all microphone spectrograms');
                    disp('BACK: Go back to Analysis Menu');
                    choice = input(prompt,'s');
                    if str2double(choice) == 'NaN'
                        num = 0;
                    else
                        num = str2double(choice);
                    end
                    if (strcmp(choice,"EE"))
                        return;
                    end
                end
                
                t = 0:1/SAMPLERATE:1-1/SAMPLERATE;
                
                if strcmp(choice,'ALL')
                    for i=1:1:32
                        i = str2double(choice);
                        figure(i+32);
                        N = NUMSAMPLES;
                        Fs = SAMPLERATE;
                        x = Mics(:,i)';
                        xdft = fft(x);
                        xdft = xdft(1:N/2+1);
                        psdx = (1/(Fs*N)) * abs(xdft).^2;
                        psdx(2:end-1) = 2*psdx(2:end-1);
                        freq = 0:Fs/length(x):Fs/2;
                        
                        plot(freq,10*log10(psdx))
                        grid on
                        title('Periodogram Using FFT')
                        xlabel('Frequency (Hz)')
                        ylabel('Power/Frequency (dB/Hz)')
                    end
                    %go back
                elseif strcmp(choice,'BACK')
                    break;
                    %choose the FFT
                else
                    i = str2double(choice);
                    s = spectrogram(Mics(:,i));
                    spectrogram(Mics(:,i),'yaxis')
                end
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif choice == 'E'
            while true
                disp('LISTENING MENU:');
                disp('1-32: Choose a specific microphone to hear');
                
                disp('BACK: Go back to Analysis Menu');
                choice = input(prompt,'s');
                if (strcmp(choice,"EE"))
                    return;
                end
                if str2double(choice) == 'NaN'
                    num = 0;
                else
                    num = str2double(choice);
                end
                %gets a good sample by redoing
                while  ~((num >= 1 && num <= 32) ||  strcmp(choice,'BACK'))
                    disp('Invalid input');
                    disp('1-32: Choose a specific microphone to hear');
                    disp('BACK: Go back to Analysis Menu');
                    choice = input(prompt,'s');
                    if str2double(choice) == 'NaN'
                        num = 0;
                    else
                        num = str2double(choice);
                    end
                    if (strcmp(choice,"EE"))
                        return;
                    end
                end
                %go back
                if strcmp(choice,'BACK')
                    break;
                    %choose the FFT
                else
                    i = str2double(choice);
                    sound(Mics(:,1),SAMPLERATE)
                    
                end
            end
        end
        
        
        
        %         for i = 1:1:32
        %             figure(i);
        %             plot(n,Mics(:,i))
        %             xlabel("Scans/Second")
        %             ylabel("20 mPa/div");
        %             title("Microphone " + i)
        %         end
        %
        %         %fft verification of sample rate. testing with a 1kHz audio sample @ 48kHz
        %         %sample rate
        %         %close all;
        %         Fs = SAMPLERATE;
        %         Ts = 1/Fs;
        %         t = 0:Ts:DURATION;
        %         N = length(t);
        %         freq = -Fs/2:Fs/(N-1):Fs/2;
        %         freq(end) =[];
        %         X = abs(fftshift(fft(Mics(:,24))));
        %         plot(freq, X);
        %         xlim([-2500 2500])
    end
end