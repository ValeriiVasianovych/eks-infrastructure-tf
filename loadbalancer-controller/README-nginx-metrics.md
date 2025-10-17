# Настройка метрик для Nginx Ingress Controller

Этот документ описывает, как настроить мониторинг для Nginx Ingress Controller с помощью Prometheus и Grafana.

## Компоненты

1. **ServiceMonitor** - для сбора метрик с nginx ingress controller
2. **Grafana Dashboard** - для визуализации метрик
3. **Обновленная конфигурация Helm** - для включения метрик

## Шаги настройки

### 1. Обновление конфигурации nginx ingress controller

Обновите файл `values/nginx-ingress.yaml`:

```yaml
controller:
  ingressClassResource:
    name: external-nginx
  
  # Включение метрик
  metrics:
    enabled: true
    service:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "10254"
      serviceMonitor:
        enabled: true
        namespace: monitoring
        namespaceSelector: {}
        scrapeInterval: 30s
        targetLabels: []
        podTargetLabels: []
        endpoints:
        - port: metrics
          path: /metrics
          interval: 30s
          scrapeTimeout: 10s
  
  service:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: external
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
      service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
```

### 2. Применение обновленной конфигурации

```bash
# Обновите nginx ingress controller
helm upgrade external ingress-nginx/ingress-nginx \
  --namespace ingress \
  -f values/nginx-ingress.yaml
```

### 3. Применение ServiceMonitor

```bash
kubectl apply -f nginx-ingress-metrics.yaml
```

### 4. Применение дашборда Grafana

```bash
kubectl apply -f nginx-ingress-dashboard.yaml
```

## Проверка настройки

### Проверка ServiceMonitor

```bash
kubectl get servicemonitor -n monitoring
kubectl describe servicemonitor nginx-ingress-controller -n monitoring
```

### Проверка метрик

```bash
# Проверка, что метрики доступны
kubectl port-forward -n ingress svc/external-nginx-controller-metrics 10254:10254

# В другом терминале
curl localhost:10254/metrics
```

### Проверка в Prometheus

1. Откройте Prometheus UI
2. Перейдите в Status -> Targets
3. Найдите target с именем `nginx-ingress-controller`

### Проверка в Grafana

1. Откройте Grafana UI
2. Перейдите в Dashboards
3. Найдите дашборд "Nginx Ingress Controller"

## Доступные метрики

Основные метрики, которые собираются:

- `nginx_ingress_controller_nginx_process_connections` - количество соединений
- `nginx_ingress_controller_requests` - количество запросов
- `nginx_ingress_controller_request_duration_seconds` - время ответа
- `nginx_ingress_controller_nginx_process_connections` - состояния соединений

## Дашборд Grafana

Дашборд включает следующие панели:

1. **Total Connections** - общее количество соединений
2. **Requests per Ingress** - запросы по ingress ресурсам
3. **Response Time** - время ответа (50-й и 95-й процентили)
4. **Connection States** - состояния соединений

## Troubleshooting

### Метрики не собираются

1. Проверьте, что ServiceMonitor создан:
   ```bash
   kubectl get servicemonitor -n monitoring
   ```

2. Проверьте labels на service:
   ```bash
   kubectl get svc -n ingress --show-labels
   ```

3. Проверьте, что метрики доступны:
   ```bash
   kubectl port-forward -n ingress svc/external-nginx-controller-metrics 10254:10254
   curl localhost:10254/metrics
   ```

### Дашборд не отображается

1. Проверьте, что ConfigMap создан:
   ```bash
   kubectl get configmap -n monitoring | grep nginx
   ```

2. Проверьте labels на ConfigMap:
   ```bash
   kubectl get configmap nginx-ingress-dashboard -n monitoring --show-labels
   ```

3. Убедитесь, что Grafana настроена на автоматическое обнаружение дашбордов.

## Полезные команды

```bash
# Проверка метрик в реальном времени
kubectl port-forward -n ingress svc/external-nginx-controller-metrics 10254:10254

# Проверка логов nginx ingress controller
kubectl logs -n ingress deployment/external-nginx-controller

# Проверка статуса подов
kubectl get pods -n ingress

# Проверка сервисов
kubectl get svc -n ingress
``` 