# Protheus 12.1.2410

Usa as imagens oficiais da TOTVS, sem alteração:

| Serviço | Imagem |
| --- | --- |
| `license` | `totvsengpro/license-dev:3.6.3` |
| `database` | `totvsengpro/postgres-dev:12.1.2410_bra` |
| `dbaccess` | `totvsengpro/dbaccess-postgres-dev:24.1.0.2` |
| `appserver`, `appserver-rest` | `totvsengpro/appserver-dev:24.3.0.5` |

## Como subir

1. Baixe o `tttm120.rpo` da release 12.1.2410, o `sxsbra.txt` e o `sx2.unq` no Portal do Cliente. As imagens não trazem esses arquivos.

2. Crie o `.env` a partir do modelo do seu sistema:

   ```sh
   cp example_macos.env .env    # macOS
   cp example_linux.env .env    # Linux
   copy example_windows.env .env    # Windows
   ```

   Depois crie as pastas de dados. No macOS e no Linux:

   ```sh
   mkdir -p ~/TOTVS/Protheus_2410/apo/dev ~/TOTVS/Protheus_2410/apo/dev2 ~/TOTVS/Protheus_2410/apo/rest ~/TOTVS/Protheus_2410/protheus_data/system ~/TOTVS/Protheus_2410/protheus_data/systemload
   ```

3. Copie os arquivos baixados. O RPO vai em três cópias, uma para cada pasta:

   ```
   ~/TOTVS/Protheus_2410/apo/dev/tttm120.rpo
   ~/TOTVS/Protheus_2410/apo/dev2/tttm120.rpo
   ~/TOTVS/Protheus_2410/apo/rest/tttm120.rpo
   ~/TOTVS/Protheus_2410/protheus_data/systemload/sxsbra.txt
   ~/TOTVS/Protheus_2410/protheus_data/systemload/sx2.unq
   ```

4. Suba o ambiente:

   ```sh
   make up      # docker compose up -d
   make ps      # todos devem ficar "healthy"
   ```

## Acesso

| O quê | Endereço |
| --- | --- |
| TDS | `localhost:9999` com conexão segura (SSL), ambiente `DEV` ou `DEV2` |
| WebApp | https://localhost:9999/webapp/ |
| REST | http://localhost:3000/rest |
| PostgreSQL | `localhost:5432`, banco `protheus`, usuário e senha `postgres` |
| DBAccess | `localhost:7890` |
| License Server | `localhost:5555` |

As portas ficam no `.env` e são as mesmas do 2510, então suba um ambiente de cada vez: pare o outro com `docker compose down` antes.

## Bom saber

- **WebApp só pela porta multiprotocolo:** o acesso é por `https://ip:porta/webapp/`, como orienta a TDN. A porta interna do WebApp (8080) não é publicada de propósito: ela só fala HTTP, mas a tela de login é sempre pedida em HTTPS, e o navegador mostraria `SSL_ERROR_RX_RECORD_TOO_LONG`.
- **Certificado:** o AppServer usa o certificado padrão da TOTVS, válido só para `localhost`. Se o navegador reclamar, instale o `totvs_certificate_CA.crt`, conforme a página [Porta Multiprotocolo - Instalação de Certificado](https://tdn.totvs.com/pages/viewpage.action?pageId=539526365) da TDN.
- **Banco:** a imagem já traz o banco `protheus` (WIN1252) com o dicionário carregado, grupo de empresas 99, filial 01. Na primeira subida o Docker copia esse conteúdo para o volume `docker-protheus-2410_postgres-data`.
- **Credenciais do banco:** estão gravadas nos dados da imagem, por isso não são configuráveis pelo `.env`.
- **Voltar ao banco original:** `docker compose down -v` apaga o volume e tudo o que foi gravado nele.
- **Sem o RPO:** o AppServer encerra logo após subir, com `[MPPORT] Function not found`, e deixa um `tttm120.rpo` de 0 byte na pasta do serviço. Basta substituí-lo pelo arquivo do Portal e subir de novo.
- **RPOs:** no `appserver`, o ambiente `DEV` usa `apo/dev` e o `DEV2` usa `apo/dev2`; o `appserver-rest` usa `apo/rest`. Cada pasta tem o próprio `custom*.rpo`. Aplique patches nas três cópias, para os ambientes não ficarem em versões diferentes.
- **Mais de um ambiente no WebApp:** só abrem pela porta multiprotocolo os ambientes listados em `APP_ENVIRONMENT_EXTRA`, no `[General]` do ini. Ao criar outro ambiente, inclua-o nessa chave.
- **SmartView:** não faz parte deste ambiente, pois a TOTVS não publica imagem oficial dele.
- **Apple Silicon:** as imagens só existem para amd64 e rodam emuladas, com desempenho menor que o nativo.
