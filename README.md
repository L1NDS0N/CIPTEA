## Instalação de Dependências:
* Utilizando o [boss](https://github.com/hashload/boss "Gerenciador de dependências do Delphi"), no diretório '..\pages'execute:
`` boss install ``
ou nos diretórios similares onde estejam contidos arquivos "boss.json"

## Preparação de ambiente de desenvolvimento:

* No diretório de dependências das pages, é necessário explicitar o uso do framework FMX. Conforme a documentação do [Router4Delphi](https://github.com/bittencourtthulio/Router4Delphi/ "Framework para Criação de Rotas de Telas para FMX e VCL")
* Vá até o arquivo '..\src\Pages\modules\router4delphi\src\Router4D.inc', descomente a seguinte linha:
`` //{$DEFINE HAS_FMX} ``

Feito isso, o projeto já pode ser compilado.

> Este projeto foi desenvolvido com base no Delphi, algumas das tecnologias e dependências deste projeto estão listadas abaixo:
> - [RAD Studio 10.3](https://www.embarcadero.com/br/products/delphi/starter/free-download "Delphi Rio 10.3 IDE Community Edition")
> - Firemonkey Framework
> - [Boss](https://github.com/hashload/boss "Dependency Manager for Delphi") 
> - [Router4Delphi](https://github.com/bittencourtthulio/Router4Delphi/ "Framework para Criação de Rotas de Telas para FMX e VCL")