
{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program tp3;
uses Crt, sysutils;

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
    archivoUsuarios: file of usuario; { los archivos son globales para asignarlos por unica vez }
    archivoComercios: file of comercio;
    archivoCuentas: file of cuentaVirtual;
    archivoBancos: file of banco;
    archivoMovimientos: file of movimiento;
    usuarioIniciado: integer; { es global para mantener la sesion iniciada y permitir un ingreso por primera vez }

{Esta opcion listara primero todas las entidades bancarias que ya estan cargadas en el sistema en bancos.dat, y permitira ingresar nuevos bancos. Por cada nuevo ingreso se debera registrar el codigo del banco y el nombre de la entidad.}
procedure OpcionBancos;
var
    nuevoBanco: Banco;
    opcion: string;
begin
    Reset(archivoBancos);

    WriteLn('Listado de entidades bancarias: ');
    WriteLn;
    while not eof(archivoBancos) do
    begin
        read(archivoBancos, nuevoBanco);
        writeln('Nombre: ', nuevoBanco.nombre);
        writeln('Codigo: ',  nuevoBanco.cod_ban);
        writeln;
    end;
    
    repeat
        WriteLn('Desea ingresar un nuevo banco? (si / no)');
        ReadLn(opcion);
        if ((opcion = 'si') OR (opcion = 'SI') OR (opcion = 'Si')) then 
            begin
                WriteLn('Ingrese el nombre del banco');
                ReadLn(nuevoBanco.nombre);
                WriteLn('Ingrese el codigo del banco');
                ReadLn(nuevoBanco.cod_ban);
                Write(archivoBancos, nuevoBanco);
            end;
    until (opcion = 'no') OR (opcion = 'NO') OR (opcion = 'No');
    
    close(archivoBancos);
end;

procedure OpcionABM;
var
    nuevoComercio: Comercio;
    opcion, posFinal, codigoComercio: integer;
begin
    ClrScr;
    WriteLn('   ABM de comercios adheridos.');
    WriteLn;
    Reset(archivoComercios);
    while not eof(archivoComercios) do
    begin
        read(archivoComercios, nuevoComercio);
        writeln('Nombre: ', nuevoComercio.nombre);
        writeln('CUIT: ',  nuevoComercio.cuit);
        writeln('Estado: ',  nuevoComercio.estado);
        writeln('Codigo: ',  nuevoComercio.cod_com);
        writeln;
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

            assign(archivoComercios, RUTA_ARCHIVOS + 'comercios.dat');
            reset(archivoComercios);    

            posFinal := FileSize(archivoComercios);{el primer elemento esta en la pos 0, por lo que en la pos FileSize no hay ningun elemento}
            Seek(archivoComercios, posFinal); {muevo el puntero a la posicion final}

            WriteLn('Ingrese el nombre del comercio');
            ReadLn(nuevoComercio.nombre);
            WriteLn('Ingrese el CUIT del comercio');
            ReadLn(nuevoComercio.cuit);
            nuevoComercio.cod_com := posFinal;
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

            assign(archivoComercios, RUTA_ARCHIVOS + 'comercios.dat');
            reset(archivoComercios);

            WriteLn('Ingrese el codigo del comercio a dar de baja');
            ReadLn(codigoComercio);

            if codigoComercio < FileSize(archivoComercios)then
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
            WriteLn('   Modificar Comercio.');
            WriteLn;

            assign(archivoComercios, RUTA_ARCHIVOS + 'comercios.dat');
            reset(archivoComercios);

            WriteLn('Ingrese el codigo del comercio a modificar');
            ReadLn(codigoComercio);

            if codigoComercio < FileSize(archivoComercios)then
            begin
                Seek(archivoComercios, codigoComercio);{al estar ordenado, el codigo coincide con el puntero.}
                Read(archivoComercios, nuevoComercio);{leo el comercio a dar de baja}

                repeat
                    writeln('Datos del Comercio');
                    writeln('Nombre: ', nuevoComercio.nombre);
                    writeln('CUIT: ',  nuevoComercio.cuit);
                    writeln('Estado: ',  nuevoComercio.estado);
                    writeln('Codigo: ',  nuevoComercio.cod_com);
                    writeln;
                    WriteLn('1) Modificar Nombre.');
                    WriteLn('2) Modificar CUIT.');
                    WriteLn('3) Modificar Estado.');
                    WriteLn('4) Volver al menu principal.');
                    WriteLn;
                    repeat
                        Write('Seleccione ingresando una de las opciones: ');
                        ReadLn(opcion);
                    until (opcion >= 1) AND (opcion <= 4);

                    case opcion of
                        1: begin
                            WriteLn('Ingrese el nombre del comercio');
                            ReadLn(nuevoComercio.nombre);
                            ClrScr;
                            WriteLn('El nombre se ha modificado satisfactoriamente.');
                            WriteLn;
                        end;
                        2: begin
                            WriteLn('Ingrese el CUIT del comercio');
                            ReadLn(nuevoComercio.cuit);
                            ClrScr;
                            WriteLn('El CUIT se ha modificado satisfactoriamente.');
                            WriteLn;
                        end;
                        3: begin
                            nuevoComercio.estado := not(nuevoComercio.estado);
                            ClrScr;
                            WriteLn('El estado cambio de ', not(nuevoComercio.estado), ' a ', nuevoComercio.estado);
                            WriteLn;
                        end;
                    end;
                until opcion = 4;
                Seek(archivoComercios, codigoComercio);{vuelvo a la posicion, ya que el read aumenta el puntero}
                Write(archivoComercios, nuevoComercio);{sobreescribo el comercio modificado en la misma posicion que estaba.}
            end
            else 
            begin
                WriteLn('El comercio no esta adherido.');
                ReadKey;
            end;

            close(archivoComercios);
            OpcionABM;
        end;
    end;
end;

procedure Borrar(var cadena: string);
begin
    if (Length(cadena) > 0) then            (* verifica que haya al menos un caracter para borrar *)
    begin
        Delete(cadena, Length(cadena), 1);    (* actualiza cadena borrando un caracter en su ultima posicion *)
        GotoXY(WhereX - 1, WhereY);           (* mueve el cursor una posicion a la izq *)
        Write(' ');                           (* escribe un espacio en blanco para invisibilizar el lugar *)
        GotoXY(WhereX - 1, WhereY);           (* vuelve a mover el cursor una posicion a la izq *)
    end;
end;

function IngresarContrasena(claveReal: integer): boolean;
var
    intentos: integer;
    caracter: char;
    clave: string;
    claveInt: integer;
begin
    intentos := 3;
    Write('Contrasena (numerica, hasta 9 digitos): ');
    repeat
    if intentos < 3 then
    begin
        GotoXY(1, WhereY - 1);
        ClrEol();
        Write('Contrasena incorrecta (', intentos, ' intentos restantes): ');
    end;
    clave := '';
    repeat
        caracter := ReadKey;
        while (KeyPressed) do ReadKey;              (* si queda algo en buffer, se captura por si es un caracter de control *)
        if (Ord(caracter) = 8) then Borrar(clave);  (* borra si la tecla ingresada es BS (backspace) *)
        if (Ord(caracter) >= 32) then               (* igualmente verifica que el caracter ingresado no sea de control *)
        begin
            clave := clave + caracter;
            Write('*');
        end;
    until ((clave[1] <> '-') AND (Length(clave) >= 9)) OR (Length(clave) >= 10) OR (Ord(caracter) = 10) OR (Ord(caracter) = 13);
    (* #10 es LF y #13 es CR en ASCII (tecla Enter en Windows equivale a CR LF) *)
    WriteLn();
        intentos := intentos - 1;
        claveInt := StrToIntDef(clave, 0);    (* convierte la clave ingresada a integer, y si no respeta formato de numero vale 0 *)
    until (claveInt = claveReal) OR (intentos < 1);
    WriteLn();
    if claveInt = claveReal then
    begin
        IngresarContrasena := True;
        WriteLn('La contrasena es correcta.');
    end
    else
    begin
        IngresarContrasena := False;
        WriteLn('La contrasena es incorrecta. Ya no quedan mas intentos.');
    end;
end;

procedure altaUsuario(dni: string[8]);
var
    newUsuario: usuario;
begin
    Reset(archivoUsuarios);
    Seek(archivoUsuarios, FileSize(archivoUsuarios));  //posiciono el puntero al final del archivo
    newUsuario.dni := dni;
    Write('Contrasena (numerica y hasta 9 digitos): ');
    ReadLn(newUsuario.contrasena);
    Write('Apellido y nombre: ');
    ReadLn(newUsuario.ape_nom);
    Write('Mail: ');
    ReadLn(newUsuario.mail);
    Write(archivoUsuarios, newUsuario); //agrego el nuevo usuario al archivo
end;

function buscarBancoPorCodigo(codigo: integer): integer;
var
    unBanco: Banco;
begin
    Reset(archivoBancos);
    Read(archivoBancos, unBanco);
    while (unBanco.cod_ban <> codigo) AND (NOT (Eof(archivoBancos))) do  //mientras el codigo que busco sea distinto del que esta en el archivo
        Read(archivoBancos, unBanco);                                    // y no sea el final del mismo, sigo buscando
    if unBanco.cod_ban = codigo then
        buscarBancoPorCodigo := FilePos(archivoBancos) - 1          //si la cuenta existe devuelvo la posicion en el archivo
    else
        buscarBancoPorCodigo := -1;          //si no existe devuelvo -1 para luego darla de alta
end;

function buscarBancoPorCodigoEnCuenta(codigo: integer; cuenta: cuentaVirtual): integer;
var
    unBanco: Banco;
    i: integer;
begin
    Reset(archivoBancos);
    Read(archivoBancos, unBanco);
    while (unBanco.cod_ban <> codigo) AND (NOT (Eof(archivoBancos))) do  //mientras el codigo que busco sea distinto del que esta en el archivo
        Read(archivoBancos, unBanco);                                    // y no sea el final del mismo, sigo buscando
    buscarBancoPorCodigoEnCuenta := -1;                   //si no existe devuelvo -1 por defecto
    if unBanco.cod_ban = codigo then
        for i := 1 to High(cuenta.cuenta_virtual) do           // filtro por cuenta
            if (codigo = cuenta.cuenta_virtual[i].cod_ban) then
                buscarBancoPorCodigoEnCuenta := FilePos(archivoBancos) - 1;   //si el banco existe devuelvo la posicion en el archivo
end;

function buscarCuentaPorDni(dni: string[8]): integer;
var
    unaCuenta: CuentaVirtual;
begin
    Reset(archivoCuentas);
    read(archivoCuentas, unaCuenta);
    while (unaCuenta.dni <> dni) AND (not(eof(archivoCuentas))) do  //mientras el dni que busco sea distinto del que esta en el archivo
    begin                                                    // y no sea el final del mismo, sigo buscando
        read(archivoCuentas, unaCuenta);              //busco la cuenta por el campo de dni
    end;
    if unaCuenta.dni = dni then
    begin
        buscarCuentaPorDni := filepos(archivoCuentas) - 1;          //si la cuenta existe devuelvo la posicion en el archivo
    end
    else
    begin
        buscarCuentaPorDni := -1;          //si no existe devuelvo -1 para luego darla de alta
    end;
end;

function buscarUsuarioPorDni(dni: string[8]): integer;
var
    unUser: usuario;
begin
    Reset(archivoUsuarios);
    Read(archivoUsuarios, unUser);
    while (unUser.dni <> dni) AND (not(eof(archivoUsuarios))) do  //mientras el dni que busco sea distinto del que esta en el archivo
    begin                                                         // y no sea el final del mismo, sigo buscando
        read(archivoUsuarios, unUser);              //busco el usuario por el campo de dni
    end;
    if unUser.dni = dni then
    begin
        buscarUsuarioPorDni:=filepos(archivoUsuarios)-1;          //si el usuario existe devuelvo la posicion en el archivo
    end
    else
    begin
        buscarUsuarioPorDni:=-1;          //si no existe devuelvo -1 para luego darlo de alta
    end;
end;

procedure IniciarSesion;
var
    dni: string[8];
    unUsuario: usuario;
begin
    WriteLn('    INICIAR SESION / REGISTRARSE');
    WriteLn();
    WriteLn();
    WriteLn('Ingrese sus datos para iniciar sesion:');
    WriteLn();
    Write('DNI: ');
    ReadLn(dni);
    usuarioIniciado := buscarUsuarioPorDni(dni);
    if usuarioIniciado = -1 then
    begin
        WriteLn('El DNI ingresado no esta registrado como usuario.');
        WriteLn('Complete los siguientes campos para darse de alta:');
        altaUsuario(dni);
        usuarioIniciado := FilePos(archivoUsuarios) - 1; // se identifica al usuario mediante la posicion en el archivo
    end
    else
    begin                                    //si existe el dni en el archivo
        Seek(archivoUsuarios, usuarioIniciado);
        Read(archivoUsuarios, unUsuario);
        if (NOT IngresarContrasena(unUsuario.contrasena)) then     //pide contrase?a y corrobora que sea la misma
            usuarioIniciado := -1;   //si pone la contrase?a mal, el inicio de sesion fallara
    end;
end;

function MostrarTarjetasDeCuentaDeUsuario(cuenta: CuentaVirtual): boolean;
var
    cantidadTarjetas, i: integer;
begin
    cantidadTarjetas := 0;
    for i := 1 to High(cuenta.cuenta_virtual) do
        if buscarBancoPorCodigo(cuenta.cuenta_virtual[i].cod_ban) <> -1 then
        begin
            cantidadTarjetas += 1;
            WriteLn('  -----------------------');
            WriteLn('  TARJETA Nro. ', i);
            WriteLn('    Codigo de banco: ', cuenta.cuenta_virtual[i].cod_ban);
            WriteLn('    Tipo de tarjeta: ', cuenta.cuenta_virtual[i].tipo_tar);
            WriteLn('    Saldo: $ ', cuenta.cuenta_virtual[i].saldo_x_tarjeta:12:2);
        end;
    MostrarTarjetasDeCuentaDeUsuario := cantidadTarjetas > 0;
    if MostrarTarjetasDeCuentaDeUsuario then
        WriteLn('  -----------------------')
    else
        WriteLn('  Este usuario tiene cuenta asociada, pero no tiene tarjetas en ella!');
end;

procedure AgregarTarjetasACuenta(var cuenta: CuentaVirtual);
var
    nuevaTarjeta: tarjeta;
    i: integer;
begin
    if High(cuenta.cuenta_virtual) < 1 then
        WriteLn('  Lo sentimos, no se permiten agregar tarjetas en este momento.')
    else
    begin
        WriteLn('  Puede tener hasta ', High(cuenta.cuenta_virtual), ' tarjetas en su nueva cuenta.');
        WriteLn('  Llene los datos correspondientes. Finalice con "0" como Codigo de banco.');
        WriteLn('  Si no agrega ninguna tarjeta ahora, puede hacerlo mas adelante.');
        nuevaTarjeta.cod_ban := 1; {inicializo la variable de codigo de banco}
        for i := 1 to High(cuenta.cuenta_virtual) do
        begin
            if (nuevaTarjeta.cod_ban = 0) then
            begin
                nuevaTarjeta.tipo_tar := '-';
                nuevaTarjeta.saldo_x_tarjeta := 0;
            end
            else
            begin
                WriteLn('   -----------------------');
                WriteLn('   TARJETA Nro. ', i);
                WriteLn();
                repeat
                    GotoXY(1, WhereY - 1);
                    ClrEol();
                    Write('     Codigo de banco (debe estar registrado): ');
                    ReadLn(nuevaTarjeta.cod_ban);
                until (nuevaTarjeta.cod_ban = 0) OR (buscarBancoPorCodigo(nuevaTarjeta.cod_ban) <> -1);
            end;
            if (nuevaTarjeta.cod_ban <> 0) then
            begin
                WriteLn();
                repeat
                    GotoXY(1, WhereY - 1);
                    ClrEol();
                    Write('     Debito o Credito? (D / C): ');
                    ReadLn(nuevaTarjeta.tipo_tar);
                until (nuevaTarjeta.tipo_tar = 'D') OR (nuevaTarjeta.tipo_tar = 'C');
                Write('     Saldo de tarjeta: $ ');
                ReadLn(nuevaTarjeta.saldo_x_tarjeta);
            end;
            cuenta.cuenta_virtual[i] := nuevaTarjeta;
        end;
        WriteLn('   -----------------------');
    end;
end;

procedure Cuentas(usuarioDni: string[8]);
var
    confirmacion: string;
    registroCuenta: integer;
    sesionCuentaUsuario, nuevaCuenta: CuentaVirtual;
begin
    Reset(archivoCuentas);
    WriteLn();
    registroCuenta := buscarCuentaPorDni(usuarioDni);
    if registroCuenta = -1 then
    begin
        WriteLn('Actualmente este usuario no tiene una cuenta asociada.');
        WriteLn;
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol;
            Write('Desea crearla? (si / no): ');
            ReadLn(confirmacion);
        until (confirmacion = 'no') OR (confirmacion = 'NO') OR (confirmacion = 'No') OR(confirmacion = 'si') OR (confirmacion = 'SI') OR (confirmacion = 'Si');
        if (confirmacion = 'si') OR (confirmacion = 'SI') OR (confirmacion = 'Si') then
        begin
            nuevaCuenta.dni := usuarioDni;
            WriteLn();
            WriteLn('Ingrese todos los datos para su nueva cuenta.');
            Write('  Saldo de billetera (efectivo): $ ');
            ReadLn(nuevaCuenta.saldo_billetera);
            WriteLn();
            AgregarTarjetasACuenta(nuevaCuenta);
            Seek(archivoCuentas, FileSize(archivoCuentas));
            Write(archivoCuentas, nuevaCuenta);
            WriteLn();
            WriteLn('Cuenta creada exitosamente!');
        end;
    end
    else
    begin
        Seek(archivoCuentas, registroCuenta);
        Read(archivoCuentas, sesionCuentaUsuario);
        WriteLn('Saldo billetera (efectivo): $ ', sesionCuentaUsuario.saldo_billetera:1:2);
        WriteLn;
        if NOT MostrarTarjetasDeCuentaDeUsuario(sesionCuentaUsuario) then
        begin
            WriteLn;
            repeat
                GotoXY(1, WhereY - 1);
                ClrEol;
                Write('  Desea agregar sus tarjetas ahora? (si / no): ');
                ReadLn(confirmacion);
            until (confirmacion = 'no') OR (confirmacion = 'NO') OR (confirmacion = 'No') OR(confirmacion = 'si') OR (confirmacion = 'SI') OR (confirmacion = 'Si');
            if (confirmacion = 'si') OR (confirmacion = 'SI') OR (confirmacion = 'Si') then
            begin
                WriteLn;
                AgregarTarjetasACuenta(sesionCuentaUsuario);
                Seek(archivoCuentas, registroCuenta);
                Write(archivoCuentas, sesionCuentaUsuario);
            end;
        end;
    end;
    WriteLn();
    WriteLn();
    Write('Presione cualquier tecla para volver al menu de Sistema de Usuario...');
end;

procedure Envios(dni:string[8]);
var
    monto:real;
    dniRecibe: string[8];
    cuentaEnvia, cuentaRecibe: cuentaVirtual;
    posReceptor, posEmisor: integer;
    unMovimiento: movimiento;
begin
    Reset(archivoCuentas);
    Reset(archivoMovimientos);
    posEmisor:= buscarCuentaPorDni(dni);
    WriteLn;
    if(posEmisor= -1) then
    begin
         writeln('Usted no posee una cuenta asociada.');
         WriteLn('Dirijase a Cuentas (opcion 2) para crear una.');
    end
    else
    begin
        Seek(archivoCuentas, posEmisor);  //pongo el puntero en el usuario que tiene sesion iniciada
        read(archivoCuentas, cuentaEnvia);   //accedo al registro del usuario ingresado
        writeln('Ingrese el DNI del usuario al cual quiere enviar dinero:');
        ReadLn(dniRecibe);
        WriteLn();
        posReceptor:=buscarCuentaPorDni(dniRecibe);
        DeCodeDate (Date,unMovimiento.ano,unMovimiento.mes,unMovimiento.dia);
        if (dni <> dniRecibe) AND (posReceptor<>-1) AND (cuentaEnvia.saldo_billetera <> 0.0) then
        begin
            writeln('Fecha: ', unMovimiento.dia, '/', unMovimiento.mes, '/',unMovimiento.ano);
            writeln();
            writeln('El saldo de su billetera virtual es: $ ', cuentaEnvia.saldo_billetera:1:2);
            writeln();
            WriteLn();
            repeat
                GotoXY(1, WhereY - 1);
                ClrEol();
                write('Ingrese el monto a enviar (menor o igual a su saldo): $ ');
                readln(monto);
            until (monto<=cuentaEnvia.saldo_billetera);
            
            seek(archivoMovimientos, filesize(archivoMovimientos));  //me posiciono al final del archivo ya que este esta ordenado de forma ascendente, osea la fecha mas reciente ira al final del mismo
            seek(archivoCuentas, posReceptor);    //me posiciono en el registro del que va a recibir dinero
            read(archivoCuentas, cuentaRecibe);   //accedo al registro de la cuenta del receptor del dinero

            unMovimiento.dni:=cuentaEnvia.dni;
            unMovimiento.cod_ban:=-1;
            unMovimiento.tipo_tar:='N';
            unMovimiento.tipo_movi:='E';
            unMovimiento.importe:=monto;
            unMovimiento.cod_com:=-1;
            unMovimiento.dni_otro_usuario:= cuentaRecibe.dni;
            write(archivoMovimientos, unMovimiento);  //guardo el movimiento en el archivo movimientos.dat

            cuentaRecibe.saldo_billetera:= (cuentaRecibe.saldo_billetera) + monto;  //le agrego el dinero al receptor el dinero que se le envio
            seek(archivoCuentas, posReceptor);
            write(archivoCuentas, cuentaRecibe);    //guardo el registro del usuario que recibe dinero con su nuevo saldo

            seek(archivoCuentas, posEmisor);
            cuentaEnvia.saldo_billetera:=cuentaEnvia.saldo_billetera - monto;   //le resto el dinero que se envio
            write(archivoCuentas, cuentaEnvia);         //guardo el registro del usuario que envio dinero con su saldo actualizado

            WriteLn();
            WriteLn('El envio de dinero se realizo exitosamente!');
        end
        else
        begin
            if dni = dniRecibe then
                Write('No puede enviarse dinero a si mismo!')
            else if cuentaEnvia.saldo_billetera = 0.0 then
                Write('No tiene saldo en su cuenta, regresando al menu anterior.')
            else
                Write('El DNI ingresado no corresponde a ningun otro usuario con cuenta virtual. Vuelva a intentarlo');
        end;
    end;
    WriteLn();
    WriteLn();
    Write('Presione cualquier tecla para volver al menu de Sistema de Usuario...');
end;

procedure Compras(usuarioDni: string[8]);
var
    nuevoMovimiento: movimiento;
    unComercio: comercio;
    registroCuenta, registroBanco, i, posicionTarjeta: integer;
    sesionCuentaUsuario: cuentaVirtual;
    unBanco: banco;
    unaTarjeta: tarjeta;
begin
    Reset(archivoComercios);
    nuevoMovimiento.dni := usuarioDni;
    nuevoMovimiento.tipo_movi := 'C';
    WriteLn();
    WriteLn('Registre ahora una nueva compra.');
    WriteLn();
    DecodeDate(Date, nuevoMovimiento.ano, nuevoMovimiento.mes, nuevoMovimiento.dia);
    WriteLn('Fecha: ', nuevoMovimiento.dia, '/', nuevoMovimiento.mes, '/', nuevoMovimiento.ano);
    WriteLn();
    WriteLn('Complete los datos que se le piden. Ingrese "', FileSize(archivoComercios), '" como codigo de comercio para cancelar.');
    WriteLn();
    Write('  Codigo de comercio donde compra: ');
    ReadLn(nuevoMovimiento.cod_com);
    if nuevoMovimiento.cod_com <> FileSize(archivoComercios) then {si el codigo ingresado es el tamano del archivo comercios, se utiliza como fin pues seguro no existe el comercio}
    begin
        if nuevoMovimiento.cod_com < FileSize(archivoComercios) then {si el codigo de comercio no existe, termina}
        begin
            Seek(archivoComercios, nuevoMovimiento.cod_com);    {muevo el puntero a la posicion del comercio}
            Read(archivoComercios, unComercio);     {leo el comercio}
            if unComercio.estado then   {si el comercio esta disponible, continua}
            begin
                WriteLn('  Nombre del comercio: ', unComercio.nombre);
                WriteLn();
                registroCuenta := buscarCuentaPorDni(usuarioDni);    {si existe cuenta de usuario devuelve la posicion en el archivo, sino -1}
                if registroCuenta = -1 then
                begin
                    WriteLn('  Este usuario no tiene cuenta! No puede realizar ninguna compra!');
                    WriteLn('  Dirijase a Cuentas (opcion 2) para crear una.');
                end
                else
                begin
                    Seek(archivoCuentas, registroCuenta); {muevo el puntero a la posicion de la cuenta virtual del usuario}
                    Read(archivoCuentas, sesionCuentaUsuario); {escribo el contenido del archivo en sesionCuentaUsuario}
                    WriteLn('  Tarjetas disponibles:');
                    if MostrarTarjetasDeCuentaDeUsuario(sesionCuentaUsuario) then
                    begin
                        WriteLn();
                        Write('  Codigo del banco con quien compra: ');
                        ReadLn(nuevoMovimiento.cod_ban);
                        registroBanco := buscarBancoPorCodigoEnCuenta(nuevoMovimiento.cod_ban, sesionCuentaUsuario); {devuelve -1 si el banco no esta en ninguna tarjeta de la cuenta}
                        if registroBanco = -1 then
                            WriteLn('  Banco no existente en su cuenta! Revise arriba cuales tiene disponibles')
                        else
                        begin
                            Seek(archivoBancos, registroBanco);
                            Read(archivoBancos, unBanco);
                            WriteLn('  Nombre del banco: ', unBanco.nombre);
                            WriteLn();
                            WriteLn();
                            repeat
                                GotoXY(1, WhereY - 1);
                                ClrEol();
                                Write('  Tipo de tarjeta (D / C): ');
                                ReadLn(nuevoMovimiento.tipo_tar);
                            until (nuevoMovimiento.tipo_tar = 'D') OR (nuevoMovimiento.tipo_tar = 'C');
                            posicionTarjeta := 0;
                            for i := 1 to High(sesionCuentaUsuario.cuenta_virtual) do
                                if (posicionTarjeta = 0) AND (sesionCuentaUsuario.cuenta_virtual[i].cod_ban = unBanco.cod_ban) AND (sesionCuentaUsuario.cuenta_virtual[i].tipo_tar = nuevoMovimiento.tipo_tar) then
                                    posicionTarjeta := i;
                            if posicionTarjeta <> 0 then
                            begin
                                unaTarjeta := sesionCuentaUsuario.cuenta_virtual[posicionTarjeta];
                                WriteLn('  Saldo de la tarjeta: $ ', unaTarjeta.saldo_x_tarjeta:1:2);
                                WriteLn();
                                WriteLn();
                                repeat
                                    GotoXY(1, WhereY - 1);
                                    ClrEol();
                                    Write('  Monto a abonar (pagable): $ ');
                                    ReadLn(nuevoMovimiento.importe);
                                until nuevoMovimiento.importe <= unaTarjeta.saldo_x_tarjeta;
                                unaTarjeta.saldo_x_tarjeta := unaTarjeta.saldo_x_tarjeta - nuevoMovimiento.importe; {resto el monto ingresado a la variable unaTarjeta}
                                sesionCuentaUsuario.cuenta_virtual[posicionTarjeta] := unaTarjeta;   {guardo el nuevo monto en la variable de tipo CuentaVirtual}

                                Seek(archivoCuentas, registroCuenta);
                                Write(archivoCuentas, sesionCuentaUsuario); {actualizo el archivo cuentas con el nuevo monto de tarjeta}
                                
                                Seek(archivoMovimientos, filesize(archivoMovimientos));  //me posiciono al final del archivo ya que este esta ordenado de forma ascendente, osea la fecha mas reciente ira al final del mismo
                                Write(archivoMovimientos, nuevoMovimiento);  {actualizo el archivo movimientos con el nuevo registro}

                                WriteLn();
                                WriteLn('  Se ha registrado la compra con exito!');
                                Write('Pulse cualquier tecla para mostrar el comprobante de pago...');
                                ReadKey;
                                ClrScr;
                                WriteLn('   COMPROBANTE DE PAGO');
                                WriteLn('  --------------------------');
                                WriteLn('   Banco: ', unBanco.nombre);
                                WriteLn('   Comercio: ', unComercio.nombre);
                                WriteLn('   Fecha operacion: ', nuevoMovimiento.dia, '/', nuevoMovimiento.mes, '/', nuevoMovimiento.ano);
                                Write('   Monto a ');
                                if nuevoMovimiento.tipo_tar = 'D' then
                                    Write('debitar')
                                else
                                    Write('abonar');
                                WriteLn(': ', nuevoMovimiento.importe:1:2);
                                WriteLn('  --------------------------');
                            end
                            else
                                WriteLn('  No tienes una tarjeta de tipo "' + nuevoMovimiento.tipo_tar + '" con el banco "' + unBanco.nombre + '"!');
                        end;
                    end;
                end;
            end
            else
                WriteLn('  Comercio no adherido: esta dado de baja!');
        end
        else
            WriteLn('  Comercio no adherido: no existe en los registros!');
    end;
    WriteLn();
    WriteLn();
    Write('Presione cualquier tecla para volver al menu de Sistema de Usuario...');
end;

function primerMovEnRangoFecha(dateI, dateF: TDateTime):integer;
var
    unMovimiento: movimiento;
    fechaMov: TDateTime;
begin
    reset(archivoMovimientos);
    read(archivoMovimientos, unMovimiento);
    fechaMov:=EncodeDate(unMovimiento.ano, unMovimiento.mes, unMovimiento.dia);
    while (fechaMov<dateI) AND (not(eof(archivoMovimientos))) do    //mientras que el archivo no este vacio y sea menor a DateI
    begin
        read(archivoMovimientos, unMovimiento);
        fechaMov:=EncodeDate(unMovimiento.ano, unMovimiento.mes, unMovimiento.dia);
    end;
    if (fechaMov >= dateI) AND (fechaMov <= dateF) then
        primerMovEnRangoFecha:= (filepos(archivoMovimientos) -1) //devuelve la posicion en la que se encuentra la primer fecha
    else
        primerMovEnRangoFecha:=-1;
end;

procedure ListarMovimientos(dni: string[8]; dateI, dateF: TDateTime);
var
    unMovimiento:movimiento;
    primerPos:integer;
    fechaMov: TDateTime;
    hayMovimiento: Boolean;
begin
    reset(archivoMovimientos);
    primerPos:=primerMovEnRangoFecha(dateI, dateF);  //busco la posicion del primer movimiento cuya fecha es mayor a la inicial

    if primerPos<>-1 then           //si existe entonces empiezo a mostrar
    begin
        Write(format('Entre %s', [DateToStr(dateI)]), format(' y %s',[DateToStr(dateF)]), ' los movimientos del usuario DNI ');
        TextBackground(Blue);
        TextColor(White);
        Write(dni);
        NormVideo;
        WriteLn(' son:');
        seek(archivoMovimientos, primerPos);    //posicion del primer movimiento cuya fecha es mayor a la inicial

        hayMovimiento := False; //si se mantiene false es porque no hubo movimientos del usuario
        repeat
            read(archivoMovimientos, unMovimiento);
            fechaMov:=EncodeDate(unMovimiento.ano, unMovimiento.mes, unMovimiento.dia);    //paso a formato fecha la fecha del movimiento

            if(unMovimiento.dni = dni) then                     //si el movimiento es del usuario que lo solicita
            begin
                writeln();
                writeln('-----------------------------------------------------------------');
                writeln(format('Fecha del Movimiento: %s', [DateToStr(fechaMov)]) );
                if(unMovimiento.tipo_movi='E') then             //muestro distintos campos dependiendo de el tipo de movimiento
                begin
                    writeln('Tipo de movimiento: Envio');
                    writeln('DNI del usuario que recibio dinero: ', unMovimiento.dni_otro_usuario);
                end
                else
                begin
                    writeln('Tipo de movimiento: Compra');
                    writeln('Codigo de Banco: ', unMovimiento.cod_ban);
                    writeln('Tipo de Tarjeta: ', unMovimiento.tipo_tar);
                    writeln('Codigo de Comercio: ', unMovimiento.cod_com);
                end;
                writeln('Importe: ', unMovimiento.importe:1:2);
                hayMovimiento := True;
            end;

        until (fechaMov<dateI) OR (fechaMov>dateF) OR (eof(archivoMovimientos));   //hasta que este fuera de las fechas o termine el archivo
        if not(hayMovimiento) then 
            writeln(format('Su cuenta no tiene ningun movimiento registrado entre %s', [DateToStr(dateI)]), format(' y %s',[DateToStr(dateF)]) )
        else
            writeln('-----------------------------------------------------------------');
    end
    else
    begin
        Write(format('No hay ningun movimiento registrado entre %s', [DateToStr(dateI)]), format(' y %s',[DateToStr(dateF)]), ' del usuario DNI ');
        TextBackground(Blue);
        TextColor(White);
        Write(dni);
        NormVideo;
        WriteLn('.');
    end;
    WriteLn();
    WriteLn();
    Write('Presione cualquier tecla para volver al menu de Sistema de Usuario...');
end;

function diasMes(mes: word): integer;
const
     tienen31: array [1..7] of word = (1,3,5,7,8,10,12);
var
    i: integer;
begin
    diasMes := 28;
    for i := 1 to 7 do
        if mes = tienen31[i] then
            diasMes := 31
        else if mes <> 2 then
            diasMes := 30;
end;

procedure Movimientos(dni: string[8]);
var
    diaInicio, mesInicio, anoInicio, diaFin, mesFin, anoFin, diaHoy, mesHoy, anoHoy, diaLimite, mesLimite, diaMinimo, mesMinimo: word;
    dateI, dateF: TDateTime;
    i: integer;
begin
    DecodeDate(Date, anoHoy, mesHoy, diaHoy);
    WriteLn();
    WriteLn();
    WriteLn('Consulte los movimientos realizados entre 2 fechas.');
    WriteLn();
    Write('Tenga en cuenta que hoy es: ');
    TextBackground(Green);
    TextColor(White);
    WriteLn(Format('%s', [DateToStr(Date)]));
    NormVideo;
    WriteLn();
    WriteLn(); WriteLn(); WriteLn(); WriteLn();
    repeat
        for i := 1 to 4 do
        begin
            GotoXY(1, WhereY - 1);
            ClrEol;
        end;
        WriteLn('Ingrese Fecha Inicial (anterior o igual a hoy):');
        WriteLn();
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol();
            Write('  Ano (maximo ', anoHoy, '): ');
            ReadLn(anoInicio);
        until anoInicio <= anoHoy;
        WriteLn();
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol();
            if anoInicio < anoHoy then
                mesLimite := 12
            else
                mesLimite := mesHoy;
            Write('  Mes (1 a ', mesLimite, '): ');
            ReadLn(mesInicio);
        until (mesInicio >= 1) AND (mesInicio <= mesLimite);
        WriteLn();
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol();
            if (anoInicio < anoHoy) OR (mesInicio <> mesHoy) then
                diaLimite := diasMes(mesInicio)
            else
                diaLimite := diaHoy;
            Write('  Dia (1 a ', diaLimite, '): ');
            ReadLn(diaInicio);
        until (diaInicio >= 1) AND (diaInicio <= diaLimite);
        dateI := EncodeDate(anoInicio, mesInicio, diaInicio);
    until (dateI <= Date());

    WriteLn();
    WriteLn(); WriteLn(); WriteLn(); WriteLn();
    repeat
        for i := 1 to 4 do
        begin
            GotoXY(1, WhereY - 1);
            ClrEol;
        end;
        WriteLn('Ingrese Fecha Final (entre ', Format('%s', [DateToStr(dateI)]), ' y hoy):');
        WriteLn();
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol();
            Write('  Ano (entre ', anoInicio, ' y ', anoHoy, '): ');
            ReadLn(anoFin);
        until (anoFin >= anoInicio) AND (anoFin <= anoHoy);
        WriteLn();
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol();
            if anoFin < anoHoy then
                mesLimite := 12
            else
                mesLimite := mesHoy;
            if anoFin > anoInicio then
                mesMinimo := 1
            else
                mesMinimo := mesInicio;
            Write('  Mes (', mesMinimo, ' a ', mesLimite, '): ');
            ReadLn(mesFin);
        until (mesFin >= mesMinimo) AND (mesFin <= mesLimite);
        WriteLn();
        repeat
            GotoXY(1, WhereY - 1);
            ClrEol();
            if (anoFin < anoHoy) OR (mesFin <> mesHoy) then
                diaLimite := diasMes(mesFin)
            else
                diaLimite := diaHoy;
            if (anoFin > anoInicio) OR (mesFin <> mesInicio) then
                diaMinimo := 1
            else
                diaMinimo := diaInicio;
            Write('  Dia (', diaMinimo, ' a ', diaLimite, '): ');
            ReadLn(diaFin);
        until (diaFin >= diaMinimo) AND (diaFin <= diaLimite);
        dateF := EncodeDate(anoFin, mesFin, diaFin);
    until ((dateF <= Date()) AND (dateF>=dateI) );
    WriteLn();
    Write('Presione cualquier tecla para mostrar los movimientos en la fecha especificada...');
    readKey;
    ClrScr;
    WriteLn('         MOVIMIENTOS');
    WriteLn();
    WriteLn();
    ListarMovimientos(dni, dateI, dateF);

end;

procedure OpcionUsuarios;
var
    opcion: integer;
    sesionUsuario: Usuario;
begin
    Reset(archivoUsuarios);
    Reset(archivoCuentas);
    Reset(archivoMovimientos);
    Reset(archivoComercios);
    opcion := 0;
    if (usuarioIniciado = -1) then
    begin
        ClrScr;
        WriteLn('          Sistema de Usuario');
        WriteLn();
        WriteLn();
        IniciarSesion;
    end;
    if (usuarioIniciado <> -1) then
    begin
        repeat
            Seek(archivoUsuarios, usuarioIniciado);
            Read(archivoUsuarios, sesionUsuario);
            ClrScr;
            WriteLn('          Sistema de Usuario');
            if (opcion <> 1) then
            begin
                Write('Sesion iniciada como ');
                TextBackground(Blue);
                TextColor(White);
                Write(sesionUsuario.ape_nom);
                NormVideo;
                WriteLn('.');
            end;
            WriteLn();
            WriteLn();
            case opcion of
                0: begin
                    WriteLn('1) Inicio sesion');
                    WriteLn('2) Cuentas');
                    WriteLn('3) Envios de dinero');
                    WriteLn('4) Compras en comercios');
                    WriteLn('5) Movimientos');
                    WriteLn('6) Volver al menu principal.');
                    WriteLn;
                    repeat
                        Write('Seleccione ingresando una de las opciones: ');
                        ReadLn(opcion);
                    until (opcion >= 1) AND (opcion <= 6);
                end;
                1: begin
                    IniciarSesion;
                    opcion := 0;
                end;
                2: begin
                    WriteLn('         CUENTAS');
                    Cuentas(sesionUsuario.dni);
                    opcion := 0;
                    ReadKey;
                end;
                3: begin
                    WriteLn('         ENVIOS DE DINERO');
                    Envios(sesionUsuario.dni);
                    opcion := 0;
                    ReadKey;
                end;
                4: begin
                    WriteLn('         COMPRAS EN COMERCIOS');
                    Compras(sesionUsuario.dni);
                    opcion := 0;
                    ReadKey;
                end;
                5: begin
                    WriteLn('         MOVIMIENTOS');
                    Movimientos(sesionUsuario.dni);

                    opcion := 0;
                    ReadKey;
                end;
            end;
        until (opcion = 6) OR (usuarioIniciado = -1);
    end
    else
    begin
        ClrScr;
        WriteLn('          Sistema de usuario');
        WriteLn('No se pudo iniciar sesion.');
        WriteLn();
        Write('Presione cualquier tecla para volver al menu principal...');
        ReadKey;
    end;
    Close(archivoUsuarios);
    Close(archivoCuentas);
    Close(archivoMovimientos);
    Close(archivoComercios);
end;

procedure Menu;
var
    opcion: integer;
begin
    ClrScr;
    Write('Bienvenido al sistema de ');
    TextBackground(Green);
    TextColor(White);
    WriteLn('Billetera Electronica o Virtual');
    NormVideo;
    WriteLn();
    WriteLn('         MENU');
    WriteLn;
    WriteLn('1) Bancos (listar y agregar bancos)');
    WriteLn('2) ABM de Comercios Adheridos');
    WriteLn('3) Usuarios');
    WriteLn('4) Fin');
    repeat
        Write('Seleccione ingresando una de las opciones: ');
        ReadLn(opcion);
    until (opcion >= 1) AND (opcion <= 4);
    ClrScr;
    case opcion of
        1: begin
            OpcionBancos;
            Menu;
        end;
        2: begin
            OpcionABM;
            Menu;
        end;
        3: begin
            OpcionUsuarios;
            Menu;
        end;
    end;
end;

procedure Inicializar;
begin                      
    usuarioIniciado := -1;
    Assign(archivoUsuarios, RUTA_ARCHIVOS + 'usuarios.dat');
    Assign(archivoCuentas, RUTA_ARCHIVOS + 'cuentas-virtuales.dat');
    Assign(archivoComercios, RUTA_ARCHIVOS + 'Comercios.dat');
    Assign(archivoBancos, RUTA_ARCHIVOS + 'Bancos.dat');
    Assign(archivoMovimientos, RUTA_ARCHIVOS + 'movimientos.dat');
end;

begin
    Inicializar;
    Menu;
    Write('Presione cualquier tecla para salir del programa');
    ReadKey;
end.
