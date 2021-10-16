@echo off
cd .\src\pages
boss install
cd ..
copy ".\src\Router4D.inc"  ".\src\Pages\modules\router4delphi\src"