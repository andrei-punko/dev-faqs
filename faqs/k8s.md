# Kubernetes FAQ

## Основные концепции

### Архитектура кластера

- **Cluster** состоит из **Nodes**
- Каждая **Node** содержит **Pods**
- **Pod** - это один или группа (тесно связанных) контейнеров. Используется для оркестрации контейнеров в облаке

### Минимальный набор компонентов кластера

**Control plane:**
- apiserver
- controller-manager
- kube-scheduler
- etcd

**Worker nodes:**
- kubelet
- kube-proxy

---

## Основные ресурсы Kubernetes

### Pods
- Pod - минимальная единица развертывания в Kubernetes
- Pod может содержать один или несколько тесно связанных контейнеров
- Каждый Pod получает уникальный IP-адрес в кластере

### Deployments
- Используются для обеспечения масштабируемости и обновлений без простоя
- Управляют ReplicaSets и Pods
- Поддерживают стратегии обновления: RollingUpdate и Recreate

**Стратегии обновления:**
- **RollingUpdate** - во время процесса развертывания новой версии некоторые поды имеют старую версию, некоторые - новую
- **Recreate** - поды со старой версией удаляются, после этого создаются новые поды с новой версией, так что нет двух версий одновременно

### Services
Service - это метод для предоставления доступа к приложению, состоящему из одного или нескольких реплицированных Pods.

**Типы Services:**
- **ClusterIP** - тип по умолчанию, предоставляет доступ к приложению только через внутренний IP-адрес кластера
- **NodePort** - использует внутренний IP-адрес кластера, который становится доступным на узлах кластера через проброс портов
- **LoadBalancer** - предоставляет доступ к Service извне, используя внешний балансировщик нагрузки
- **ExternalName** - перенаправляет трафик на внешнее DNS-имя вместо Pods

### Ingress
- Ingress - это интегрированный в кластер балансировщик нагрузки
- По сути это HTTP/HTTPS прокси
- Ingress - опциональный компонент
- Ingress предоставляет HTTP и HTTPS маршруты извне кластера к Services внутри кластера
- Для работы с Ingress необходимо отдельно установить Ingress controller
- Ingress подключается к Service для обнаружения Pods, которые он предоставляет

### ConfigMaps
- ConfigMaps хранят конфигурацию в развязанном виде
- Используются для хранения неконфиденциальных данных в виде пар ключ-значение

### Secrets
- Secrets используются для хранения конфиденциальных данных
- **Типы Secrets:**
  - **generic** - используется как base-64 закодированный ConfigMap
  - **TLS** - используется для хранения TLS ключей
  - **docker-registry** - используется для хранения учетных данных доступа к реестру контейнеров

### Persistent Volumes (PV) и Persistent Volume Claims (PVC)
- **Persistent Volume (PV)** - отдельный API ресурс, представляющий хранилище в конкретной среде
- **Persistent Volume Claim (PVC)** - API объект, который динамически обнаруживает доступные Persistent Volumes, не запрашивая конкретное решение
- Используются для хранения данных в развязанном виде

### StorageClass
- StorageClass определяет классы хранилища, которые администраторы могут предлагать для различных типов хранилищ

---

## Установка и настройка

### Установка kubectl
```bash
kubectl version --client --output=yaml
```

### Установка minikube (Windows)
```bash
choco install minikube
choco upgrade minikube
```

### Запуск minikube
```bash
minikube start
minikube start --driver=hyperv --container-runtime=containerd
minikube stop
minikube delete
minikube status
```

### Полезные команды minikube
```bash
minikube help
minikube kubectl cluster-info
minikube ip                    # показать IP-адрес узла minikube
minikube ssh                   # подключиться к узлу minikube
minikube tunnel                # создать туннель для LoadBalancer сервисов
minikube service <service-name> --url  # получить URL для доступа к сервису
minikube dashboard            # открыть веб-дашборд Kubernetes
minikube addons list          # показать список аддонов
minikube addons enable ingress # включить Ingress аддон
```

### Алиасы
```bash
alias k="minikube kubectl --"
```

---

## Основные команды kubectl

### Получение информации
```bash
kubectl get nodes
kubectl get namespaces
kubectl get pods
kubectl get pods --namespace=kube-system
kubectl get pods -o wide              # показать IP-адреса подов
kubectl get all
kubectl get all --show-labels
kubectl get all --selector app=<label-name>  # показать только приложения с определенным лейблом
kubectl get deploy,pods,svc --show-labels -o wide
kubectl get pv,pvc,pods
kubectl get storageclass
```

