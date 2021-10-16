@echo off
boss install
set /p chave_jwt="Insira uma chave criptografica para os dados do servidor: "
set /p port_value="Insira a porta de escuta que o servidor atuará (apenas numeros)"

setx CIPTEA_BACKEND_HASH_SECRET %chave_jwt%
setx CIPTEA_BACKEND_PORT %port_value%