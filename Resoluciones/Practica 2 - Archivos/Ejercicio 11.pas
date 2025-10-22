program ej11;

const valorAlto = 999;

type    
    empleado = record 
        departamento: integer;
        division: integer;
        numEmpleado: integer;
        categoria: string; 
        horasExtras: integer;
    end

    archivo: file of empleado

procedure leer (var a: archivo, var reg: empleado)
begin
    if (not eof(a)) then
        read (a,reg)
    else 
        reg.departamento := valorAlto;
end

procedure 