### Описание ресурсов
```bash
kubectl describe pod <pod-name>
kubectl describe deploy <deploy-name>
kubectl describe svc <service-name>
kubectl describe ing <ingress-name>
kubectl describe cm <configmap-name>
kubectl describe pv <pv-name>
```

### Создание ресурсов
```bash
kubectl run <pod-name> --image=<image>
kubectl create deployment <deploy-name> --image=<image>
kubectl create deployment <deploy-name> --image=<image> --replicas=2
kubectl expose deploy <deploy-name> --port=80 --target-port=80
kubectl expose deploy <deploy-name> --type=NodePort --port=80 --target-port=80
kubectl expose deploy <deploy-name> --type=LoadBalancer --port=80 --target-port=80
```

### Генерация YAML
```bash
kubectl create deploy <name> --image=<image> --replicas=2 --dry-run=client -o yaml > <file>.yaml
kubectl get <k8s-app-name> -o yaml    # показать YAML код работающего приложения
kubectl get deploy <deploy-name> -o yaml | less
```

### Применение манифестов
```bash
kubectl apply -f <file>.yaml
kubectl apply -f <file1>.yaml -f <file2>.yaml
kubectl delete -f <file>.yaml
kubectl delete -f <file1>.yaml -f <file2>.yaml
```

### Масштабирование
```bash
kubectl scale deploy <deploy-name> --replicas=<number>
```

### Обновление
```bash
kubectl set image deploy <deploy-name> <container-name>=<new-image>:<tag>
kubectl rollout status deploy <deploy-name>
```

### Переменные окружения
```bash
kubectl set env deploy <deploy-name> KEY=VALUE
kubectl set env --from=configmap/<cm-name> deploy <deploy-name>
kubectl set env --from=secret/<secret-name> deploy <deploy-name>
```

### Логи и выполнение команд
```bash
kubectl logs <pod-name>
kubectl exec <pod-name> -- <command>
kubectl exec <pod-name> -c <container-name> -- <command>
```

### Удаление ресурсов
```bash
kubectl delete pod <pod-name>
kubectl delete deploy <deploy-name>
kubectl delete svc <service-name>
```

### Редактирование
```bash
kubectl edit deployments.apps <deploy-name>
```

### Справка
```bash
kubectl explain <resource>           # например: kubectl explain deploy.spec
kubectl explain pod.spec
kubectl create cm --help | less
```

### Автодополнение (Bash)
```bash
source <(kubectl completion bash)
```

---

## Работа с Ingress

### Настройка
```bash
minikube addons enable ingress
kubectl get pods -n ingress-nginx
```

### Создание Ingress
```bash
# Добавить IP в /etc/hosts (Linux/Mac) или C:\Windows\System32\drivers\etc\hosts (Windows)
sudo sh -c "echo $(minikube ip) myweb.example.com >> /etc/hosts"

# Создать Ingress ресурс (name-based virtual hosting)
kubectl create ing <ingress-name> --rule="<domain>/=<service-name>:<port>"
kubectl describe ing <ingress-name>
```

---

## Работа с ConfigMaps

### Создание ConfigMap
```bash
# Из папки
kubectl create configmap <cm-name> --from-file=/path/to/directory

# Из конкретных файлов
kubectl create configmap <cm-name> --from-file=/path/to/file1.txt --from-file=/path/to/file2.txt

# Из .env файла
kubectl create configmap <cm-name> --from-file=/path/to/file.env

# Из ключ-значение пар
kubectl create configmap <cm-name> --from-literal=key1=value1 --from-literal=key2=value2
```

### Использование ConfigMap
```bash
kubectl describe cm <cm-name>
kubectl set env --from=configmap/<cm-name> deploy <deploy-name>
```

---

## Работа с Secrets

### Создание Secrets
```bash
# Generic secret
kubectl create secret generic <secret-name> --from-literal=KEY=VALUE

# Docker registry secret (после docker login)
kubectl create secret docker-registry <secret-name> --from-file=.dockerconfigjson=~/.docker/config.json

# Просмотр (base64 закодирован)
kubectl get secret <secret-name> -o yaml

# Декодирование base64
echo <base64-string> | base64 -d
```

### Использование Secrets
```bash
kubectl set env --from=secret/<secret-name> deploy <deploy-name>
```

### Использование imagePullSecrets
В манифесте добавить в `spec.template.spec`:
```yaml
imagePullSecrets:
  - name: <secret-name>
```

