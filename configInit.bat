@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
	
set /p chave_jwt="Insira uma chave criptografica para os dados do servidor: "
set /p port_value="Insira a porta de escuta que o servidor atuará (apenas numeros): "

set /p db_name="Insira o nome do banco de dados (O Padrão é: CIPTEA): "
set /p db_username="Insira o nome de usuário do banco de dados: "
set /p db_password="Insira a senha do banco de dados: "
set /p db_port="Insira o número da porta do banco de dados (Padrão do MySQL/MariaDB: 3306): "
set /p db_server="Insira o hostname do servidor de banco de dados (Padrão para banco de dados local: 'localhost' ou '127.0.0.1'): "

setx CIPTEA_BACKEND_HASH_SECRET %chave_jwt% -m
setx CIPTEA_BACKEND_PORT %port_value% -m

setx CIPTEA_BACKEND_DATABASE_NAME %db_name% -m
setx CIPTEA_BACKEND_DB_USERNAME %db_username% -m
setx CIPTEA_BACKEND_DB_PASSWORD %db_password% -m
setx CIPTEA_BACKEND_DB_PORT %db_port% -m
setx CIPTEA_BACKEND_DB_SERVER %db_server% -m

tskill CIPTEA_Server.exe
start CIPTEA_Server.exe