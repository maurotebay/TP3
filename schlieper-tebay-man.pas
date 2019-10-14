
{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program tp3;
uses Crt, sysutils;

const
    RUTA_ARCHIVOS = 'C:\ayed\tp3\';

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

var
    // archivoUsuarios: file of usuario; { es global para poder usar el archivo a traves de distintas funciones }
    usuarioIniciado: integer; { es global para mantener la sesion iniciada y permitir un ingreso por primera vez }

{Esta opcion listara primero todas las entidades bancarias que ya estan cargadas en el sistema en bancos.dat, y permitira ingresar nuevos bancos. Por cada nuevo ingreso se debera registrar el codigo del banco y el nombre de la entidad.}
procedure OpcionBancos;
var
    archivoBancos: file of Banco;
    nuevoBanco: Banco;
    opcion: string;
begin
    assign(archivoBancos, RUTA_ARCHIVOS + 'bancos.dat');
    reset(archivoBancos);

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
    archivoComercios:file of Comercio;
    nuevoComercio: Comercio;
    opcion, posFinal, codigoComercio: integer;

begin
    ClrScr;
    WriteLn('   ABM de comercios adheridos.');
    WriteLn;

    {muestro contenido para testear funcionamientno.}
    assign(archivoComercios, RUTA_ARCHIVOS + 'comercios.dat');
    reset(archivoComercios); 
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
                WriteLn('El codigo de comercio no fue encontrado.');
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
  WriteLn('Ingrese la contrasena (solo valida entre -32768 a 32767):');
  repeat
    if intentos < 3 then
    begin
      ClrScr;
      WriteLn('Contrasena incorrecta. Ingrese nuevamente (', intentos, ' intentos restantes):');
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
    until ((Length(clave) >= 5) AND (clave[1] <> '-')) OR (Length(clave) >= 6) OR (Ord(caracter) = 10) OR (Ord(caracter) = 13);
    (* #10 es LF y #13 es CR en ASCII (tecla Enter en Windows equivale a CR LF) *)
    WriteLn();
    intentos := intentos - 1;
    claveInt := StrToIntDef(clave, 0);    (* convierte la clave ingresada a integer, y si no respeta formato de numero vale 0 *)
  until (claveInt = claveReal) OR (intentos < 1);
  WriteLn(); WriteLn();
  if claveInt = claveReal then
  begin
    IngresarContrasena := True;
    WriteLn('La clave es correcta.');
  end
  else
  begin
    IngresarContrasena := False;
    WriteLn('La clave es incorrecta. Ya no quedan mas intentos.');
  end;
end;

procedure altaUsuario(var archivo: file of Usuario; dni: string[8]);
var
    newUsuario: usuario;
begin
    Seek(archivo, FileSize(archivo));  //posiciono el puntero al final del archivo
    newUsuario.dni := dni;
    WriteLn('Contrasena (numero entre -32768 a 32767): ');
    ReadLn(newUsuario.contrasena);
    WriteLn('Apellido y nombre: ');
    ReadLn(newUsuario.ape_nom);
    WriteLn('Mail: ');
    ReadLn(newUsuario.mail);
    Write(archivo, newUsuario); //agrego el nuevo usuario al archivo
end;

function buscarCuentaPorDni(var archivo: file of CuentaVirtual; dni: string): integer;
var
    unaCuenta: CuentaVirtual;
begin
    read(archivo, unaCuenta);
    while (unaCuenta.dni <> dni) AND (not(eof(archivo))) do  //mientras el dni que busco sea distinto del que esta en el archivo
    begin                                                    // y no sea el final del mismo, sigo buscando
        read(archivo, unaCuenta);              //busco la cuenta por el campo de dni
    end;
    if unaCuenta.dni = dni then
    begin
        buscarCuentaPorDni := filepos(archivo) - 1;          //si la cuenta existe devuelvo la posicion en el archivo
    end
    else
    begin
        buscarCuentaPorDni := -1;          //si no existe devuelvo -1 para luego darla de alta
    end;
end;

function buscarUsuarioPorDni(var archivoUsuarios: file of Usuario; dni: string): integer;
var
    unUser: usuario;
begin
    read(archivoUsuarios, unUser);
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

procedure IniciarSesion(var archivo: file of Usuario);
var
    dni: string[8];
    unUsuario: usuario;
begin
    WriteLn('    INICIO DE SESION');
    WriteLn();
    WriteLn();
    WriteLn('Ingrese sus datos para iniciar sesion:');
    WriteLn();
    Write('DNI: ');
    ReadLn(dni);
    usuarioIniciado := buscarUsuarioPorDni(archivo, dni);
    if usuarioIniciado = -1 then
    begin
        WriteLn('El DNI ingresado no esta registrado como usuario.');
        WriteLn('Complete los siguientes campos para darse de alta:');
        altaUsuario(archivo, dni);
        usuarioIniciado := FilePos(archivo) - 1; // se identifica al usuario mediante la posicion en el archivo
    end
    else
    begin                                    //si existe el dni en el archivo
        Seek(archivo, usuarioIniciado);
        Read(archivo, unUsuario);
        if (NOT IngresarContrasena(unUsuario.contrasena)) then     //pide contraseña y corrobora que sea la misma
            usuarioIniciado := -1;   //si pone la contraseña mal, el inicio de sesion fallara
    end;
end;

procedure OpcionUsuarios;
var
    opcion: integer;
    crearCuenta: string;
    i: integer;
    archivoUsuarios: file of Usuario;
    archivoCuentas: file of CuentaVirtual;
    sesionUsuario: Usuario;
    cuentaUsuario: integer;
    sesionCuentaUsuario, nuevaCuenta: CuentaVirtual;
    nuevaTarjeta: Tarjeta;
begin
    Assign(archivoUsuarios, RUTA_ARCHIVOS + 'usuarios.dat');
    Assign(archivoCuentas, RUTA_ARCHIVOS + 'cuentas-virtuales.dat');
    Reset(archivoUsuarios);
    Reset(archivoCuentas);
    opcion := 0;
    if (usuarioIniciado = -1) then
        ClrScr;
        WriteLn('   Sistema de Usuario');
        IniciarSesion(archivoUsuarios);
        WriteLn();
        WriteLn();
    if (usuarioIniciado <> -1) then
    begin
        repeat
            Seek(archivoUsuarios, usuarioIniciado);
            Read(archivoUsuarios, sesionUsuario);
            ClrScr;
            WriteLn('   Sistema de Usuario');
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
                    IniciarSesion(archivoUsuarios);
                    opcion := 0;
                    ReadKey;
                end;
                2: begin
                    WriteLn('    CUENTAS');
                    WriteLn();
                    cuentaUsuario := buscarCuentaPorDni(archivoCuentas, sesionUsuario.dni);
                    if cuentaUsuario = -1 then
                    begin
                        WriteLn('Actualmente este usuario no tiene una cuenta asociada.');
                        repeat
                            WriteLn('Desea crear una? (si / no)');
                            ReadLn(crearCuenta);
                        until (crearCuenta = 'no') OR (crearCuenta = 'NO') OR (crearCuenta = 'No') OR(crearCuenta = 'si') OR (crearCuenta = 'SI') OR (crearCuenta = 'Si');
                        if (crearCuenta = 'si') OR (crearCuenta = 'SI') OR (crearCuenta = 'Si') then
                        begin
                            WriteLn();
                            WriteLn('Puede agregar hasta 5 tarjetas en su nueva cuenta.');
                            WriteLn('Llene los datos de las tarjetas (finalice con 0):');
                            nuevaCuenta.saldo_billetera := 0;
                            i := 1;
                            WriteLn('------------------');
                            WriteLn('TARJETA Nro. ', i);
                            Write('  Codigo de banco: ');
                            ReadLn(nuevaTarjeta.cod_ban);
                            while (i <= 5) AND (nuevaTarjeta.cod_ban <> 0) do
                            begin
                                repeat
                                    Write('  Debito o Credito? (D / C): ');
                                    ReadLn(nuevaTarjeta.tipo_tar);
                                until (nuevaTarjeta.tipo_tar = 'D') OR (nuevaTarjeta.tipo_tar = 'C');
                                Write('  Saldo de tarjeta: ');
                                ReadLn(nuevaTarjeta.saldo_x_tarjeta);
                                nuevaCuenta.cuenta_virtual[i] := nuevaTarjeta;
                                nuevaCuenta.saldo_billetera := nuevaCuenta.saldo_billetera + nuevaTarjeta.saldo_x_tarjeta;
                                i := i + 1;
                                if (i <= 5) then
                                begin
                                    WriteLn('------------------');
                                    WriteLn('TARJETA Nro. ', i);
                                    ReadLn(nuevaTarjeta.cod_ban);
                                end;
                            end;
                            WriteLn('------------------');
                            Seek(archivoCuentas, FileSize(archivoCuentas));
                            Write(archivoCuentas, nuevaCuenta);
                        end;
                    end
                    else
                    begin
                        Seek(archivoCuentas, cuentaUsuario);
                        Read(archivoCuentas, sesionCuentaUsuario);
                        { if Length(sesionCuentaUsuario.cuenta_virtual) = 0 then
                            WriteLn('Este usuario tiene cuenta asociada, pero no tiene tarjetas en ella...');
                        -}
                        for i := 1 to 5 do
                        begin
                            WriteLn('------------------');
                            WriteLn('TARJETA Nro. ', i);
                            WriteLn('  Codigo de banco: ', sesionCuentaUsuario.cuenta_virtual[i].cod_ban);
                            WriteLn('  Tipo de tarjeta: ', sesionCuentaUsuario.cuenta_virtual[i].tipo_tar);
                            WriteLn('  Saldo: ', sesionCuentaUsuario.cuenta_virtual[i].saldo_x_tarjeta);
                        end;
                        WriteLn('------------------');
                        WriteLn();
                        WriteLn('Saldo billetera: ', sesionCuentaUsuario.saldo_billetera);
                    end;
                    WriteLn();
                    WriteLn();
                    Write('Presione cualquier tecla para volver al Sistema de Usuario...');
                    opcion := 0;
                    ReadKey;
                end;
                3: begin
                    WriteLn('Opcion 3 elegida');
                    opcion := 0;
                    ReadKey;
                end;
                4: begin
                    WriteLn('Opcion 4 elegida');
                    opcion := 0;
                    ReadKey;
                end;
                5: begin
                    WriteLn('Opcion 5 elegida');
                    opcion := 0;
                    ReadKey;
                end;
            end;
        until (opcion = 6) OR (usuarioIniciado = -1);
    end
    else
    begin
        ClrScr;
        WriteLn('   Sistema de usuario');
        WriteLn('No se pudo iniciar sesion.');
        WriteLn();
        Write('Presione cualquier tecla para volver al menu principal...');
        ReadKey;
    end;
    Close(archivoUsuarios);
    Close(archivoCuentas);
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

begin
  usuarioIniciado := -1;
  Menu;
  Write('Presione cualquier tecla para salir del programa');
  ReadKey;
end.





