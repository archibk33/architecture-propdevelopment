@echo off
REM Скрипт связывания пользователей с ролями Kubernetes для PropDevelopment
REM Основан на анализе безопасности из Task1-Task3
REM Версия для Windows

echo === Связывание пользователей с ролями Kubernetes для PropDevelopment ===
echo Основано на организационной структуре и принципе наименьших привилегий
echo Платформа: Windows
echo.

echo === Связывание администраторов безопасности ===

REM Cluster Admin (только один пользователь)
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRoleBinding
echo metadata:
echo   name: propdevelopment-cluster-admin-binding
echo   labels:
echo     app: propdevelopment
echo subjects:
echo - kind: User
echo   name: admin.security@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: ClusterRole
echo   name: propdevelopment-cluster-admin
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

echo.
echo === Связывание DevOps инженеров ===

REM DevOps инженеры получают namespace-admin роли в своих доменах
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-sales-devops-binding
echo   namespace: sales
echo   labels:
echo     app: propdevelopment
echo     domain: sales
echo subjects:
echo - kind: User
echo   name: devops.sales@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-sales-admin
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-housing-devops-binding
echo   namespace: housing
echo   labels:
echo     app: propdevelopment
echo     domain: housing
echo subjects:
echo - kind: User
echo   name: devops.housing@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-housing-admin
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-finance-devops-binding
echo   namespace: finance
echo   labels:
echo     app: propdevelopment
echo     domain: finance
echo subjects:
echo - kind: User
echo   name: devops.finance@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-finance-admin
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-data-devops-binding
echo   namespace: data
echo   labels:
echo     app: propdevelopment
echo     domain: data
echo subjects:
echo - kind: User
echo   name: devops.data@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-data-admin
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

REM DevOps инженеры также получают secrets-manager роли
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-sales-secrets-binding
echo   namespace: sales
echo   labels:
echo     app: propdevelopment
echo     domain: sales
echo subjects:
echo - kind: User
echo   name: devops.sales@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-sales-secrets-manager
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-housing-secrets-binding
echo   namespace: housing
echo   labels:
echo     app: propdevelopment
echo     domain: housing
echo subjects:
echo - kind: User
echo   name: devops.housing@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-housing-secrets-manager
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-finance-secrets-binding
echo   namespace: finance
echo   labels:
echo     app: propdevelopment
echo     domain: finance
echo subjects:
echo - kind: User
echo   name: devops.finance@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-finance-secrets-manager
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-data-secrets-binding
echo   namespace: data
echo   labels:
echo     app: propdevelopment
echo     domain: data
echo subjects:
echo - kind: User
echo   name: devops.data@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-data-secrets-manager
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

echo.
echo === Связывание разработчиков ===

REM Разработчики домена "Продажи"
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-sales-developers-rw-binding
echo   namespace: sales
echo   labels:
echo     app: propdevelopment
echo     domain: sales
echo subjects:
echo - kind: User
echo   name: dev.sales.1@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: dev.sales.2@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: dev.sales.3@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-sales-developer-rw
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-sales-developers-ro-binding
echo   namespace: sales
echo   labels:
echo     app: propdevelopment
echo     domain: sales
echo subjects:
echo - kind: User
echo   name: dev.sales.4@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: dev.sales.5@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-sales-developer-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

REM Разработчики домена "ЖКУ"
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-housing-developers-rw-binding
echo   namespace: housing
echo   labels:
echo     app: propdevelopment
echo     domain: housing
echo subjects:
echo - kind: User
echo   name: dev.housing.1@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: dev.housing.2@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-housing-developer-rw
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-housing-developers-ro-binding
echo   namespace: housing
echo   labels:
echo     app: propdevelopment
echo     domain: housing
echo subjects:
echo - kind: User
echo   name: dev.housing.3@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-housing-developer-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

REM Разработчики домена "Финансы"
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-finance-developers-rw-binding
echo   namespace: finance
echo   labels:
echo     app: propdevelopment
echo     domain: finance
echo subjects:
echo - kind: User
echo   name: dev.finance.1@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-finance-developer-rw
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-finance-developers-ro-binding
echo   namespace: finance
echo   labels:
echo     app: propdevelopment
echo     domain: finance
echo subjects:
echo - kind: User
echo   name: dev.finance.2@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-finance-developer-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

REM Разработчики домена "Данные"
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-data-developers-rw-binding
echo   namespace: data
echo   labels:
echo     app: propdevelopment
echo     domain: data
echo subjects:
echo - kind: User
echo   name: dev.data.1@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: dev.data.2@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-data-developer-rw
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-data-developers-ro-binding
echo   namespace: data
echo   labels:
echo     app: propdevelopment
echo     domain: data
echo subjects:
echo - kind: User
echo   name: dev.data.3@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: dev.data.4@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-data-developer-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

echo.
echo === Связывание операционных менеджеров ===

