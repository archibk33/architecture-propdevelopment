@echo off
REM Скрипт создания ролей Kubernetes для PropDevelopment
REM Основан на анализе безопасности из Task1-Task3
REM Версия для Windows

echo === Создание ролей Kubernetes для PropDevelopment ===
echo Основано на анализе безопасности и принципе наименьших привилегий
echo Платформа: Windows
echo.

REM Создание namespace для доменов
echo Создание namespace для доменов...
kubectl create namespace sales --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace housing --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace finance --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace data --dry-run=client -o yaml | kubectl apply -f -

echo Namespace созданы успешно
echo.

REM 1. Cluster Admin Role (критично для управления безопасностью)
echo Создание роли cluster-admin...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-cluster-admin
echo   labels:
echo     app: propdevelopment
echo     role: cluster-admin
echo rules:
echo - apiGroups: ["*"]
echo   resources: ["*"]
echo   verbs: ["*"]
) | kubectl apply -f -

REM 2. Namespace Admin Role (для DevOps инженеров)
echo Создание роли namespace-admin...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-namespace-admin
echo   labels:
echo     app: propdevelopment
echo     role: namespace-admin
echo rules:
echo - apiGroups: [""]
echo   resources: ["*"]
echo   verbs: ["*"]
echo - apiGroups: ["apps"]
echo   resources: ["*"]
echo   verbs: ["*"]
echo - apiGroups: ["networking.k8s.io"]
echo   resources: ["*"]
echo   verbs: ["*"]
echo - apiGroups: ["rbac.authorization.k8s.io"]
echo   resources: ["*"]
echo   verbs: ["*"]
) | kubectl apply -f -

REM 3. Developer Read-Write Role (для разработчиков)
echo Создание роли developer-read-write...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-developer-read-write
echo   labels:
echo     app: propdevelopment
echo     role: developer-read-write
echo rules:
echo - apiGroups: [""]
echo   resources: ["pods", "services", "configmaps", "persistentvolumeclaims"]
echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
echo - apiGroups: ["apps"]
echo   resources: ["deployments", "replicasets", "statefulsets"]
echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
echo - apiGroups: ["networking.k8s.io"]
echo   resources: ["ingresses"]
echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
echo - apiGroups: [""]
echo   resources: ["events"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: [""]
echo   resources: ["secrets"]
echo   verbs: ["get", "list", "watch"]
) | kubectl apply -f -

