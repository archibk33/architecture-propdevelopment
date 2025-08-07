# Linux скрипты для настройки ролевого доступа Kubernetes

## Описание

Данная директория содержит скрипты для настройки ролевого доступа к Kubernetes кластеру PropDevelopment на платформе Linux.

## Файлы

- `create_users.sh` - создание пользователей и групп
- `create_roles.sh` - создание ролей и ClusterRoles
- `bind_users_to_roles.sh` - связывание пользователей с ролями

## Требования

- Linux система (Ubuntu, CentOS, RHEL, Fedora)
- Docker установлен и запущен
- Minikube или другой Kubernetes кластер
- OpenSSL для создания сертификатов
- kubectl для работы с кластером

## Установка зависимостей

### Ubuntu/Debian
```bash
sudo apt-get update
sudo apt-get install docker.io openssl
sudo systemctl start docker
sudo systemctl enable docker
```

### CentOS/RHEL/Fedora
```bash
sudo yum install docker openssl
sudo systemctl start docker
sudo systemctl enable docker
```

### Установка kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
```

### Установка Minikube
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

## Запуск скриптов

### 1. Запуск Minikube
```bash
minikube start --driver=docker
```

### 2. Создание пользователей
```bash
chmod +x create_users.sh
./create_users.sh
```

### 3. Создание ролей
```bash
chmod +x create_roles.sh
./create_roles.sh
```

### 4. Связывание пользователей с ролями
```bash
chmod +x bind_users_to_roles.sh
./bind_users_to_roles.sh
```

## Проверка результатов

```bash
# Проверка пользователей
ls -la certs/

# Проверка ролей
kubectl get clusterroles -l app=propdevelopment
kubectl get roles --all-namespaces -l app=propdevelopment

# Проверка привязок
kubectl get rolebindings --all-namespaces -l app=propdevelopment
kubectl get clusterrolebindings -l app=propdevelopment

# Проверка namespace
kubectl get namespaces | grep -E "(sales|housing|finance|data)"
```

## Очистка

```bash
# Удаление ресурсов
kubectl delete namespace sales housing finance data
kubectl delete clusterrole -l app=propdevelopment
kubectl delete clusterrolebinding -l app=propdevelopment

# Удаление сертификатов
rm -rf certs/

# Остановка Minikube
minikube stop
minikube delete
``` 