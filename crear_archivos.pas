{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program crear_archivos;
uses Crt;

const
    RUTA_ARCHIVOS = 'C:\ayed\tp3\';

procedure Bancos;
type        
    Banco = record
        codBanco: integer; {(codigo de banco)}
        nombre: string [30];
    end;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
begin
    assign(archivoBancos, RUTA_ARCHIVOS + 'Bancos.dat');
    rewrite(archivoBancos);
    
    nuevoBanco.nombre := 'Banco Patagonia';
    nuevoBanco.codBanco := 12345678;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombre := 'Banco Nacion';
    nuevoBanco.codBanco := 87654321;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombre := 'Banco Galicia';
    nuevoBanco.codBanco := 12348765;
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
    assign(archivoComercios, RUTA_ARCHIVOS + 'Comercios.dat');
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

procedure CuentasVirtuales;
type
    tarjeta = record
        codBanco:integer;
        tipoTarjeta:char; //D:debito, C:Credito
        saldoTarjeta:real;
    end;
    cuentaVirtual = record
        dni:string[8];
        tarjetas:array [1..5] of tarjeta;
        saldoBilletera:real;
    end;
var
    archivoCuentas: file of cuentaVirtual;
    newCuenta: cuentaVirtual;
begin
    assign(archivoCuentas, RUTA_ARCHIVOS + 'cuentas-virtuales.dat');
    rewrite(archivoCuentas);

    newCuenta.dni:='21568468';
    newCuenta.saldoBilletera:=420.65;
    newCuenta.tarjetas[1].codBanco:=25635125;
    newCuenta.tarjetas[1].tipoTarjeta:='D';
    newCuenta.tarjetas[1].saldoTarjeta:=565.29;

    newCuenta.tarjetas[2].codBanco:=25566674;
    newCuenta.tarjetas[2].tipoTarjeta:='C';
    newCuenta.tarjetas[2].saldoTarjeta:=5565.29;

    write(archivoCuentas, newCuenta);

    close(archivoCuentas);
end;

procedure Usuarios;
type
    usuario=record
        dni:string[8];
        pass:integer;
        nombreApellido:string[30];
        mail:string[40];
    end;
var
    archivoUsuarios:file of usuario;
    newUsuario:usuario;
begin
    assign(archivoUsuarios, RUTA_ARCHIVOS + 'usuarios.dat');
    rewrite(archivoUsuarios);

    newUsuario.dni:='44556699';
    newUsuario.pass:=12345;
    newUsuario.nombreApellido:='Juan Perez';
    newUsuario.mail:='juanperez@tumail.com';

    write(archivoUsuarios, newUsuario);

    newUsuario.dni:='56832145';
    newUsuario.pass:=54625;
    newUsuario.nombreApellido:='Jose Gomez';
    newUsuario.mail:='pepegomez@tumail.com';

    write(archivoUsuarios, newUsuario);

    close(archivoUsuarios);
end;

procedure Movimientos;
type
    movimiento=record
        dni:string[8];
        codBanco:integer;
        tipoTarjeta:char; //D:debito, C:credito
        importe:real;
        tipoMovimiento:char; //C:compras, E:envio
        dia, mes, anio: word;
        codigoComercio:integer;
        dniOtroUsuario:string[8];
    end;
var
    archivoMovimientos:file of movimiento;
    newMovimiento:movimiento;
begin
    assign(archivoMovimientos, RUTA_ARCHIVOS + 'movimientos.dat');
    rewrite(archivoMovimientos);

    newMovimiento.dni:='12345678';
    newMovimiento.codBanco:=12546;
    newMovimiento.tipoTarjeta:='D';
    newMovimiento.importe:=256.12;
    newMovimiento.tipoMovimiento:='C';
    newMovimiento.dia:=17;
    newMovimiento.mes:=7;
    newMovimiento.anio:=2017;
    newMovimiento.codigoComercio:=2525;
    newMovimiento.dniOtroUsuario:='32165487';

    write(archivoMovimientos, newMovimiento);

    close(archivoMovimientos);
end;

begin
    WriteLn('Por favor, asegurate que exista la carpeta "' + RUTA_ARCHIVOS + '" antes de continuar.');
    WriteLn('De lo contrario se cerrara el programa sin confirmacion.');
    WriteLn();
    Write('Pulse cualquier tecla para continuar y crear los archivos...');
    ReadKey;
    ClrScr;
    WriteLn('Creando archivos...');
    WriteLn();
    Bancos;
    Comercios;
    CuentasVirtuales;
    Usuarios;
    Movimientos;
    WriteLn('Todos los archivos fueron creados exitosamente en "' + RUTA_ARCHIVOS + '".');
    Write('Pulse cualquier tecla para salir');
    ReadKey;
end.
