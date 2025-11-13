{Suponga que tiene un archivo con información referente a los empleados que trabajan en una multinacional.
De cada empleado se conoce el dni (único), nombre, apellido, edad, domicilio y fecha de nacimiento.

Se solicita hacer el mantenimiento de este archivo utilizando la técnica de reutilización de espacio llamada lista invertida.

Declare las estructuras de datos necesarias e implemente los siguientes módulos:

Agregar empleado

Solicita al usuario que ingrese los datos del empleado y lo agrega al archivo solo si el DNI ingresado no existe.
Suponga que existe una función llamada existeEmpleado que recibe un DNI y un archivo, y devuelve verdadero si el DNI existe en el archivo y falso en caso contrario.
La función existeEmpleado no debe implementarla.
Si el empleado ya existe, debe informarlo en pantalla.

Quitar empleado

Solicita al usuario que ingrese un DNI y lo elimina del archivo solo si este existe.
Debe utilizar la función existeEmpleado.
En caso de que el empleado no exista, debe informarse en pantalla.

Nota:
Los módulos que debe implementar deben guardar en memoria secundaria todo cambio que se produzca en el archivo.}

program parcial1;

type
    fecha = record
        dia: 1..31;
        mes: 1..12;
        anio: integer;
    end;

    empleado = record   
      dni: integer;
      nombre: string;
      apellido: string;
      edad: string;
      domicilio: string;
      fechaNac: fecha;
    end;

    archivo  = file of empleado; 

    procedure agregarEmpleado (var a: archivo);
    var 
     reg, cabecera: empleado;
     dni: integer;
    begin
        reset (a);
        read (a, cabecera);

        write ("Ingrese dni");
        readln (dni);

        if existeEmpleado (dni, a) then
        begin 
            write ("el empleado ya existe");
        else 
        begin 
            reg.dni := dni;
            write (Ingrese nombre);
            read (reg.nombre)
            write (Ingrese apellido);
            read (reg.apellido)
            write (Ingrese edad);
            read (reg.edad)
            write (Ingrese domicilio);
            read (reg.domicilio)
            write (Ingrese fechaNac);
            read (reg.fechaNac)
            
        // si no hay espacio libre agrego al final
        if ( cabecera.dni = 0) then
        begin   
            seek  (a, filesize (a));
            write (a , reg);
        else
        begin   
        // si hay espacio libre reutilizao el primero
          seek (a, cabecera.dni * -1);
          read (a, cabecera);
          seek (a, filepos (a) - 1);
          write (a , reg);
          seek (a, 0);
          write (a , cabecera);
        end; 

         writeln('Empleado agregado correctamente.');
  end;

  close(arc);
end;

procedure baja ( var a: archivo);
var 
    reg, cabecera: empleado;
    dni: integer;
    ok: boolean;
    
begin
  write ("ingrese dni a eliminar");
  readln (dni);

  // verifico si el dni existe
  if not existeEmpleado (dni, a) then
    write ("el dni no corresponde a un empleado");
  else 
  begin 
    reset (a);
    read (a, cabecera) ;
    ok:= false;

    // recorro buscando donde insertar el empleado
    while (not eof (a) and (ok :=false)) do
    begin
        read(a, reg);
        if (reg.dni = dni) then
        begin  
            ok:= true;
            seek (a, filePos (a) - 1);
            write (a, cabecera);
            cabecera.dni := (filePos(a)-1) *-1;
            seek (a,0);
            write (a, cabecera )
        end;
    end;

    close (a);    
        if ok then
      writeln('Empleado eliminado correctamente.');
  end;
end;







    end;