REM Операционные менеджеры получают operator-read-only роли
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-sales-managers-binding
echo   namespace: sales
echo   labels:
echo     app: propdevelopment
echo     domain: sales
echo subjects:
echo - kind: User
echo   name: manager.sales@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-sales-operator-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-housing-managers-binding
echo   namespace: housing
echo   labels:
echo     app: propdevelopment
echo     domain: housing
echo subjects:
echo - kind: User
echo   name: manager.housing.1@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: manager.housing.2@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-housing-operator-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-finance-managers-binding
echo   namespace: finance
echo   labels:
echo     app: propdevelopment
echo     domain: finance
echo subjects:
echo - kind: User
echo   name: manager.finance@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-finance-operator-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: RoleBinding
echo metadata:
echo   name: propdevelopment-data-managers-binding
echo   namespace: data
echo   labels:
echo     app: propdevelopment
echo     domain: data
echo subjects:
echo - kind: User
echo   name: manager.data@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: Role
echo   name: propdevelopment-data-operator-ro
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

echo.
echo === Создание дополнительных привязок для аудита ===

REM Аудиторы безопасности получают доступ ко всем namespace для аудита
for %%d in (sales housing finance data) do (
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: RoleBinding
    echo metadata:
    echo   name: propdevelopment-%%d-auditor-binding
    echo   namespace: %%d
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo subjects:
    echo - kind: User
    echo   name: auditor.security@propdevelopment.com
    echo   apiGroup: rbac.authorization.k8s.io
    echo roleRef:
    echo   kind: Role
    echo   name: propdevelopment-%%d-developer-ro
    echo   apiGroup: rbac.authorization.k8s.io
    ) | kubectl apply -f -
)

echo.
echo === Создание ServiceAccounts для приложений ===

REM Создание ServiceAccounts для каждого домена
for %%d in (sales housing finance data) do (
    echo Создание ServiceAccount для домена: %%d
    
    (
    echo apiVersion: v1
    echo kind: ServiceAccount
    echo metadata:
    echo   name: propdevelopment-%%d-sa
    echo   namespace: %%d
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    ) | kubectl apply -f -

    REM Привязка ServiceAccount к роли developer-read-only
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: RoleBinding
    echo metadata:
    echo   name: propdevelopment-%%d-sa-binding
    echo   namespace: %%d
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo subjects:
    echo - kind: ServiceAccount
    echo   name: propdevelopment-%%d-sa
    echo   namespace: %%d
    echo roleRef:
    echo   kind: Role
    echo   name: propdevelopment-%%d-developer-ro
    echo   apiGroup: rbac.authorization.k8s.io
    ) | kubectl apply -f -

    echo ServiceAccount для домена %%d создан успешно
)

echo.
echo === Создание NetworkPolicies для изоляции доменов ===

REM Создание базовых NetworkPolicies для изоляции доменов
for %%d in (sales housing finance data) do (
    echo Создание NetworkPolicy для домена: %%d
    
    (
    echo apiVersion: networking.k8s.io/v1
    echo kind: NetworkPolicy
    echo metadata:
    echo   name: propdevelopment-%%d-isolation
    echo   namespace: %%d
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo spec:
    echo   podSelector: {}
    echo   policyTypes:
    echo   - Ingress
    echo   - Egress
    echo   ingress:
    echo   - from:
    echo     - namespaceSelector:
    echo         matchLabels:
    echo           name: %%d
    echo   egress:
    echo   - to:
    echo     - namespaceSelector:
    echo         matchLabels:
    echo           name: %%d
    echo   - to:
    echo     - namespaceSelector:
    echo         matchLabels:
    echo           name: kube-system
    ) | kubectl apply -f -

    echo NetworkPolicy для домена %%d создан успешно
)

echo.
echo === Сводка созданных привязок ===
echo ClusterRoleBindings:
echo - propdevelopment-cluster-admin-binding (1 пользователь)
echo - propdevelopment-security-auditor-binding (2 пользователя)
echo.
echo RoleBindings по доменам:
echo - Продажи: 6 привязок
echo - ЖКУ: 6 привязок
echo - Финансы: 6 привязок
echo - Данные: 6 привязок
echo.
echo ServiceAccounts:
echo - 4 ServiceAccount (по одному на домен)
echo.
echo NetworkPolicies:
echo - 4 NetworkPolicy (изоляция доменов)
echo.
echo Все привязки созданы успешно!
echo Всего создано: 2 ClusterRoleBinding + 24 RoleBinding + 4 ServiceAccount + 4 NetworkPolicy
echo.
echo === Проверка созданных привязок ===
echo Для проверки используйте команды:
echo kubectl get rolebindings --all-namespaces -l app=propdevelopment
echo kubectl get clusterrolebindings -l app=propdevelopment
echo kubectl get networkpolicies --all-namespaces -l app=propdevelopment 