
{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program tp3;
uses Crt;

procedure OpcionBancos;
begin
  
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
