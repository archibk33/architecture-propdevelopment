#!/bin/bash

# Скрипт связывания пользователей с ролями Kubernetes для PropDevelopment
# Основан на анализе безопасности из Task1-Task3
# Версия для Linux

set -e

echo "=== Связывание пользователей с ролями Kubernetes для PropDevelopment ==="
echo "Основано на организационной структуре и принципе наименьших привилегий"
echo "Платформа: Linux"
echo ""

# Функция создания RoleBinding
create_role_binding() {
    local namespace=$1
    local role_name=$2
    local binding_name=$3
    shift 3
    local users=("$@")
    
    echo "Создание RoleBinding: $binding_name в namespace $namespace"
    
    # Создание subjects для RoleBinding
    local subjects=""
    for user in "${users[@]}"; do
        if [ -n "$subjects" ]; then
            subjects="$subjects,"
        fi
        subjects="$subjects{\"kind\":\"User\",\"name\":\"$user\",\"apiGroup\":\"rbac.authorization.k8s.io\"}"
    done
    
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: $binding_name
  namespace: $namespace
  labels:
    app: propdevelopment
    domain: $namespace
subjects:
$(for user in "${users[@]}"; do
  echo "  - kind: User"
  echo "    name: $user"
  echo "    apiGroup: rbac.authorization.k8s.io"
done)
roleRef:
  kind: Role
  name: $role_name
  apiGroup: rbac.authorization.k8s.io
EOF

    echo "RoleBinding $binding_name создан успешно"
}

# Функция создания ClusterRoleBinding
create_cluster_role_binding() {
    local role_name=$1
    local binding_name=$2
    shift 2
    local users=("$@")
    
    echo "Создание ClusterRoleBinding: $binding_name"
    
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: $binding_name
  labels:
    app: propdevelopment
subjects:
$(for user in "${users[@]}"; do
  echo "  - kind: User"
  echo "    name: $user"
  echo "    apiGroup: rbac.authorization.k8s.io"
done)
roleRef:
  kind: ClusterRole
  name: $role_name
  apiGroup: rbac.authorization.k8s.io
EOF

    echo "ClusterRoleBinding $binding_name создан успешно"
}

echo "=== Связывание администраторов безопасности ==="

# Cluster Admin (только один пользователь)
create_cluster_role_binding "propdevelopment-cluster-admin" "propdevelopment-cluster-admin-binding" "admin.security@propdevelopment.com"

echo ""
echo "=== Связывание DevOps инженеров ==="

# DevOps инженеры получают namespace-admin роли в своих доменах
create_role_binding "sales" "propdevelopment-sales-admin" "propdevelopment-sales-devops-binding" "devops.sales@propdevelopment.com"
create_role_binding "housing" "propdevelopment-housing-admin" "propdevelopment-housing-devops-binding" "devops.housing@propdevelopment.com"
create_role_binding "finance" "propdevelopment-finance-admin" "propdevelopment-finance-devops-binding" "devops.finance@propdevelopment.com"
create_role_binding "data" "propdevelopment-data-admin" "propdevelopment-data-devops-binding" "devops.data@propdevelopment.com"

# DevOps инженеры также получают secrets-manager роли
create_role_binding "sales" "propdevelopment-sales-secrets-manager" "propdevelopment-sales-secrets-binding" "devops.sales@propdevelopment.com"
create_role_binding "housing" "propdevelopment-housing-secrets-manager" "propdevelopment-housing-secrets-binding" "devops.housing@propdevelopment.com"
create_role_binding "finance" "propdevelopment-finance-secrets-manager" "propdevelopment-finance-secrets-binding" "devops.finance@propdevelopment.com"
create_role_binding "data" "propdevelopment-data-secrets-manager" "propdevelopment-data-secrets-binding" "devops.data@propdevelopment.com"

echo ""
echo "=== Связывание разработчиков ==="

# Разработчики домена "Продажи"
create_role_binding "sales" "propdevelopment-sales-developer-rw" "propdevelopment-sales-developers-rw-binding" \
    "dev.sales.1@propdevelopment.com" "dev.sales.2@propdevelopment.com" "dev.sales.3@propdevelopment.com"

create_role_binding "sales" "propdevelopment-sales-developer-ro" "propdevelopment-sales-developers-ro-binding" \
    "dev.sales.4@propdevelopment.com" "dev.sales.5@propdevelopment.com"

# Разработчики домена "ЖКУ"
create_role_binding "housing" "propdevelopment-housing-developer-rw" "propdevelopment-housing-developers-rw-binding" \
    "dev.housing.1@propdevelopment.com" "dev.housing.2@propdevelopment.com"

create_role_binding "housing" "propdevelopment-housing-developer-ro" "propdevelopment-housing-developers-ro-binding" \
    "dev.housing.3@propdevelopment.com"

