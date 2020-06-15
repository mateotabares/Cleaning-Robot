%% GUI ROBOT LIMPIADOR DE VENTANAS
% El siguiente script se conecta de froma serial al puerto 8... Recoge distintas variables y 
% presenta una interfaz gráfica para la simulacion del robot 

%Creación del panel
panel=uipanel('Title','|  Interfaz gráfica | Robot limpiador  |');

subplot('Position',[0.5 0.5 0.60 0.60],'Parent', panel)
[x, map]=imread('eia.png');
image(x)
colormap (map)
x = 0;
y = 0.85;
width = 0.13;% measured relative to the figure width
height = 0.1;% measured relative to the figure height
set(gca,'units','normalized','position',[x y width height])
set(gca,'handlevisibility','off','visible','off')

%Creación del botón
if (~exist('button','var'))
    button = uicontrol('FontName','COCOGOOSE ','FontSize',24,'Style','togglebutton','String','Stop',...
        'Position',[10 10 100 50],'Parent', panel, 'ForegroundColor','#044C5B');
end

%Creación del esquema del robot usando el toolbox de Peter Corke
L1 = PrismaticMDH('theta', 0, 'a', 0, 'alpha', pi/2);
L1.qlim=[0,150];
L2 = PrismaticMDH('theta', 0, 'a', 0, 'alpha', pi/2);
L2.qlim=[0,250];
bot = SerialLink([L1 L2], 'name', 'Robot Limpiaventanas');

%En la esquina superior derecha se crea un gráfico de 2 lineas animadas
f1 = subplot( 2, 2, 2,'Parent', panel);
title( 'Motor 1 - Movimiento en el eje X' );
ylabel( '# de pasos' );
xlabel('Tiempo (s)');
f1.XGrid = 'on';
f1.YGrid = 'on';
ani1 = animatedline('Color','#044C5B', 'LineWidth', 2);
ani2 = animatedline('Color','#07BBD3', 'LineWidth', 2,'LineStyle',':');
legend('Señal de control','Posición','Orientation','horizontal');

%En la esquina unferior derecha se crea un gráfico de 2 lineas animadas
f2 = subplot( 2, 2, 4,'Parent', panel);
title( 'Motor 2 - Movimiento en el eje Z' );
ylabel( '# de pasos' );
xlabel('Tiempo (s)');
f2.XGrid = 'on';
f2.YGrid = 'on';
ani3 = animatedline('Color','#044C5B', 'LineWidth', 2 );
ani4 = animatedline('Color','#07BBD3', 'LineWidth', 2,'LineStyle',':' );
legend('Señal de control','Posición','Orientation','horizontal')

%En la esquina inferior izquierda se crea un grafico de barras para mostrar
%las variables de interés
f3=subplot( 2, 2, 3,'Parent', panel);
axis([-10 10 0 100])
b=bar([0 0 0]);
b.EdgeColor = [7/255 187/255 211/255];
b.FaceColor = 'flat';
title( 'Variables de interés');
ylabel( '%' );
ylim([0,100]);
set(gca,'xticklabel',{'Flujo','Vel rodillo','Vel hélice'})

%En la esquina superior izquierda se crea el modelo grafico del robot
f4=subplot( 2, 2, 1,'Parent', panel);
bot.plot([30,0],'workspace',[-30,30,-200,10,-300,50],'view',[-60,45],'tile1color',[7/255 187/255 211/255],'tile2color',[4/255 76/255 91/255],'jointcolor',[7/255 187/255 211/255])

%Se inicializan variables que van a ser usadas dentro del loop
time = 0;
data1 = 0;
data2 = 0;
data3 = 0;
data4 = 0;
count = 0;
count2=0;

%Poner la grafica linda
panel.TitlePosition='centertop'
panel.BackgroundColor='#EFF2F2';
panel.ForegroundColor='#07BBD3';
panel.FontName='COCOGOOSE ';
panel.FontSize=32;
panel.FontWeight='bold'
panel.BorderType='line'
panel.BorderWidth=30;
panel.HighlightColor='#044C5B'

