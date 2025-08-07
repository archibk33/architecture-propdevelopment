# Инструкции по настройке ролевого доступа Kubernetes для PropDevelopment

## Предварительные требования

### Windows

#### 1. Установка Docker Desktop
```bash
# Убедитесь, что Docker Desktop запущен
docker --version
```

#### 2. Запуск Kubernetes кластера
```bash
# Включите Kubernetes в Docker Desktop
# Settings -> Kubernetes -> Enable Kubernetes

# Проверьте статус кластера
kubectl cluster-info
kubectl get nodes
```

#### 3. Установка необходимых инструментов
```bash
# Установка OpenSSL (для создания сертификатов)
# Windows: обычно уже установлен
# Проверка установки
openssl version

# Установка kubectl (если не установлен)
# Скачайте с https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
# Добавьте в PATH
kubectl version --client
```

### Linux

#### 1. Установка Docker
```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker

# CentOS/RHEL/Fedora
sudo yum install docker
sudo systemctl start docker
sudo systemctl enable docker

# Проверка установки
docker --version
```

#### 2. Установка Minikube
```bash
# Скачивание Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

# Запуск Minikube
minikube start --driver=docker

# Проверка статуса кластера
kubectl cluster-info
kubectl get nodes
```

#### 3. Установка необходимых инструментов
```bash
# Установка OpenSSL
sudo apt-get install openssl  # Ubuntu/Debian
sudo yum install openssl      # CentOS/RHEL

# Установка kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Проверка установки
openssl version
kubectl version --client
```

## Порядок выполнения скриптов

### Windows

#### Шаг 1: Создание пользователей
```cmd
# Перейдите в директорию Task4
cd Task4

# Запустите скрипт создания пользователей
bash create_users.sh
```

**Результат**: Создано 25 пользователей и группы пользователей

#### Шаг 2: Создание ролей
```cmd
# Запустите скрипт создания ролей
bash create_roles.sh
```

**Результат**: Создано 7 кластерных ролей + 20 ролей по доменам

#### Шаг 3: Связывание пользователей с ролями
```cmd
# Запустите скрипт связывания
bash bind_users_to_roles.sh
```

**Результат**: Создано 2 ClusterRoleBinding + 24 RoleBinding + 4 ServiceAccount + 4 NetworkPolicy

### Linux

#### Шаг 1: Создание пользователей
```bash
# Перейдите в директорию Task4
cd Task4

# Сделайте скрипт исполняемым
chmod +x create_users.sh

# Запустите скрипт создания пользователей
./create_users.sh
```

**Результат**: Создано 25 пользователей и группы пользователей

#### Шаг 2: Создание ролей
```bash
# Сделайте скрипт исполняемым
chmod +x create_roles.sh

# Запустите скрипт создания ролей
./create_roles.sh
```

**Результат**: Создано 7 кластерных ролей + 20 ролей по доменам

#### Шаг 3: Связывание пользователей с ролями
```bash
# Сделайте скрипт исполняемым
chmod +x bind_users_to_roles.sh

# Запустите скрипт связывания
./bind_users_to_roles.sh
```

**Результат**: Создано 2 ClusterRoleBinding + 24 RoleBinding + 4 ServiceAccount + 4 NetworkPolicy

## Проверка результатов

### Windows

#### 1. Проверка созданных пользователей
```cmd
# Проверка сертификатов
dir certs

# Проверка групп пользователей
kubectl get configmap user-groups -n kube-system -o yaml
```

#### 2. Проверка созданных ролей
```cmd
# Кластерные роли
kubectl get clusterroles -l app=propdevelopment

# Роли по доменам
kubectl get roles --all-namespaces -l app=propdevelopment
```

#### 3. Проверка привязок
```cmd
# ClusterRoleBindings
kubectl get clusterrolebindings -l app=propdevelopment

# RoleBindings
kubectl get rolebindings --all-namespaces -l app=propdevelopment
```

#### 4. Проверка namespace
```cmd
# Проверка созданных namespace
kubectl get namespaces | findstr "sales housing finance data"
```

#### 5. Проверка NetworkPolicies
```cmd
# Проверка сетевых политик
kubectl get networkpolicies --all-namespaces -l app=propdevelopment
```

### Linux

#### 1. Проверка созданных пользователей
```bash
# Проверка сертификатов
ls -la certs/

# Проверка групп пользователей
kubectl get configmap user-groups -n kube-system -o yaml
```

#### 2. Проверка созданных ролей
```bash
# Кластерные роли
kubectl get clusterroles -l app=propdevelopment

# Роли по доменам
kubectl get roles --all-namespaces -l app=propdevelopment
```

#### 3. Проверка привязок
```bash
# ClusterRoleBindings
kubectl get clusterrolebindings -l app=propdevelopment

# RoleBindings
kubectl get rolebindings --all-namespaces -l app=propdevelopment
```

#### 4. Проверка namespace
```bash
# Проверка созданных namespace
kubectl get namespaces | grep -E "(sales|housing|finance|data)"
```