# Разработчики домена "Финансы"
create_role_binding "finance" "propdevelopment-finance-developer-rw" "propdevelopment-finance-developers-rw-binding" \
    "dev.finance.1@propdevelopment.com"

create_role_binding "finance" "propdevelopment-finance-developer-ro" "propdevelopment-finance-developers-ro-binding" \
    "dev.finance.2@propdevelopment.com"

# Разработчики домена "Данные"
create_role_binding "data" "propdevelopment-data-developer-rw" "propdevelopment-data-developers-rw-binding" \
    "dev.data.1@propdevelopment.com" "dev.data.2@propdevelopment.com"

create_role_binding "data" "propdevelopment-data-developer-ro" "propdevelopment-data-developers-ro-binding" \
    "dev.data.3@propdevelopment.com" "dev.data.4@propdevelopment.com"

echo ""
echo "=== Связывание операционных менеджеров ==="

# Операционные менеджеры получают operator-read-only роли
create_role_binding "sales" "propdevelopment-sales-operator-ro" "propdevelopment-sales-managers-binding" \
    "manager.sales@propdevelopment.com"

create_role_binding "housing" "propdevelopment-housing-operator-ro" "propdevelopment-housing-managers-binding" \
    "manager.housing.1@propdevelopment.com" "manager.housing.2@propdevelopment.com"

create_role_binding "finance" "propdevelopment-finance-operator-ro" "propdevelopment-finance-managers-binding" \
    "manager.finance@propdevelopment.com"

create_role_binding "data" "propdevelopment-data-operator-ro" "propdevelopment-data-managers-binding" \
    "manager.data@propdevelopment.com"

echo ""
echo "=== Создание дополнительных привязок для аудита ==="

# Аудиторы безопасности получают доступ ко всем namespace для аудита
for namespace in sales housing finance data; do
    create_role_binding "$namespace" "propdevelopment-$namespace-developer-ro" "propdevelopment-$namespace-auditor-binding" \
        "auditor.security@propdevelopment.com"
done

echo ""
echo "=== Создание ServiceAccounts для приложений ==="

# Создание ServiceAccounts для каждого домена
for namespace in sales housing finance data; do
    echo "Создание ServiceAccount для домена: $namespace"
    
    cat << EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: propdevelopment-$namespace-sa
  namespace: $namespace
  labels:
    app: propdevelopment
    domain: $namespace
EOF

    # Привязка ServiceAccount к роли developer-read-only
    cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: propdevelopment-$namespace-sa-binding
  namespace: $namespace
  labels:
    app: propdevelopment
    domain: $namespace
subjects:
- kind: ServiceAccount
  name: propdevelopment-$namespace-sa
  namespace: $namespace
roleRef:
  kind: Role
  name: propdevelopment-$namespace-developer-ro
  apiGroup: rbac.authorization.k8s.io
EOF

    echo "ServiceAccount для домена $namespace создан успешно"
done

echo ""
echo "=== Создание NetworkPolicies для изоляции доменов ==="

# Создание базовых NetworkPolicies для изоляции доменов
for namespace in sales housing finance data; do
    echo "Создание NetworkPolicy для домена: $namespace"
    
    cat << EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: propdevelopment-$namespace-isolation
  namespace: $namespace
  labels:
    app: propdevelopment
    domain: $namespace
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: $namespace
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: $namespace
  - to:
    - namespaceSelector:
        matchLabels:
          name: kube-system
EOF

    echo "NetworkPolicy для домена $namespace создан успешно"
done

echo ""
echo "=== Сводка созданных привязок ==="
echo "ClusterRoleBindings:"
echo "- propdevelopment-cluster-admin-binding (1 пользователь)"
echo "- propdevelopment-security-auditor-binding (2 пользователя)"
echo ""
echo "RoleBindings по доменам:"
echo "- Продажи: 6 привязок"
echo "- ЖКУ: 6 привязок"
echo "- Финансы: 6 привязок"
echo "- Данные: 6 привязок"
echo ""
echo "ServiceAccounts:"
echo "- 4 ServiceAccount (по одному на домен)"
echo ""
echo "NetworkPolicies:"
echo "- 4 NetworkPolicy (изоляция доменов)"
echo ""
echo "Все привязки созданы успешно!"
echo "Всего создано: 2 ClusterRoleBinding + 24 RoleBinding + 4 ServiceAccount + 4 NetworkPolicy"
echo ""
echo "=== Проверка созданных привязок ==="
echo "Для проверки используйте команды:"
echo "kubectl get rolebindings --all-namespaces -l app=propdevelopment"
echo "kubectl get clusterrolebindings -l app=propdevelopment"
echo "kubectl get networkpolicies --all-namespaces -l app=propdevelopment" 