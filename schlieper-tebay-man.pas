
{Comision 105 - Schlieper Tadeo / Tebay Mauro / Man Uriel}
program tp3;
uses Crt, sysutils;

const
    RUTA_ARCHIVOS = 'C:\ayed\tp3\';

type        
    Banco = record
        codBanco: integer; {(codigo de banco)}
        nombre: string [30];
    end;

    Comercio = record
        codigoComercio:integer;
        nombre:string[30];
        cuit:string[12];
        estado:boolean;
    end;
    
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

    usuario=record
        dni:string[8];
        pass:integer;
        nombreApellido:string[30];
        mail:string[40];
    end;

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
    arrayInicio= array [1..2] of integer; //primer campo es la pos en el archivo y el segundo es 1 si esta validado, de lo contrario 0
var
   archivoUsuarios:file of usuario;

{Esta opcion listara primero todas las entidades bancarias que ya est?n cargadas en el sistema en bancos.dat, y permitir? ingresar nuevos bancos. Por cada nuevo ingreso se deber? registrar el c?digo del banco y el nombre de la entidad.}
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
        writeln('Codigo: ',  nuevoBanco.codBanco);
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
                ReadLn(nuevoBanco.codBanco);
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
        writeln('cuit: ',  nuevoComercio.cuit);
        writeln('estado: ',  nuevoComercio.estado);
        writeln('codigo: ',  nuevoComercio.codigoComercio);
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
                    writeln('Codigo: ',  nuevoComercio.codigoComercio);
                    writeln;
                    WriteLn('1) Modificar Nombre.');
                    WriteLn('2) Modificar Cuit.');
                    WriteLn('3) Modificar Estado.');
                    WriteLn('4) Salir.');
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
                            WriteLn('Ingrese el cuit del comercio');
                            ReadLn(nuevoComercio.cuit);
                            ClrScr;
                            WriteLn('El cuit se ha modificado satisfactoriamente.');
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

Function EncriptarClaves(claveReal:integer):boolean;
var
  intentos: integer;
  caracter: char;
  clave: string;
  claveInt:integer;

begin
  intentos := 3;
  WriteLn('Ingrese la clave (maximo 8 caracteres):');
  repeat
    if intentos < 3 then
    begin
      ClrScr;
      WriteLn('Clave incorrecta. Ingrese nuevamente (', intentos, ' intentos restantes):');
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
    until (Length(clave) >= 8) OR (Ord(caracter) = 10) OR (Ord(caracter) = 13);
    (* #10 es LF y #13 es CR en ASCII (tecla Enter en Windows equivale a CR LF) *)
    WriteLn();
    intentos := intentos - 1;
    claveInt:=StrToInt(clave);
  until (claveInt = claveReal) OR (intentos < 1);
  WriteLn(); WriteLn();
  if claveInt = claveReal then
  begin
    EncriptarClaves:=True;
    WriteLn('La clave es correcta.');
  end
  else
  begin
    EncriptarClaves:=False;
    WriteLn('La clave es incorrecta. Ya no quedan mas intentos.');
  end;
end;

function buscarDni(dni:string):integer;
var
    unUser:usuario;
begin
    read(archivoUsuarios, unUser);
    while (unUser.dni <> dni) AND (not(eof(archivoUsuarios))) do  //mientras el dni que busco sea distinto del que esta en el archivo
    begin                                                         // y no sea el final del mismo, sigo buscando
        read(archivoUsuarios, unUser);              //busco el usuario por el campo de dni
    end;
    if unUser.dni = dni then
    begin
        buscarDni:=filepos(archivoUsuarios)-1;          //si el usuario existe devuelvo la posicion en el archivo
    end
    else
    begin
        buscarDni:=-1;          //si no existe devuelvo -1 para luego darlo de alta
    end;
end;

procedure altaUsuarios(dni:string[8]);
var 
    newUsuario:usuario;
begin
    seek(archivoUsuarios, FileSize(archivoUsuarios));  //posiciono el puntero al final del archivo
    newUsuario.dni:=dni;
    writeln('Ingrese su clave: (numero entre -32768 to 32767)');
    readln(newUsuario.pass);
    WriteLn('Ingrese su nombre y apellido: ');
    readln(newUsuario.nombreApellido);
    writeln('Ingrese su mail: ');
    readln(newUsuario.mail);

    write(archivoUsuarios, newUsuario); //agrego el nuevo usuario al archivo
end;

function Inicio:arrayInicio;
var
    dni:string[8];
    unUsuario: usuario;
    pos:integer;
begin
    writeln('Ingrese su nro de DNI:');
    readln(dni);
    pos:=buscarDni(dni);
    if pos = -1 then
    begin
        altaUsuarios(dni);
        Inicio[1]:=filepos(archivoUsuarios)-1; //el 1er campo del array que devuelve es la pos en el archivo
        Inicio[2]:=1;
    end
    else                                    //si existe el dni en el archivo
        seek(archivoUsuarios, pos);
        read(archivoUsuarios, unUsuario);
        Inicio[1]:=pos;
        if (EncriptarClaves(unUsuario.pass)) then       //pide contraseña y corrobora que sea la misma
        begin
            Inicio[2]:=1;  //si pone la contraseña bien
        end
        else
        begin
            Inicio[2]:=0    //si pone la contraseña mal
        end;
end;

procedure OpcionUsuarios;
const
    noIngresado='El usuario no esta validado, inicie sesion correctamente para utilizar esta funcion';
var
    opc:integer;
    usuarioValidado:arrayInicio;
    archivoUsuarios: file of usuario;
begin
    assign(archivoUsuarios, RUTA_ARCHIVOS + 'usuarios.dat');
    reset(archivoUsuarios);  //abro archivo usuarios.dat
    WriteLn('   USUARIOS');
    WriteLn;
    WriteLn('1) Inicio Sesion');
    WriteLn('2) Cuentas');
    WriteLn('3) Envios de Dinero');
    WriteLn('4) Compras en Comercios');
    writeln('5) Movimientos');
    writeln('6) Salir');
    repeat
        Write('Seleccione ingresando una de las opciones: ');
        ReadLn(opc);
    until (opc >= 1) AND (opc <= 6);
    case opc of
        1: begin
            ClrScr;
            usuarioValidado:=Inicio;
            OpcionUsuarios;
        end;
        2: begin
            ClrScr;
            if usuarioValidado[2]=0 then
            begin
                writeln(noIngresado);
                writeln();
                OpcionUsuarios;
            end
            else
            begin
                //Cuentas;
                OpcionUsuarios;
            end;
        end;
        3: begin
            ClrScr;
            if usuarioValidado[2]=0 then
            begin
                writeln(noIngresado);
                writeln();
                OpcionUsuarios;
            end
            else
            begin
                //Envios;
                OpcionUsuarios;
            end;
        end;
        4: begin
            ClrScr;
            if usuarioValidado[2]=0 then
            begin
                writeln(noIngresado);
                writeln();
                OpcionUsuarios;
            end
            else
            begin
                //Compras;
                OpcionUsuarios;
            end;
        end;
        5: begin
            ClrScr;
            if usuarioValidado[2]=0 then
            begin
                writeln(noIngresado);
                writeln();
                OpcionUsuarios;
            end
            else
            begin
                //Movimientos;
                OpcionUsuarios;
            end;
        end;
    end;
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