#### 5. Проверка NetworkPolicies
```bash
# Проверка сетевых политик
kubectl get networkpolicies --all-namespaces -l app=propdevelopment
```

## Тестирование доступа

### Windows

#### Тест 1: Проверка доступа администратора безопасности
```cmd
# Переключение на контекст администратора
kubectl config use-context admin.security-context

# Проверка доступа ко всем ресурсам
kubectl get all --all-namespaces
```

#### Тест 2: Проверка доступа разработчика
```cmd
# Переключение на контекст разработчика
kubectl config use-context dev.sales.1-context

# Проверка доступа к namespace sales
kubectl get pods -n sales
kubectl get services -n sales

# Попытка доступа к другому namespace (должна быть запрещена)
kubectl get pods -n housing
```

#### Тест 3: Проверка изоляции доменов
```cmd
# Создание тестового пода в namespace sales
kubectl run test-pod --image=nginx -n sales

# Попытка доступа из другого namespace (должна быть заблокирована NetworkPolicy)
kubectl run test-pod --image=nginx -n housing
```

### Linux

#### Тест 1: Проверка доступа администратора безопасности
```bash
# Переключение на контекст администратора
kubectl config use-context admin.security-context

# Проверка доступа ко всем ресурсам
kubectl get all --all-namespaces
```

#### Тест 2: Проверка доступа разработчика
```bash
# Переключение на контекст разработчика
kubectl config use-context dev.sales.1-context

# Проверка доступа к namespace sales
kubectl get pods -n sales
kubectl get services -n sales

# Попытка доступа к другому namespace (должна быть запрещена)
kubectl get pods -n housing
```

#### Тест 3: Проверка изоляции доменов
```bash
# Создание тестового пода в namespace sales
kubectl run test-pod --image=nginx -n sales

# Попытка доступа из другого namespace (должна быть заблокирована NetworkPolicy)
kubectl run test-pod --image=nginx -n housing
```

## Структура созданных ресурсов

### Пользователи (25)
- **Администраторы безопасности**: 2
- **DevOps инженеры**: 4 (по доменам)
- **Разработчики**: 14 (по доменам)
- **Операционные менеджеры**: 5 (по доменам)

### Роли (27)
- **Кластерные роли**: 7
- **Роли по доменам**: 20 (5 ролей × 4 домена)

### Привязки (34)
- **ClusterRoleBindings**: 2
- **RoleBindings**: 24
- **ServiceAccounts**: 4
- **NetworkPolicies**: 4

## Соответствие требованиям безопасности

**Принцип наименьших привилегий** - каждый пользователь имеет минимально необходимые права
**Разграничение по доменам** - изоляция между бизнес-доменами
**Защита критичных данных** - ограниченный доступ к секретам
**Аудит действий** - все действия логируются
**Сетевая изоляция** - NetworkPolicies между доменами

## Устранение неполадок

### Windows

#### Проблема: Ошибка создания сертификатов
```cmd
# Проверьте наличие OpenSSL
openssl version

# Проверьте права доступа к директории
dir certs
```

#### Проблема: Ошибка применения YAML
```cmd
# Проверьте синтаксис YAML
kubectl apply -f file.yaml --dry-run=client

# Проверьте логи
kubectl logs -n kube-system deployment/kube-apiserver
```

#### Проблема: Отказ в доступе
```cmd
# Проверьте права пользователя
kubectl auth can-i get pods -n sales

# Проверьте RoleBindings
kubectl get rolebindings -n sales
```

### Linux

#### Проблема: Ошибка создания сертификатов
```bash
# Проверьте наличие OpenSSL
openssl version

# Проверьте права доступа к директории
ls -la certs/
```

#### Проблема: Ошибка применения YAML
```bash
# Проверьте синтаксис YAML
kubectl apply -f file.yaml --dry-run=client

# Проверьте логи
kubectl logs -n kube-system deployment/kube-apiserver
```

#### Проблема: Отказ в доступе
```bash
# Проверьте права пользователя
kubectl auth can-i get pods -n sales

# Проверьте RoleBindings
kubectl get rolebindings -n sales
```

#### Проблема: Minikube не запускается
```bash
# Проверьте статус Docker
sudo systemctl status docker

# Перезапустите Minikube
minikube stop
minikube start --driver=docker

# Проверьте логи
minikube logs
```

## Очистка ресурсов

### Windows
```cmd
# Удаление всех созданных ресурсов
kubectl delete namespace sales housing finance data
kubectl delete clusterrole -l app=propdevelopment
kubectl delete clusterrolebinding -l app=propdevelopment

# Удаление сертификатов
rmdir /s certs
```

### Linux
```bash
# Удаление всех созданных ресурсов
kubectl delete namespace sales housing finance data
kubectl delete clusterrole -l app=propdevelopment
kubectl delete clusterrolebinding -l app=propdevelopment

# Удаление сертификатов
rm -rf certs/

# Остановка Minikube (если использовался)
minikube stop
minikube delete
``` 