REM 4. Developer Read-Only Role (для разработчиков)
echo Создание роли developer-read-only...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-developer-read-only
echo   labels:
echo     app: propdevelopment
echo     role: developer-read-only
echo rules:
echo - apiGroups: [""]
echo   resources: ["pods", "services", "configmaps", "persistentvolumeclaims", "events"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: ["apps"]
echo   resources: ["deployments", "replicasets", "statefulsets"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: ["networking.k8s.io"]
echo   resources: ["ingresses"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: [""]
echo   resources: ["secrets"]
echo   verbs: ["get", "list", "watch"]
) | kubectl apply -f -

REM 5. Operator Read-Only Role (для операционных менеджеров)
echo Создание роли operator-read-only...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-operator-read-only
echo   labels:
echo     app: propdevelopment
echo     role: operator-read-only
echo rules:
echo - apiGroups: [""]
echo   resources: ["pods", "services", "events"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: ["apps"]
echo   resources: ["deployments"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: [""]
echo   resources: ["nodes"]
echo   verbs: ["get", "list", "watch"]
) | kubectl apply -f -

REM 6. Security Auditor Role (для аудиторов безопасности)
echo Создание роли security-auditor...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-security-auditor
echo   labels:
echo     app: propdevelopment
echo     role: security-auditor
echo rules:
echo - apiGroups: [""]
echo   resources: ["events", "pods", "services"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: ["rbac.authorization.k8s.io"]
echo   resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: [""]
echo   resources: ["secrets"]
echo   verbs: ["get", "list", "watch"]
echo - apiGroups: ["audit.k8s.io"]
echo   resources: ["events"]
echo   verbs: ["get", "list", "watch"]
) | kubectl apply -f -

REM 7. Secrets Manager Role (для DevOps инженеров)
echo Создание роли secrets-manager...
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRole
echo metadata:
echo   name: propdevelopment-secrets-manager
echo   labels:
echo     app: propdevelopment
echo     role: secrets-manager
echo rules:
echo - apiGroups: [""]
echo   resources: ["secrets", "serviceaccounts"]
echo   verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
echo - apiGroups: [""]
echo   resources: ["configmaps"]
echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
) | kubectl apply -f -

REM Создание ClusterRoleBindings для кластерных ролей
echo Создание ClusterRoleBindings...

REM Security Auditor Binding
(
echo apiVersion: rbac.authorization.k8s.io/v1
echo kind: ClusterRoleBinding
echo metadata:
echo   name: propdevelopment-security-auditor-binding
echo   labels:
echo     app: propdevelopment
echo subjects:
echo - kind: User
echo   name: admin.security@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo - kind: User
echo   name: auditor.security@propdevelopment.com
echo   apiGroup: rbac.authorization.k8s.io
echo roleRef:
echo   kind: ClusterRole
echo   name: propdevelopment-security-auditor
echo   apiGroup: rbac.authorization.k8s.io
) | kubectl apply -f -

echo.
echo === Создание ролей по доменам ===

REM Создание ролей для каждого домена с ограничениями
for %%d in (sales housing finance data) do (
    echo Создание ролей для домена: %%d
    
    REM Namespace Admin Role
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: Role
    echo metadata:
    echo   namespace: %%d
    echo   name: propdevelopment-%%d-admin
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo     role: namespace-admin
    echo rules:
    echo - apiGroups: [""]
    echo   resources: ["*"]
    echo   verbs: ["*"]
    echo - apiGroups: ["apps"]
    echo   resources: ["*"]
    echo   verbs: ["*"]
    echo - apiGroups: ["networking.k8s.io"]
    echo   resources: ["*"]
    echo   verbs: ["*"]
    echo - apiGroups: ["rbac.authorization.k8s.io"]
    echo   resources: ["roles", "rolebindings"]
    echo   verbs: ["*"]
    ) | kubectl apply -f -

    REM Developer Read-Write Role
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: Role
    echo metadata:
    echo   namespace: %%d
    echo   name: propdevelopment-%%d-developer-rw
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo     role: developer-read-write
    echo rules:
    echo - apiGroups: [""]
    echo   resources: ["pods", "services", "configmaps", "persistentvolumeclaims"]
    echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
    echo - apiGroups: ["apps"]
    echo   resources: ["deployments", "replicasets", "statefulsets"]
    echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
    echo - apiGroups: ["networking.k8s.io"]
    echo   resources: ["ingresses"]
    echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
    echo - apiGroups: [""]
    echo   resources: ["events"]
    echo   verbs: ["get", "list", "watch"]
    ) | kubectl apply -f -

    REM Developer Read-Only Role
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: Role
    echo metadata:
    echo   namespace: %%d
    echo   name: propdevelopment-%%d-developer-ro
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo     role: developer-read-only
    echo rules:
    echo - apiGroups: [""]
    echo   resources: ["pods", "services", "configmaps", "persistentvolumeclaims", "events"]
    echo   verbs: ["get", "list", "watch"]
    echo - apiGroups: ["apps"]
    echo   resources: ["deployments", "replicasets", "statefulsets"]
    echo   verbs: ["get", "list", "watch"]
    echo - apiGroups: ["networking.k8s.io"]
    echo   resources: ["ingresses"]
    echo   verbs: ["get", "list", "watch"]
    ) | kubectl apply -f -

    REM Operator Read-Only Role
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: Role
    echo metadata:
    echo   namespace: %%d
    echo   name: propdevelopment-%%d-operator-ro
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo     role: operator-read-only
    echo rules:
    echo - apiGroups: [""]
    echo   resources: ["pods", "services", "events"]
    echo   verbs: ["get", "list", "watch"]
    echo - apiGroups: ["apps"]
    echo   resources: ["deployments"]
    echo   verbs: ["get", "list", "watch"]
    ) | kubectl apply -f -

    REM Secrets Manager Role
    (
    echo apiVersion: rbac.authorization.k8s.io/v1
    echo kind: Role
    echo metadata:
    echo   namespace: %%d
    echo   name: propdevelopment-%%d-secrets-manager
    echo   labels:
    echo     app: propdevelopment
    echo     domain: %%d
    echo     role: secrets-manager
    echo rules:
    echo - apiGroups: [""]
    echo   resources: ["secrets", "serviceaccounts"]
    echo   verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
    echo - apiGroups: [""]
    echo   resources: ["configmaps"]
    echo   verbs: ["get", "list", "watch", "create", "update", "patch"]
    ) | kubectl apply -f -

    echo Роли для домена %%d созданы успешно
)

echo.
echo === Сводка созданных ролей ===
echo Кластерные роли:
echo - propdevelopment-cluster-admin
echo - propdevelopment-namespace-admin
echo - propdevelopment-developer-read-write
echo - propdevelopment-developer-read-only
echo - propdevelopment-operator-read-only
echo - propdevelopment-security-auditor
echo - propdevelopment-secrets-manager
echo.
echo Роли по доменам (для каждого из 4 доменов):
echo - propdevelopment-{domain}-admin
echo - propdevelopment-{domain}-developer-rw
echo - propdevelopment-{domain}-developer-ro
echo - propdevelopment-{domain}-operator-ro
echo - propdevelopment-{domain}-secrets-manager
echo.
echo Все роли созданы успешно!
echo Всего создано: 7 кластерных ролей + 20 ролей по доменам 