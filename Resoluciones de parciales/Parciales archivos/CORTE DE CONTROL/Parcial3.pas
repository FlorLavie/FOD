{Una plataforma educativa organiza cada año una serie de talleres de formación docente en todo el país. Cada taller incluye varias sesiones de capacitación, realizadas en distintas fechas, y un mismo docente capacitador puede participar en más de un taller.

Se dispone de un archivo que contiene los datos de cada sesión individual. Cada registro indica:

código del taller

nombre del taller

cantidad de asistentes a la sesión

cantidad de abandonos (asistentes que no completaron la sesión)

puntaje promedio otorgado por los asistentes (entre 1 y 10)

docente

año en que se realizó la sesión

El archivo está ordenado por año, luego por código de taller y finalmente por código de docente.

Se solicita definir las estructuras de datos necesarias y escribir el módulo que procese el archivo y genere un informe por pantalla con el siguiente formato:

Año: 2023
Taller: "NombreDelTaller1" (Código: codtaller1)

Docente: NombreDocente1 (Código: coddocente1)

Total de asistentes: XX

Total de abandonos: YY

Tasa de abandono: (YY / XX * 100)%

Puntaje acumulado: ZZ

Docente: NombreDocenteN (Código: coddocenteN)
[… igual que el anterior para todos los docentes del taller…]

Al finalizar cada año:

Durante el año 2023 se registraron XX sesiones de capacitación.

Al finalizar todo el procesamiento:

El promedio total de sesiones por año es: XX,XX sesiones.
(Sesiones Totales / Cantidad de Años)}

program parcial3;
const 
    valor_alto = 9999;

type 
    sesion = record
       cod_docente: integer;
       nom_docente: string;
       anio: integer;
       cod_taller: integer;
       nom_taller: string;
       cant_asistentes: integer;
       cant_abandonos: integer;
       puntaje: integer;
    end;

    archivo = file of sesion;

    var 
    a: archivo;

    procedure leer (var a: archivo, var reg:sesion);
    begin
        if not eof (a) then
           read (a,reg)
        else
           reg.anio := valor_alto;
    end;

    procedure informe (var a: archivo)
    var 
        actual, reg: sesion;

        total_asistentes: integer;
        total_abandonos: integer;
        tasa_abandonos: real;
        puntaje_acumulado: integer;

        sesiones_por_anio: integer;
        total_sesiones: integer;
        cant_anios: integer;

    begin
       reset (a);
       leer(a,reg);

       cant_anios: 0;
       total_sesiones :=0;

       while ( reg.anio <> valor_alto ) do 
       begin 
          actual.anio := reg.anio;
          cant_anios := cant_anios + 1;
          writeln ("Año:", actual.anio);
          sesiones_por_anio:=0;

          while (actual.anio = reg.anio) do
          begin
             actual.cod_taller := reg.cod_taller;
             actual.nom_taller := reg.nom_taller;
             writeln ("Taller:", actual.nom_taller, "Codigo:", actual.cod_taller);

             while (actual.anio = reg.anio) and (actual.cod_taller = reg.cod_taller) do
             begin
                 actual.nom_docente:= reg.nom_docente;
                 actual.cod_docente:= actual.cod_docente;

                 total_asistentes :=0;
                 total_abandonos:=0;
                 tasa_abandonos :=0;
                 puntaje_acumulado:=0;

                 while (actual.anio = reg.anio) and (actual.cod_taller = reg.cod_taller) and (actual.cod_docente = reg.cod_docente) do
                 begin
                     total_asistentes := total_asistentes + reg.cant_asistentes;
                     total_abandonos := total_abandonos + reg.cant_abandonos;
                     total_sesiones := total_sesiones + 1;
                     sesiones_por_anio := sesiones_por_anio + 1;
                     puntaje_acumulado := puntaje_acumulado + reg.puntaje;
                     leer (a,reg);
                end;
            writeln ("Docente:", actual.nom_docente, "codigo", actual.cod_docente);
            writeln ("Total Asistentes:", total_asistentes);
            writeln ("Total abandonos:", total_abandonos);
            writeln ("Tasa de abandono:", (total_asistentes/total_abandonos * 100));
            writeln ("Pntaje acumulado:", puntaje_acumulado);
        end;
    end;

    writeln ("durante el año" , actual.anio , " se registraron" , sesiones_por_anio , "sesiones);

    end;

writeln ("El promedio total de sesiones por año es", (total_sesiones / cant_anios) ,"sesiones.")

close (a)

end.