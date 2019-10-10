
{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program tp3;
uses Crt;

{Esta opcion listara primero todas las entidades bancarias que ya est?n cargadas en el sistema en bancos.dat, y permitir? ingresar nuevos bancos. Por cada nuevo ingreso se deber? registrar el c?digo del banco y el nombre de la entidad.}
procedure OpcionBancos;
type        
    Banco = record
        codigoBanco: integer; {(codigo de banco)}
        nombre: string [30];
    end;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
    opcion: string;
begin
    assign(archivoBancos, 'C:\ayed\tp3\bancos.dat');
    reset(archivoBancos);

    WriteLn('Listado de entidades bancarias: ');
    WriteLn('');
    while not eof(archivoBancos) do
    begin
        read(archivoBancos, nuevoBanco);
        writeln('Nombre: ', nuevoBanco.nombre);
        writeln('Codigo: ',  nuevoBanco.codigoBanco);
        writeln('');
    end;
    
    repeat
        WriteLn('Desea ingresar un nuevo banco? (si / no)');
        ReadLn(opcion);
        if ((opcion = 'si') OR (opcion = 'SI') OR (opcion = 'Si')) then 
            begin
                WriteLn('Ingrese el nombre del banco');
                ReadLn(nuevoBanco.nombre);
                WriteLn('Ingrese el codigo del banco');
                ReadLn(nuevoBanco.codigoBanco);
                Write(archivoBancos, nuevoBanco);
            end;
    until (opcion = 'no') OR (opcion = 'NO') OR (opcion = 'No');
    
    close(archivoBancos);
end;

procedure OpcionABM;
type
    Comercio = record
        codigoComercio:integer;
        nombre:string[30];
        cuit:string[12];
        estado:boolean;
        end;
var
    archivoComercios:file of Comercio;
    nuevoComercio: Comercio;
    opcion, posFinal, codigoComercio: integer;

begin
    ClrScr;
    WriteLn('   ABM de comercios adheridos.');
    WriteLn;

    {muestro contenido para testear funcionamientno.}
    assign(archivoComercios, 'C:\ayed\tp3\comercios.dat');
    reset(archivoComercios); 
    while not eof(archivoComercios) do
    begin
        read(archivoComercios, nuevoComercio);
        writeln('Nombre: ', nuevoComercio.nombre);
        writeln('cuit: ',  nuevoComercio.cuit);
        writeln('estado: ',  nuevoComercio.estado);
        writeln('codigo: ',  nuevoComercio.codigoComercio);
        writeln('');
    end;
    Close(archivoComercios);
    WriteLn('1) Alta');
    WriteLn('2) Baja');
    WriteLn('3) Modificacion');
    WriteLn('4) Salir');
    repeat
        Write('Seleccione ingresando una de las opciones: ');
        ReadLn(opcion);
    until (opcion >= 1) AND (opcion <= 4);
    case opcion of
        1: begin
            ClrScr;
            WriteLn('   Alta Comercio.');
            WriteLn;

            assign(archivoComercios, 'C:\ayed\tp3\comercios.dat');
            reset(archivoComercios);    

            posFinal := FileSize(archivoComercios);{el primer elemento esta en la pos 0, por lo que en la pos FileSize no hay ningun elemento}
            Seek(archivoComercios, posFinal); {muevo el puntero a la posicion final}

            WriteLn('Ingrese el nombre del comercio');
            ReadLn(nuevoComercio.nombre);
            WriteLn('Ingrese el cuit del comercio');
            ReadLn(nuevoComercio.cuit);
            nuevoComercio.codigoComercio := posFinal;
            nuevoComercio.estado := True;
            Write(archivoComercios, nuevoComercio);

            Close(archivoComercios);
            WriteLn('El Comercio se ha agregado satisfactoriamente.');

            readkey;
            OpcionABM;
        end;
        2: begin
            ClrScr;
            WriteLn('   Baja Comercio.');
            WriteLn;

            assign(archivoComercios, 'C:\ayed\tp3\comercios.dat');
            reset(archivoComercios);

            WriteLn('Ingrese el codigo del comercio a dar de baja');
            ReadLn(codigoComercio);

            if codigoComercio <= FileSize(archivoComercios)then
            begin
                Seek(archivoComercios, codigoComercio);{al estar ordenado, el codigo coincide con el puntero.}
                Read(archivoComercios, nuevoComercio);{leo el comercio a dar de baja}

                if nuevoComercio.estado then
                begin
                    nuevoComercio.estado := False;
                    Seek(archivoComercios, codigoComercio);{vuelvo a la posicion, ya que el read aumenta el puntero}
                    Write(archivoComercios, nuevoComercio);{sobreescribo el comercio modificado en la misma posicion que estaba.}
                    WriteLn('El comercio se ha dado de baja satisfactoriamente.');
                end
                else WriteLn('El comercio ya estaba dado de baja.');


            end
            else WriteLn('El codigo de comercio no fue encontrado.');

            close(archivoComercios);
            ReadKey;
            OpcionABM;
        end;
        3: begin
            ClrScr;
            {Modificacion;}
            ReadKey;
            OpcionABM;
        end;
    end
end;

procedure OpcionUsuarios;
begin
  
end;

procedure Menu;
var
    opcion: integer;
begin
    ClrScr;
    WriteLn('   MENU');
    WriteLn;
    WriteLn('1) Bancos');
    WriteLn('2) ABM de Comercios Adheridos');
    WriteLn('3) Usuarios');
    WriteLn('4) Fin');
    repeat
        Write('Seleccione ingresando una de las opciones: ');
        ReadLn(opcion);
    until (opcion >= 1) AND (opcion <= 4);
    case opcion of
        1: begin
            ClrScr;
            OpcionBancos;
            Menu;
        end;
        2: begin
            ClrScr;
            OpcionABM;
            Menu;
        end;
        3: begin
            ClrScr;
            OpcionUsuarios;
            Menu;
        end;
    end;
end;

begin
  Menu;
  Write('Presione cualquier tecla para salir del programa');
  ReadKey;
end.





