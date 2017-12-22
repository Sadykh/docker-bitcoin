# Bitcoind docker

Данный контейнер позволяет изолированно быстро развертывать bitcoind демона на сервере.

## Команды

Если запускать вне состава composer, то можно следующей командой:
```bash
docker run -d --name bitcoind -p 127.0.0.1:18332:18332 -v /bitcoin:/data repositoryName/bitcoind

docker run -d --name bitcoind -p 8333:8333 -v /bitcoin:/data repositoryName/bitcoind
```
Где `/bitcoin` - путь на хост машине, `/data` - путь в docker. В этих папках находятся конфигурации, блоки, wallet.dat и прочее

Чтобы протестировать работу, можно из хост машины сделать вот такой запрос:

```bash
curl --user yoldi --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "getinfo", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:18332/
```

`yoldi` - это RPCUSER, затем будет спрошен пароль. Не забывайте про порт.

# Пример docker-compose

```
version: "3"
services:
  bitcoind:
    container_name: bitcoind
    image: repositoryName/bitcoind
    ports:
      - "8333:8333"
    volumes:
      - /bitcoin:/data
    environment:
      - RPCUSER=btcuser
      - RPCPASSWORD=saintpetersburg
      - RPCPORT=8332
      - TESTNET=0

```

Если `bitcoind.conf` не существует, он будет автоматически сгенерирован:

| name | default value |
| ---- | ------- |
| RPCUSER | btcuser |
| RPCPASSWORD | saintpetersburg |
| RPCPORT | 8332 |
| TESTNET | 0 |
| printtoconsole |  1 |
| rpcallowip  | ::/0 |

Однако, если он существует, то перезаписываться он не будет.

При использовании режима `testnet`, не забудьте указать порт 18333
