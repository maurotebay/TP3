{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program crear_archivos;
uses Crt;

const
    RUTA_ARCHIVOS = 'C:\ayed\tp3\';

type
    usuario = record
        dni: string[8];
        contrasena: integer;
        ape_nom: string[30];
        mail: string[40];
    end;
    tarjeta = record
        cod_ban: integer;
        tipo_tar: char; //D:debito, C:Credito
        saldo_x_tarjeta: real;
    end;
    cuentaVirtual = record
        dni: string[8];
        cuenta_virtual: array [1..5] of tarjeta;
        saldo_billetera: real;
    end;
    movimiento = record
        dni: string[8];
        cod_ban: integer;
        tipo_tar: char; //D:debito, C:credito
        importe: real;
        tipo_movi: char; //C:compras, E:envio
        dia, mes, ano: word;
        cod_com: integer;
        dni_otro_usuario: string[8];
    end;
    comercio = record
        cod_com: integer;
        nombre: string[30];
        cuit: string[12];
        estado: boolean;
    end;
    banco = record
        cod_ban: integer; {(codigo de banco)}
        nombre: string[30];
    end;

var
    archivoBancos: file of banco;
    archivoComercios: file of comercio;
    archivoCuentas: file of cuentaVirtual;
    archivoUsuarios: file of usuario;
    archivoMovimientos: file of movimiento;

procedure Bancos;
var
    nuevoBanco: Banco;
begin
    assign(archivoBancos, RUTA_ARCHIVOS + 'bancos.dat');
    rewrite(archivoBancos);
    
    nuevoBanco.nombre := 'Banco Patagonia';
    nuevoBanco.cod_ban := 12345678;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombre := 'Banco Nacion';
    nuevoBanco.cod_ban := 87654321;
    Write(archivoBancos, nuevoBanco);

    nuevoBanco.nombre := 'Banco Galicia';
    nuevoBanco.cod_ban := 12348765;
    Write(archivoBancos, nuevoBanco);

    close(archivoBancos);
end;

procedure Comercios;
var
    nuevoComercio: Comercio;
begin
    assign(archivoComercios, RUTA_ARCHIVOS + 'comercios.dat');
    rewrite(archivoComercios);

    nuevoComercio.cod_com:=0;
    nuevoComercio.nombre:='Carrefour';
    nuevoComercio.cuit:='123456789124';
    nuevoComercio.estado:=True;
    write(archivoComercios, nuevoComercio);

    nuevoComercio.cod_com:=1;
    nuevoComercio.nombre:='Sugarosa';
    nuevoComercio.cuit:='321654987654';
    nuevoComercio.estado:=True;
    write(archivoComercios, nuevoComercio);

    nuevoComercio.cod_com:=2;
    nuevoComercio.nombre:='Micropack';
    nuevoComercio.cuit:='159753426857';
    nuevoComercio.estado:=True;
    write(archivoComercios, nuevoComercio);

    close(archivoComercios);
end;

procedure CuentasVirtuales;
var
    newCuenta: cuentaVirtual;
begin
    assign(archivoCuentas, RUTA_ARCHIVOS + 'cuentas-virtuales.dat');
    rewrite(archivoCuentas);

    newCuenta.dni:='11111111';
    newCuenta.saldo_billetera := 500.65;

    newCuenta.cuenta_virtual[1].cod_ban:=12345678;
    newCuenta.cuenta_virtual[1].tipo_tar:='C';
    newCuenta.cuenta_virtual[1].saldo_x_tarjeta:=20.0;

    write(archivoCuentas, newCuenta);

    newCuenta.dni:='12345678';
    newCuenta.saldo_billetera := 1000;

    newCuenta.cuenta_virtual[1].cod_ban:=87654321;
    newCuenta.cuenta_virtual[1].tipo_tar:='D';
    newCuenta.cuenta_virtual[1].saldo_x_tarjeta:=565.29;

    newCuenta.cuenta_virtual[2].cod_ban:=87654321;
    newCuenta.cuenta_virtual[2].tipo_tar:='C';
    newCuenta.cuenta_virtual[2].saldo_x_tarjeta:=5565.29;

    write(archivoCuentas, newCuenta);

    close(archivoCuentas);
end;

procedure Usuarios;
var
    newUsuario:usuario;
begin
    assign(archivoUsuarios, RUTA_ARCHIVOS + 'usuarios.dat');
    rewrite(archivoUsuarios);

    newUsuario.dni:='12345678';
    newUsuario.contrasena:=1234;
    newUsuario.ape_nom:='Juan Perez';
    newUsuario.mail:='juanperez@tumail.com';

    write(archivoUsuarios, newUsuario);

    newUsuario.dni:='11111111';
    newUsuario.contrasena:=1111;
    newUsuario.ape_nom:='Jose Gomez';
    newUsuario.mail:='pepegomez@tumail.com';

    write(archivoUsuarios, newUsuario);

    close(archivoUsuarios);
end;

procedure Movimientos;
var
    newMovimiento: movimiento;
begin
    assign(archivoMovimientos, RUTA_ARCHIVOS + 'movimientos.dat');
    rewrite(archivoMovimientos);

    newMovimiento.dni:='12345678';
    newMovimiento.cod_ban:=87654321;
    newMovimiento.tipo_tar:='D';
    newMovimiento.importe:=256.12;
    newMovimiento.tipo_movi:='C';
    newMovimiento.dia:=17;
    newMovimiento.mes:=7;
    newMovimiento.ano:=2017;
    newMovimiento.cod_com:=0;
    newMovimiento.dni_otro_usuario:='';
    write(archivoMovimientos, newMovimiento);

    newMovimiento.dni:='12345678';
    newMovimiento.cod_ban:=0;
    newMovimiento.tipo_tar:=#0;
    newMovimiento.importe:=500.0;
    newMovimiento.tipo_movi:='E';
    newMovimiento.dia:=18;
    newMovimiento.mes:=7;
    newMovimiento.ano:=2017;
    newMovimiento.cod_com:=0;
    newMovimiento.dni_otro_usuario:='11111111';
    write(archivoMovimientos, newMovimiento);

    close(archivoMovimientos);
end;

begin
    WriteLn('Por favor, asegurate que exista la carpeta "' + RUTA_ARCHIVOS + '" antes de continuar.');
    WriteLn('De lo contrario se cerrara el programa sin confirmacion.');
    WriteLn();
    Write('Pulse cualquier tecla para continuar y crear los archivos (si ya existen se sobreescribiran)...');
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
