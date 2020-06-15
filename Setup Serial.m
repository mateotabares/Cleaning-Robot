function[obj,flag] = setupSerial(comPort)
%Acepta como entrada el indice del puerto serialal que el arduino está conectado 
%Y como salida retorna el obj de la conexión serial y una bandera que sirve
%para saber si ya se habia creado antes el objeto
flag = 1;
obj = serial(comPort);
set(obj,'DataBits',8);
set(obj,'StopBits',1);
set(obj,'BaudRate',115200);
set(obj,'Parity','none');
fopen(obj);

end