---

## Работа с Persistent Volumes

### Создание и использование
```bash
kubectl get pv,pvc
kubectl apply -f <pvc-file>.yaml
kubectl describe pvc <pvc-name>
kubectl get storageclass
kubectl describe storageclass <storageclass-name>
```

### Проверка данных
```bash
kubectl exec <pod-name> -- touch /path/to/file
kubectl exec <pod-name> -- ls /path/to/directory
minikube ssh
ls /mnt/data  # для local storage
```

---

## Labels и Selectors

### Работа с лейблами
```bash
kubectl get all --show-labels
kubectl get all --selector app=<label-name>
```

**Примечание:** Лейбл `app` обычно устанавливается равным имени приложения

---

## Микросервисы в Kubernetes

В микросервисной архитектуре используются стандартизированные контейнерные компоненты, а специфичная для сайта информация предоставляется с помощью различных компонентов Kubernetes:
- **Services** - для доступности
- **ConfigMaps** - для конфигурации и переменных
- **Secrets** - для конфиденциальных значений
- **Persistent Volumes** - для хранилища

### Способы создания микросервисов
1. **YAML манифесты** - указание всего в одном или нескольких YAML файлах
2. **Helm charts** - стандартизированные компоненты с возможностью гибкой кастомизации
3. **Kustomization** - объединение YAML манифестов со специфичной для сайта информацией, которая может генерироваться динамически

**Рекомендация:** Использование Helm charts или Kustomization предпочтительнее из-за гибкого способа разделения специфичной для сайта информации и общего кода.

**GitOps** - хранение конфигурации окружения в Git

---

## Helm

### Основные концепции
- **Helm** - используется для упрощения установки и управления пакетами Kubernetes
- Можно рассматривать как "менеджер пакетов для Kubernetes"
- **Chart** - пакет Helm, который содержит описание пакета и один или несколько шаблонов, содержащих манифесты Kubernetes

### Установка Helm
```bash
# Скачать с github.com/helm/helm/releases
tar xvf helm[Tab]
sudo mv linux-amd64/helm /usr/local/bin
helm version
```

### Основные команды Helm

#### Репозитории
```bash
helm repo add <repo-name> <repo-url>
helm repo list
helm repo update
helm search repo <keyword>
helm search repo <chart-name> --versions
```

#### Установка и управление
```bash
helm install <local-name> <chart-name>              # установить chart
helm install <chart-name> --generate-name           # установить с автогенерируемым именем
helm list [--all-namespaces]                        # список установленных charts
helm status <release-name>                          # статус установленного chart
helm delete <release-name>                          # удалить chart
```

#### Работа с values
```bash
helm show chart <chart-name>                        # показать описание chart
helm show all <chart-name>                          # показать всю информацию
helm show values <chart-name>                       # показать значения по умолчанию
helm get values <release-name>                      # показать только кастомные values
helm get values --all <release-name>                # показать все values
```

#### Кастомизация
```bash
# Использование файла values.yaml
helm install <chart-name> --values values.yaml

# Переопределение значений при установке
helm install <chart-name> --set key=value

# Лучшая практика: использовать values.yaml файл и только --set когда абсолютно необходимо
```

### Основной сайт для поиска Helm charts
https://artifacthub.io

### Пример использования
```bash
# Добавить репозиторий
helm repo add bitnami https://charts.bitnami.com/bitnami

# Установить с кастомными values
helm show values bitnami/nginx | grep replicaCount
vim values.yaml
  commonLabels: "type: helmapp"
  replicaCount: 3
helm install bitnami/nginx --generate-name --values values.yaml
```

---

## Kustomize

**Kustomize** - инструмент, который помогает управлять конфигурациями Kubernetes

### Использование
1. Создать файл `kustomization.yaml`
2. Этот файл содержит секцию `resources`, которая ссылается на дополнительные YAML файлы, которые нужно включить
3. Опционально может содержать `configMapGenerator` и `secretGenerator`
4. Применить содержимое этого файла используя `kubectl apply -k .` из директории, содержащей `kustomization.yaml`

---

## Полезные заметки

- IP-адрес пода совпадает с IP-адресом контейнера внутри пода
- DNS в кластере позволяет обращаться к сервисам по имени (например, `curl nginx`)
- `nslookup <service-name>` показывает ответ от DNS сервера кластера
- При использовании containerd вместо Docker: `sudo ctr -n k8s.io containers list`
- Для работы LoadBalancer в minikube необходимо запустить `minikube tunnel`
