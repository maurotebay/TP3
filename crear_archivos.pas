{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program crear_archivos;
uses Crt;

procedure Bancos;
type        
    Banco = record
        codigoBanco: integer; {(c?digo de banco)}
        nombre: string [30];
    end;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
begin
    assign(archivoBancos, 'C:\ayed\tp3\bancos.dat');
    rewrite(archivoBancos);
    
    nuevoBanco.nombre := 'Banco Patagonia';
    nuevoBanco.codigoBanco := 12345678;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombre := 'Banco Nacion';
    nuevoBanco.codigoBanco := 87654321;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombre := 'Banco Galicia';
    nuevoBanco.codigoBanco := 12348765;
    Write(archivoBancos, nuevoBanco);

    close(archivoBancos);
end;

procedure Comercios;
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
begin
    assign(archivoComercios, 'C:\ayed\tp3\comercios.dat');
    rewrite(archivoComercios);

    nuevoComercio.codigoComercio:=0;
    nuevoComercio.nombre:='Carrefour';
    nuevoComercio.cuit:='123456789124';
    nuevoComercio.estado:=True;
    write(archivoComercios, nuevoComercio);

    nuevoComercio.codigoComercio:=1;
    nuevoComercio.nombre:='Sugarosa';
    nuevoComercio.cuit:='321654987654';
    nuevoComercio.estado:=True;
    write(archivoComercios, nuevoComercio);

    nuevoComercio.codigoComercio:=2;
    nuevoComercio.nombre:='Micropack';
    nuevoComercio.cuit:='159753426857';
    nuevoComercio.estado:=True;
    write(archivoComercios, nuevoComercio);

    close(archivoComercios);
end;


begin
  Bancos;
  Comercios;
  ReadKey;
end.
