#!/bin/bash

# Скрипт создания ролей Kubernetes для PropDevelopment
# Основан на анализе безопасности из Task1-Task3
# Версия для Linux

set -e

echo "=== Создание ролей Kubernetes для PropDevelopment ==="
echo "Основано на анализе безопасности и принципе наименьших привилегий"
echo "Платформа: Linux"
echo ""

# Создание namespace для доменов
echo "Создание namespace для доменов..."
kubectl create namespace sales --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace housing --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace finance --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace data --dry-run=client -o yaml | kubectl apply -f -

echo "Namespace созданы успешно"
echo ""

# 1. Cluster Admin Role (критично для управления безопасностью)
echo "Создание роли cluster-admin..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-cluster-admin
  labels:
    app: propdevelopment
    role: cluster-admin
rules:
- apiGroups: ["*"]
  resources: ["*"]
  verbs: ["*"]
EOF

# 2. Namespace Admin Role (для DevOps инженеров)
echo "Создание роли namespace-admin..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-namespace-admin
  labels:
    app: propdevelopment
    role: namespace-admin
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["networking.k8s.io"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["*"]
  verbs: ["*"]
EOF

# 3. Developer Read-Write Role (для разработчиков)
echo "Создание роли developer-read-write..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-developer-read-write
  labels:
    app: propdevelopment
    role: developer-read-write
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: [""]
  resources: ["events"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "watch"]  # Только чтение секретов
EOF

# 4. Developer Read-Only Role (для разработчиков)
echo "Создание роли developer-read-only..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-developer-read-only
  labels:
    app: propdevelopment
    role: developer-read-only
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "persistentvolumeclaims", "events"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "watch"]  # Только чтение секретов
EOF

# 5. Operator Read-Only Role (для операционных менеджеров)
echo "Создание роли operator-read-only..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-operator-read-only
  labels:
    app: propdevelopment
    role: operator-read-only
rules:
- apiGroups: [""]
  resources: ["pods", "services", "events"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get", "list", "watch"]
EOF

# 6. Security Auditor Role (для аудиторов безопасности)
echo "Создание роли security-auditor..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-security-auditor
  labels:
    app: propdevelopment
    role: security-auditor
rules:
- apiGroups: [""]
  resources: ["events", "pods", "services"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["roles", "rolebindings", "clusterroles", "clusterrolebindings"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["secrets"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["audit.k8s.io"]
  resources: ["events"]
  verbs: ["get", "list", "watch"]
EOF

# 7. Secrets Manager Role (для DevOps инженеров)
echo "Создание роли secrets-manager..."
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: propdevelopment-secrets-manager
  labels:
    app: propdevelopment
    role: secrets-manager
rules:
- apiGroups: [""]
  resources: ["secrets", "serviceaccounts"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
EOF

# Создание ClusterRoleBindings для кластерных ролей
echo "Создание ClusterRoleBindings..."

# Security Auditor Binding
cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: propdevelopment-security-auditor-binding
  labels:
    app: propdevelopment
subjects:
- kind: User
  name: admin.security@propdevelopment.com
  apiGroup: rbac.authorization.k8s.io
- kind: User
  name: auditor.security@propdevelopment.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: propdevelopment-security-auditor
  apiGroup: rbac.authorization.k8s.io
EOF

echo ""
echo "=== Создание ролей по доменам ==="

# Создание ролей для каждого домена с ограничениями
for namespace in sales housing finance data; do
    echo "Создание ролей для домена: $namespace"
    
    # Namespace Admin Role
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $namespace
  name: propdevelopment-$namespace-admin
  labels:
    app: propdevelopment
    domain: $namespace
    role: namespace-admin
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["networking.k8s.io"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["roles", "rolebindings"]
  verbs: ["*"]
EOF

    # Developer Read-Write Role
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $namespace
  name: propdevelopment-$namespace-developer-rw
  labels:
    app: propdevelopment
    domain: $namespace
    role: developer-read-write
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "persistentvolumeclaims"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
- apiGroups: [""]
  resources: ["events"]
  verbs: ["get", "list", "watch"]
EOF

    # Developer Read-Only Role
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $namespace
  name: propdevelopment-$namespace-developer-ro
  labels:
    app: propdevelopment
    domain: $namespace
    role: developer-read-only
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "persistentvolumeclaims", "events"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses"]
  verbs: ["get", "list", "watch"]
EOF

    # Operator Read-Only Role
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $namespace
  name: propdevelopment-$namespace-operator-ro
  labels:
    app: propdevelopment
    domain: $namespace
    role: operator-read-only
rules:
- apiGroups: [""]
  resources: ["pods", "services", "events"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps"]
  resources: ["deployments"]
  verbs: ["get", "list", "watch"]
EOF

    # Secrets Manager Role
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: $namespace
  name: propdevelopment-$namespace-secrets-manager
  labels:
    app: propdevelopment
    domain: $namespace
    role: secrets-manager
rules:
- apiGroups: [""]
  resources: ["secrets", "serviceaccounts"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["configmaps"]
  verbs: ["get", "list", "watch", "create", "update", "patch"]
EOF

    echo "Роли для домена $namespace созданы успешно"
done

echo ""
echo "=== Сводка созданных ролей ==="
echo "Кластерные роли:"
echo "- propdevelopment-cluster-admin"
echo "- propdevelopment-namespace-admin"
echo "- propdevelopment-developer-read-write"
echo "- propdevelopment-developer-read-only"
echo "- propdevelopment-operator-read-only"
echo "- propdevelopment-security-auditor"
echo "- propdevelopment-secrets-manager"
echo ""
echo "Роли по доменам (для каждого из 4 доменов):"
echo "- propdevelopment-{domain}-admin"
echo "- propdevelopment-{domain}-developer-rw"
echo "- propdevelopment-{domain}-developer-ro"
echo "- propdevelopment-{domain}-operator-ro"
echo "- propdevelopment-{domain}-secrets-manager"
echo ""
echo "Все роли созданы успешно!"
echo "Всего создано: 7 кластерных ролей + 20 ролей по доменам" 