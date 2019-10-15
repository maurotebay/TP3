{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program crear_archivos;
uses Crt;

const
    RUTA_ARCHIVOS = 'C:\Users\mauro\Desktop\Facultad\Algoritmos\TPs\TP3\';

type
    Usuario = record
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
    Comercio = record
        cod_com: integer;
        nombre: string[30];
        cuit: string[12];
        estado: boolean;
    end;
    Banco = record
        cod_ban: integer; {(codigo de banco)}
        nombre: string[30];
    end;

procedure Bancos;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
begin
    assign(archivoBancos, RUTA_ARCHIVOS + 'Bancos.dat');
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
    archivoComercios:file of Comercio;
    nuevoComercio: Comercio;
begin
    assign(archivoComercios, RUTA_ARCHIVOS + 'Comercios.dat');
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
    archivoCuentas: file of cuentaVirtual;
    newCuenta: cuentaVirtual;
begin
    assign(archivoCuentas, RUTA_ARCHIVOS + 'cuentas-virtuales.dat');
    rewrite(archivoCuentas);

    newCuenta.dni:='21568468';
    newCuenta.saldo_billetera := 420.65;
    newCuenta.cuenta_virtual[1].cod_ban:=25635125;
    newCuenta.cuenta_virtual[1].tipo_tar:='D';
    newCuenta.cuenta_virtual[1].saldo_x_tarjeta:=565.29;

    newCuenta.cuenta_virtual[2].cod_ban:=25566674;
    newCuenta.cuenta_virtual[2].tipo_tar:='C';
    newCuenta.cuenta_virtual[2].saldo_x_tarjeta:=5565.29;

    write(archivoCuentas, newCuenta);

    close(archivoCuentas);
end;

procedure Usuarios;
var
    archivoUsuarios:file of usuario;
    newUsuario:usuario;
begin
    assign(archivoUsuarios, RUTA_ARCHIVOS + 'usuarios.dat');
    rewrite(archivoUsuarios);

    newUsuario.dni:='44556699';
    newUsuario.contrasena:=12345;
    newUsuario.ape_nom:='Juan Perez';
    newUsuario.mail:='juanperez@tumail.com';

    write(archivoUsuarios, newUsuario);

    newUsuario.dni:='56832145';
    newUsuario.contrasena:=54625;
    newUsuario.ape_nom:='Jose Gomez';
    newUsuario.mail:='pepegomez@tumail.com';

    write(archivoUsuarios, newUsuario);

    close(archivoUsuarios);
end;

procedure Movimientos;
var
    archivoMovimientos:file of movimiento;
    newMovimiento:movimiento;
begin
    assign(archivoMovimientos, RUTA_ARCHIVOS + 'movimientos.dat');
    rewrite(archivoMovimientos);

    newMovimiento.dni:='12345678';
    newMovimiento.cod_ban:=12546;
    newMovimiento.tipo_tar:='D';
    newMovimiento.importe:=256.12;
    newMovimiento.tipo_movi:='C';
    newMovimiento.dia:=17;
    newMovimiento.mes:=7;
    newMovimiento.ano:=2017;
    newMovimiento.cod_com:=2525;
    newMovimiento.dni_otro_usuario:='32165487';

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
