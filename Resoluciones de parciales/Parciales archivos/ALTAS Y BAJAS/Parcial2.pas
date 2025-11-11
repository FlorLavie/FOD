{Se cuenta con un archivo con información de los diferentes empleados que trabajan en una empresa.
De cada empleado se conoce:
número, nombre, apellido, dni, fecha de nacimiento y género.
El número de empleado no puede repetirse.

Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida con registro cabecera (si el campo numérico en el registro cabecera es cero, no hay espacio para reutilizar).

Escriba la definición de las estructuras de datos necesarias y los siguientes procedimientos:

a) ExisteEmpleado

Módulo que, dado un número de empleado, devuelve la posición (NRR) en el archivo donde se encuentra el empleado con el número especificado (en caso de que exista).
En caso de que el empleado no exista, devuelve el valor cero.

b) AltaEmpleado

Módulo que lee por teclado los datos de un nuevo empleado y lo agrega al archivo, reutilizando espacio disponible en caso de que lo hubiera.
En caso de que el número ingresado ya exista en el archivo, se debe informar por pantalla que el empleado ya existe (el control de unicidad se debe realizar utilizando el módulo ExisteEmpleado).

c) BajaEmpleado

Módulo que da de baja lógicamente un empleado cuyo número se lee por teclado.
Para marcar un empleado como borrado se debe utilizar el campo número para mantener actualizada la lista invertida.
Para buscar el empleado a borrar y verificar que exista se debe utilizar el módulo ExisteEmpleado.
En caso de no existir, se debe informar “Empleado no existente”.}

program parcial2; 
type
    empleado = record
        numero : integer;
        nombre: string;
        apellido: string;
        dni: string;
        fechaNac: string;
        genero: string;
    end

    archivo: file of empleado;

    procedure existeEmpleado ( var a: archivo; numero: integer; var pos: integer)
    var
        ok: boolean;
        reg: empleado;
    begin
        reset (a)
        ok := false;

        while (not eof (a) and (ok:=false)) do
        begin
            read (a,reg)
            if (reg.numero = numero) then
                ok:= true;
                pos:= filepos (a) - 1;
            end;
    end;

    close (a);

    end;


    procedure altaEmpleado (var a: archivo);
    var 
        reg, cabecera: empleado,
        numero: integer;
        pos: integer;
    begin   
        pos:=0;
        reset ( a);
        read (a ,cabecera);

        writeln("ingrese numero de empleado a agregar");
        read (numero);

        ExisteEmpleado (a,numero, pos);
        // si ya existe el empleado
        if (pos <> 0) then 
        begin
            writeln("ese empleado ya existe");
        else
        begin
           // leo el resto de los datos
                writeln ("ingrese nombre");
                read (reg.nombre);
                writeln ("ingrese apellido");
                read (reg.apellido);
                
                writeln ("ingrese dni");
                read (reg.dni);
                
                writeln ("ingrese fechaNacimiento");
                read (reg.fechaNacimiento);
                
                writeln ("ingrese genero");
                read (reg.genero);

            // si no hay espacio libres se agrega al final
            if (cabecera.numero = 0) then
                seek (a, filesize (a));
                write (a,reg);
            else   
            // sino en el lugar libre 
            begin 
                seek (a, cabecera.numero * - 1);
                read (a,cabecera);
                seek (a,filepos(a)- 1);
                write (a ,reg);
                seek (a,0);
                write (a , cabecera);
            end;
        end;
    close (a);
    end;

    procedure bajaEmpleado (var a: archivo);
    var
        reg, cabecera: empleado,
        numero: integer;
        pos: integer;
    begin   
        pos:=0;
        writeln ("Ingrese numero de empleado a eliminar);
        read (numero );

        ExisteEmpleado (a,numero,pos);

        // si no existe ese empleado
        if (pos =0 ) then  
            writeln ("no existe ese empleado");
        else
        begin
            reset (a);
            read (a,cabecera);

            seek (a,pos);
            write (a , cabecera);
            cabecera := -pos;
            seek (a,0);
            write (a, cabecera);

            close (a);
        end;
    end;

    var
        a: archivo;
    begin
    end.
             
           
               


        end;
