program parcial1;
const 
    valorAlto = 999;

type
    presentacion = record    
        codArtista : integer;
        nomArtista: string;
        año: integer;
        codEvento: integer;
        nomEvento: string;
        cantLikes: integer;
        cantDiskiles: integer;
        puntaje: integer;
    end

    archivo: file of presentacion;

procedure leer ( var a: archivo, var reg: presentacion)
begin
    if (not EOF (a)) then 
        read (a,reg)
    else
        reg.año:=valorAlto;
    end;



procedure informe ( var a: archivo)
var 
    reg: presentacion
    actual: presentacion
    likesTotales: integer;
    dislikesTotales: integer;
    diferencia: integer;
    puntajeTotal: integer;
    artistaMenosInfluyente: integer;
    cantAños: integer;
    cantPresentaciones: integer
    totalpresentaciones: integer:
    puntajeMin : integer;
    dislikeMax: integer;



begin   
    cantAños := 0
    reset (a);
    leer (a,reg);
    // primero
    totalpresentaciones := 0;
    while ( reg.año <> valorAlto) do    
    begin   
        actual.año = reg.año
        writeln("Año", actual.año)
        cantPresentaciones := 0;
        cantAños := cantAños +1;
        // mientras sea el mismo año 
        while ( actual.año = reg.año) do
        begin   
            actual.nomEvento := reg.nomEvento;
            actual.codEvento := reg.codEvento;
            writeln ("Evento": actual.nomEvento,"Codigo:", actual.codEvento);
            // para el calculo de min y max
            puntajeMin := 9999;
            dislikesMax:= 1;
            //mientras sea el mismo evento y año
            while ( actual.año = reg.año) and ( actual.codEvento  = reg.codEvento)
                begin   
                    actual.codArtista := actual.nomArtista;
                    writeln ("Artista", actual.nomArtista)
                    likesTotales :=0;
                    dislikesTotales:= 0;
                    puntaje :=0;
                    diferencia:=0;
                    //mientras sea el mismo evento , año y artista
                    while ( actual.año = reg.año) and ( actual.codEvento  = reg.codEvento) and  ( actual.codArtista  = reg.codArtista) do
                        begin   
                            cantPresentaciones := cantPresentaciones + 1;
                            likesTotales:= likesTotales + reg.cantLikes;
                            dislikesTotales := dislikesTotales + reg.cantDiskiles;
                            puntaje:= puntaje + reg.puntaje;
                            leer (a,reg)
                        end // cambio de artista 
                    if (act.puntaje < puntajeMin) or ((act.puntaje = puntajeMin) and  
                    (act.cantDislikes > dislikesMax)) then begin 
                    puntajeMin := act.puntaje; 
                    dislikesMax := act.cantDislikes; 
                    nombreArtista := act.nombreArtista; 
                    end 
                    writeln ( likesTotales)
                    writeln (dislikesTotales)
                    writeln ("diferencia")
                    writeln ("nombre artista:");
                    //fin evento
                end; // muentro lo del evento
                writeln (el artistaf fue el menos influyente del evento x, año x)
                //fin año
        end //muestro lo del año
        writeln (durante el año , act.año se registraron, cantPresentaciones)
        totalpresentaciones := totalpresentaciones + cantPresentaciones
        // fin del archivo
    end
     writeln (el promedio actual de presentaciones es de (totalpresentaciones/cantAños));
    cose(a)
end.


            
            

            

        
        
                



        
