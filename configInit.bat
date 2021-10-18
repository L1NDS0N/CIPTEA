@echo off
set /p chave_jwt="Insira uma chave criptografica para os dados do servidor: "
set /p port_value="Insira a porta de escuta que o servidor atuará (apenas numeros)"

set /p db_name="Insira o nome do banco de dados (O Padrão é: CIPTEA)"
set /p db_username="Insira o nome de usuário do banco de dados"
set /p db_password="Insira a senha do banco de dados"
set /p db_port="Insira o número da porta do banco de dados (Padrão do MySQL/MariaDB: 3306)"
set /p db_server="Insira o hostname do servidor de banco de dados (Padrão para banco de dados local: 'localhost' ou '127.0.0.1')"

setx CIPTEA_BACKEND_HASH_SECRET %chave_jwt%
setx CIPTEA_BACKEND_PORT %port_value%

setx CIPTEA_BACKEND_DATABASE_NAME %db_name%
setx CIPTEA_BACKEND_DB_USERNAME %db_username%
setx CIPTEA_BACKEND_DB_PASSWORD %db_password%
setx CIPTEA_BACKEND_DB_PORT %db_port%
setx CIPTEA_BACKEND_DB_SERVER %db_server%

tskill CIPTEA_Server.exe
start .\CIPTEA_Server.exe