# BlazeDemo Performance Tests

![Pipeline Status](https://github.com/jonathanwollinger/blazedemo-jmeter-tests/actions/workflows/performance-tests.yml/badge.svg)

![Performance](https://jonathanwollinger.github.io/blazedemo-jmeter-tests/badge.svg?t=123)

---

## Objetivo

Este projeto tem como objetivo validar a performance do sistema:

https://www.blazedemo.com

Simulando o cenário completo de compra de passagem aérea com sucesso (E2E).

---

## Status Atual

### Execução da Pipeline

- Status: PASS
- A pipeline executa corretamente os testes, geração de relatórios e publicação

### Resultado de Performance

#### Load Test

Simula carga constante com controle de throughput utilizando PreciseThroughputTimer.

Duração: 5 minutos

Objetivo:
- Validar SLA  
- Medir estabilidade  
- Obter métricas mais confiáveis (p90)

Resultados: o sistema não atinge o throughput mínimo esperado de 250 requisições por segundo, mantendo aproximadamente 130 req/s. Apesar disso, os tempos de resposta se mantêm relativamente estáveis, porém acima do limite ideal em momentos de maior carga. O comportamento indica limitação de capacidade para sustentar a vazão exigida, mesmo em cenário de carga controlada.

https://jonathanwollinger.github.io/blazedemo-jmeter-tests/load-test/

---

#### Spike Test

Simula aumento abrupto de carga com alto número de usuários em curto período.

Duração: 60 segundos

Objetivo:
- Avaliar comportamento do sistema sob pico repentino  
- Identificar degradação de performance  
- Observar estabilidade e experiência do usuário  

Resultados: durante o teste de pico, o sistema apresentou degradação significativa de performance, com queda no throughput e aumento expressivo do tempo de resposta (p90 acima de 3 segundos). Apesar de não apresentar erros, o baixo índice de APDEX (~0.36) indica experiência insatisfatória para o usuário. O sistema demonstrou limitação na capacidade de absorver picos de carga, não atendendo aos critérios de SLA estabelecidos.

https://jonathanwollinger.github.io/blazedemo-jmeter-tests/spike-test/

---

## Cenário testado

Fluxo automatizado:

1. Acessar homepage  
2. Buscar voos  
3. Selecionar voo  
4. Preencher dados  
5. Confirmar compra  

Validação funcional incluída garantindo compra realizada com sucesso.

---

## Critérios de Aceitação

- 250 requisições por segundo  
- Percentil 90 (p90) < 2 segundos  

---

## Estratégia de Testes

### Load Test

Simula carga constante com controle de throughput utilizando PreciseThroughputTimer.

Objetivo:
- Validar SLA  
- Medir estabilidade  

### Spike Test

Simula aumento abrupto de carga com alto número de usuários em curto tempo.

Objetivo:
- Avaliar comportamento sob pico  
- Identificar degradação e falhas  

---

## Tecnologias Utilizadas

- Apache JMeter  
- GitHub Actions (CI/CD)  
- GitHub Pages  
- Bash  

---

## Como executar localmente

```bash
./scripts/run-test.sh jmeter/test-plans/load-test.jmx load-test 120
./scripts/run-test.sh jmeter/test-plans/spike-test.jmx spike-test 60
```

## Relatórios

Dashboard:
https://jonathanwollinger.github.io/blazedemo-jmeter-tests/

## Conclusão

A pipeline executa com sucesso, porém o sistema não atende ao critério de performance definido.

Análise: - O load test demonstra se o sistema suporta a vazão de 250
req/s dentro do limite de p90 \< 2s\
- O spike test evidencia degradação sob carga elevada

## Considerações

-   Controle de throughput para simular carga realista\
-   Validação funcional garante consistência\
-   Pipeline automatiza execução, validação e publicação\
-   Dashboard facilita análise

## CI/CD

Pipeline automatizada que executa testes, gera relatórios, processa
métricas e publica resultados.

### Estratégia de CI/CD

A pipeline foi projetada para separar falhas técnicas de falhas de performance.

- A execução da pipeline (CI) valida se os testes foram executados corretamente
- A análise de performance valida se o sistema atende aos critérios de SLA

Mesmo quando o SLA não é atendido, a pipeline continua a execução para:

- Gerar relatórios completos
- Publicar resultados
- Permitir análise detalhada

A falha de performance é refletida através de:

- Dashboard de métricas
- Badge de performance
- Status calculado automaticamente (PASS/FAIL)

Essa abordagem evita perda de evidência e permite análise contínua da qualidade do sistema.

## Diferenciais

-   Teste E2E completo\
-   Validação automática de SLA\
-   Dashboard com métricas\
-   Pipeline CI/CD integrada\
-   Separação entre scripts e pipeline

## Autor

Jonathan Wollinger
