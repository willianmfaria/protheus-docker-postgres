#!/bin/sh
set -e

# Credenciais do banco que já vem na imagem totvsengpro/postgres-dev.
/opt/totvs/dbaccess/tools/dbaccesscfg \
  -u postgres \
  -p postgres \
  -d POSTGRES \
  -a Protheus \
  -o "clientlibrary=/usr/lib64/libodbc.so" \
  -g "LicenseServer=license;LicensePort=5555;ByYouProc=0;ODBC30=1"

exec /opt/totvs/dbaccess/multi/dbaccess64
