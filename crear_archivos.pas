{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program crear_archivos;
uses Crt;

procedure Bancos;
type        
    Banco = record
        codigoBanco: integer; {(c?digo de banco)}
        nombreBanco: string [30];
    end;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
begin
    assign(archivoBancos, 'C:\ayed\tp3\bancos.dat');
    rewrite(archivoBancos);
    
    nuevoBanco.nombreBanco := 'Banco Patagonia';
    nuevoBanco.codigoBanco := 12345678;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombreBanco := 'Banco Nacion';
    nuevoBanco.codigoBanco := 87654321;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombreBanco := 'Banco Galicia';
    nuevoBanco.codigoBanco := 12348765;
    Write(archivoBancos, nuevoBanco);

    close(archivoBancos);
end;

begin
  Bancos;
  ReadKey;
end.
