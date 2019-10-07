
{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program tp3;
uses Crt;

{Esta opci?n listar? primero todas las entidades bancarias que ya est?n cargadas en el sistema en bancos.dat, y permitir? ingresar nuevos bancos. Por cada nuevo ingreso se deber? registrar el c?digo del banco y el nombre de la entidad.}
procedure OpcionBancos;
type        
    Banco = record
        codigoBanco: integer; {(c?digo de banco)}
        nombreBanco: string [30];
    end;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
    opcion: string;
begin
    assign(archivoBancos, 'bancos.dat');
    while not eof(archivoBancos) do
    begin
        read(archivoBancos, nuevoBanco);
        writeln('Nombre: ', nuevoBanco.nombreBanco);
        writeln('Codigo: ',  nuevoBanco.codigoBanco);
    end;
    
    repeat
        WriteLn('Desea ingresar un nuevo banco? (si / no)');
        ReadLn(opcion);
    until (opcion = 'si') OR (opcion = 'no');
    if opcion = 'si' then 
        begin
            WriteLn('Ingrese el nombre del banco');
            ReadLn(nuevoBanco.nombreBanco);
            WriteLn('Ingrese el codigo del banco');
            ReadLn(nuevoBanco.codigoBanco);
            Write(archivoBancos, nuevoBanco);
            close(archivoBancos);
        end;
end;

procedure OpcionABM;
begin
  
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
            ReadKey;
            Menu;
        end;
        2: begin
            ClrScr;
            OpcionABM;
            ReadKey;
            Menu;
        end;
        3: begin
            ClrScr;
            OpcionUsuarios;
            ReadKey;
            Menu;
        end;
        4: WriteLn('Fin del menu.');
    end
end;

begin
  Menu;
  Write('Presione cualquier tecla para salir del programa');
  ReadKey;
end.
