{10. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por PROVINCIA y LOCALIDAD. Para ello, se posee un archivo con la siguiente informacion: codigo de provincia, codigo de localidad, numero de mesa y cantidad de votos en dicha mesa-
Presentar en pantalla un listado
}


program ej10;
const 
    valoralto = 999;

type 
    provincia = record
        codProv: integer;
        codLoc: integer;
        mesa: integer;
        cantVotos: integer;
    end;

    archivo = file of provincia;

procedure leer (var a: archivo; var reg: provincia);
begin
    if (not eof(a)) then
        read (a,reg)
    else 
        reg.codProv:= valoralto;
end

procedure contabilizar (var a: archivo);
var 
    reg, actual: provincia;
    total, totalProv, totalLoc, provActual, locActual: integer;
begin
    reset (a);
    leer (a, reg);
    total := 0 ;
   // primer corte de control
    while (reg.codProv <> valoralto) do 
        begin 
            writeln("codigo de provincia: ", reg.codProv);
            totalProv :=0;
            provActual := reg.codProv;
            // mientras que sea la misma provincia
            while ( provActual = reg.codProv) do
                begin
                    writeln("codigo de localidad: ", reg.codLoc)
                    locActual := reg.codLoc;
                    totalLoc := 0;
                    // mientras sea la misma localidad en esa provincia
                    while (provActual = reg.codProv) and (locActual = reg.codLoc) do    
                        begin 
                            totalLoc := totalLoc + reg.cantVotos  
                            leer (a,reg)
                   
                        end
                    writeln ("total Localidad", locActual, "es", totalLoc)
                    totalProv := totalProv + totalLoc ;
                end
                // cuando cambié de provincia: 
            writeln ("total de votos provincia" , totalProv);
            total := total + totalProv;
        end;
    // ya sali de los while informo el total:
    writeln ("el total general es de ", total);
    close (a)
    end

var 
    a: archivo;
    
begin   
    assign (a, "archivo.dat");
    contabilizar(a);. 
end


        

            
          

