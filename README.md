<p>Considerando ecossistemas compostos por serviços e microserviços, essa aplicação cria containers que demonstram na prática algumas das funcionalidades presentes na API Gateaway Korg (ex: Balanceamento de carga e Health Checks). 
Para tal foram utilizadas ferramentas presentes na API de gerenciameneto Konga que podem ser simuladas por qualquer um dos métodos de configuração descritos abaixo.</p>

## método 1

### serviço a
```dosini
curl -i -X POST --url http://localhost:8001/services --data "name=service_a" --data "host=servicea" --data "protocol=http" --data "port=3001"
```

### rota a
```dosini
curl -i -X POST --url http://localhost:8001/routes --data "name=route_a_service_a" --data "paths[]=/a" --data "service.id=<id service a>"
```

### upstream do serviço b
```dosini
curl -i -X POST --url http://localhost:8001/upstreams --data "name=serviceb_upstream"
```

### health checks do serviço b
```dosini
curl -i -X PATCH --url http://localhost:8001/upstreams/serviceb_upstream --data healthchecks.active.https_verify_certificate=false --data healthchecks.active.unhealthy.timeouts=1 --data healthchecks.active.unhealthy.http_failures=1 --data healthchecks.active.unhealthy.interval=5 --data healthchecks.active.healthy.interval=5 --data healthchecks.active.healthy.successes=1
```

### serviço b com upstream
```dosini
curl -X POST http://localhost:8001/services --data "name=service_b" --data "host=serviceb_upstream" --data "protocol=http" --data "port=8000"
```

### rota b
```dosini
curl -X POST http://localhost:8001/routes --data "name=route_b_service_b" --data "paths[]=/b" --data "service.id=<id service b1>"
```

### targets do serviço b1 e b2
```dosini
curl -X POST http://localhost:8001/upstreams/serviceb_upstream/targets --data "target=serviceb1:3021" --data "weight=100"
```

```dosini
curl -X POST http://localhost:8001/upstreams/serviceb_upstream/targets --data "target=serviceb2:3022" --data "weight=100"
```

## Método 2

### Criar nova conexão
![passo 1](/images/1.png)
&nbsp;
### Acessar página dos snapshots
![passo 2](/images/2.png)
&nbsp;
### Importa arquivo snapshot_1.json na raiz da aplicação
![passo 3](/images/3.png)
&nbsp;
### Acessar detalhes do snapshot carregado
![passo 4](/images/4.png)
&nbsp;
### Restaurar configurações
![passo 5](/images/5.png)


## Kong em ação

### Serviço A
```
[http://localhost:8000/a](http://localhost:8000/a)
```
&nbsp;
### Serviço B com balanceamento de carga
```
[http://localhost:8000/b](http://localhost:8000/b)

```

&nbsp;

Atualize a página do Serviço B repetitivamente para visualizar o balanceamento de carga em execução
