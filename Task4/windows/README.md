# Windows скрипты для настройки ролевого доступа Kubernetes

## Описание

Данная директория содержит скрипты для настройки ролевого доступа к Kubernetes кластеру PropDevelopment на платформе Windows.

## Файлы

- `create_users_simple.bat` - создание пользователей и групп (упрощенная версия без OpenSSL)
- `create_roles.bat` - создание ролей и ClusterRoles
- `bind_users_to_roles.bat` - связывание пользователей с ролями
- `test_rbac.bat` - тестирование RBAC системы
- `cleanup.bat` - очистка всех созданных ресурсов

## Требования

- Windows 10/11
- Docker Desktop установлен и запущен
- Kubernetes включен в Docker Desktop
- kubectl для работы с кластером

## Установка зависимостей

### Docker Desktop
1. Скачайте Docker Desktop с официального сайта
2. Установите и запустите Docker Desktop
3. Включите Kubernetes в настройках Docker Desktop

### kubectl
1. Скачайте kubectl для Windows с https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
2. Добавьте kubectl в PATH
3. Проверьте установку: `kubectl version --client`

## Запуск скриптов

### 1. Проверка Docker Desktop
```cmd
docker --version
kubectl cluster-info
```

### 2. Создание пользователей (упрощенная версия)
```cmd
.\create_users_simple.bat
```

### 3. Создание ролей
```cmd
.\create_roles.bat
```

### 4. Связывание пользователей с ролями
```cmd
.\bind_users_to_roles.bat
```

### 5. Тестирование системы
```cmd
.\test_rbac.bat
```

## Проверка результатов

```cmd
# Проверка пользователей
kubectl get serviceaccounts -l app=propdevelopment

# Проверка ролей
kubectl get clusterroles -l app=propdevelopment
kubectl get roles --all-namespaces -l app=propdevelopment

# Проверка привязок
kubectl get rolebindings --all-namespaces -l app=propdevelopment
kubectl get clusterrolebindings -l app=propdevelopment

# Проверка namespace
kubectl get namespaces | findstr "sales housing finance data"
```

## Структура созданных ресурсов

### Пользователи (25 ServiceAccount'ов)
- **Администраторы безопасности**: 2
  - admin.security
  - auditor.security
- **DevOps инженеры**: 4
  - devops.sales, devops.housing, devops.finance, devops.data
- **Разработчики**: 14
  - dev.sales.1-5, dev.housing.1-3, dev.finance.1-2, dev.data.1-4
- **Операционные менеджеры**: 5
  - manager.sales, manager.housing.1-2, manager.finance, manager.data

### Роли
- **ClusterRole'ы**: 7
  - propdevelopment-cluster-admin
  - propdevelopment-namespace-admin
  - propdevelopment-developer-read-write
  - propdevelopment-developer-read-only
  - propdevelopment-operator-read-only
  - propdevelopment-security-auditor
  - propdevelopment-secrets-manager

- **Role'ы по доменам**: 20 (по 5 для каждого из 4 доменов)
  - propdevelopment-{domain}-admin
  - propdevelopment-{domain}-developer-rw
  - propdevelopment-{domain}-developer-ro
  - propdevelopment-{domain}-operator-ro
  - propdevelopment-{domain}-secrets-manager

### Привязки
- **ClusterRoleBinding'ы**: 2
- **RoleBinding'ы**: 24 (по 6 для каждого домена)
- **NetworkPolicies**: 4 (изоляция доменов)

### Namespace'ы
- sales
- housing
- finance
- data

## Принципы безопасности

1. **Принцип наименьших привилегий**: каждый пользователь получает минимально необходимые права
2. **Изоляция доменов**: пользователи могут работать только в своих доменах
3. **Разделение ролей**: четкое разделение между разработчиками, DevOps и менеджерами
4. **Аудит безопасности**: специальные роли для аудиторов безопасности

## Очистка

Для удаления всех созданных ресурсов используйте:
```cmd
.\cleanup.bat
```

## Устранение неполадок

### Проблема: Docker Desktop не запускается
- Проверьте, что WSL2 установлен и включен
- Перезапустите Docker Desktop
- Проверьте настройки виртуализации в BIOS

### Проблема: Kubernetes не запускается
- В Docker Desktop перейдите в Settings -> Kubernetes
- Нажмите "Reset Kubernetes Cluster"
- Дождитесь перезапуска кластера

### Проблема: kubectl не найден
- Добавьте путь к kubectl в переменную PATH
- Перезапустите командную строку
- Проверьте установку: `kubectl version --client`

### Проблема: ошибки при создании ресурсов
- Проверьте, что кластер работает: `kubectl cluster-info`
- Проверьте права доступа: `kubectl auth can-i create clusterroles`
- При необходимости перезапустите кластер

## Дополнительные возможности

### Мониторинг доступа
```cmd
# Проверка прав пользователя
kubectl auth can-i get pods --as=dev.sales.1 -n sales

# Просмотр событий RBAC
kubectl get events --all-namespaces | findstr "rbac"
```

### Экспорт конфигурации
```cmd
# Экспорт всех ресурсов
kubectl get all --all-namespaces -l app=propdevelopment -o yaml > propdevelopment-rbac.yaml
```

## Заключение

RBAC система PropDevelopment обеспечивает:
- Безопасный доступ к Kubernetes кластеру
- Изоляцию между доменами
- Гибкое управление правами доступа
- Возможность аудита и мониторинга

Система готова к использованию в продакшн среде с дополнительной настройкой аутентификации. 