f1.FontName='COCOGOOSE ';
f1.FontSize=16;
f1.XColor = '#044C5B'
f1.YColor = '#044C5B'
f1.ZColor = '#044C5B'
f1.Title.Color= '#07BBD3';
f1.Color = '#EFF2F2'

f2.FontName='COCOGOOSE ';
f2.FontSize=16;
f2.XColor = '#044C5B'
f2.YColor = '#044C5B'
f2.ZColor = '#044C5B'
f2.Title.Color= '#07BBD3';
f2.Color = '#EFF2F2'

f3.FontName='COCOGOOSE ';
f3.FontSize=16;
f3.XColor = '#044C5B'
f3.YColor = '#044C5B'
f3.ZColor = '#044C5B'
f3.Title.Color= '#07BBD3';
f3.Color = '#EFF2F2'

f4.FontName='COCOGOOSE ';
f4.FontSize=16;
f4.XColor = '#044C5B'
f4.YColor = '#044C5B'
f4.ZColor = '#044C5B'
f4.Title.Color= '#07BBD3';
f4.Color = '#EFF2F2'

%Conexión serial al puerto
comPort = 'COM8';
if(~exist('serialFlag','var'))
    [arduino,serialFlag] = setupSerial(comPort);
end

tic
%%
while (get(button,'Value') == 0)
    %Se cuentan el numero de iteraciones
    count = count + 1;
    
    %Lectura de datos 
    data =fscanf(arduino,'%f'); 
    IncomingString = string(data);
    %El mensaje llega como un string largo y se separa en los datos
    IncomingString = regexp(IncomingString, '\s*', 'split'); 
    dato1= str2double(IncomingString{1,1}); 
    dato2= str2double(IncomingString{2,1});
    dato3= str2double(IncomingString{3,1}); 
    dato4= str2double(IncomingString{4,1});
    dato5= str2double(IncomingString{5,1}); 
    dato6= str2double(IncomingString{6,1});
    dato7= str2double(IncomingString{7,1});
    
    %El tiempo transcurrido y los datos se guardan en un vector 
    time(count) = toc;    
    data1(count) = dato1;
    data2(count) = dato2;
    data3(count) = dato3;
    data4(count) = dato4;
    data5(count) = dato5;
    data6(count) = dato6;
    data7(count) = dato7;
    
    %Se actualizan los datos de las lineas animadas y su eje X
    addpoints( ani1, time(count), data1(count) );
    addpoints( ani2, time(count), data2(count) );
    addpoints( ani3, time(count), data3(count) );
    addpoints( ani4, time(count), data4(count) );    
     f1.XLim=[time(count)-10 time(count)];
     f2.XLim=[time(count)-10 time(count)];

    %Cada 2 iteraciones se actualiza el modelo gráfico del robot
    count2=count2+1;
    if (count2==2)
        subplot( 2, 2, 1,'Parent', panel)
        bot.plot([30,dato4*0.377])
        bot.offset = [dato2*0.377,0];
        count2=0;
    end
   
    %Se actualiza el gráfico de barras y cada barra cambia su color 
    %dependiendo de su valor
    subplot( 2, 2, 3,'Parent', panel)
    b.YData=[(data5(count)/1023)*100,(data6(count)/1023)*100,(data7(count)/1023)*100];
    if ((data5(count)/1023)*100<20 || (data5(count)/1023)*100>80)        
       b.CData(1,:) = [122/255 15/255 23/255];
    else 
       b.CData(1,:) = [4/255 76/255 91/255];
    end
    if ((data6(count)/1023)*100<20 || (data6(count)/1023)*100>80)  
       b.CData(2,:) = [122/255 15/255 23/255];
    else %[10/255 35/255 66/255]
       b.CData(2,:) = [4/255 76/255 91/255];
    end
    if ((data7(count)/1023)*100<20 || (data7(count)/1023)*100>80)  
       b.CData(3,:) = [122/255 15/255 23/255];
    else 
       b.CData(3,:) = [4/255 76/255 91/255];
    end
    %Se grafican las actualizaciones
    drawnow;
    %Se cuentan el numero de iteraciones
    count = count + 1;
end
%%
%Se cierra y se elimina la conexión serial
 fclose(arduino);
 delete(arduino);
 clear all
 close all
