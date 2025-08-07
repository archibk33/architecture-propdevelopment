#!/bin/bash

# Скрипт создания пользователей Kubernetes для PropDevelopment
# Основан на анализе безопасности из Task1-Task3
# Версия для Linux

set -e

echo "=== Создание пользователей Kubernetes для PropDevelopment ==="
echo "Основано на анализе безопасности и организационной структуре"
echo "Платформа: Linux"
echo ""

# Создание директории для сертификатов
mkdir -p ./certs
cd ./certs

# Функция создания пользователя
create_user() {
    local username=$1
    local common_name=$2
    local organization=$3
    
    echo "Создание пользователя: $username ($common_name)"
    
    # Генерация приватного ключа
    openssl genrsa -out ${username}.key 2048
    
    # Создание CSR (Certificate Signing Request)
    openssl req -new -key ${username}.key -out ${username}.csr -subj "/CN=${common_name}/O=${organization}"
    
    # Подписание сертификата (в продакшене должен подписывать CA)
    openssl x509 -req -in ${username}.csr -CA ../ca.crt -CAkey ../ca.key -CAcreateserial -out ${username}.crt -days 365
    
    # Создание kubeconfig
    kubectl config set-credentials ${username} --client-certificate=${username}.crt --client-key=${username}.key
    kubectl config set-context ${username}-context --cluster=minikube --user=${username}
    
    echo "Пользователь $username создан успешно"
    echo ""
}

# Проверка наличия CA сертификатов (для демонстрации создаем простые)
if [ ! -f ../ca.crt ] || [ ! -f ../ca.key ]; then
    echo "Создание CA сертификатов для демонстрации..."
    openssl genrsa -out ../ca.key 2048
    openssl req -new -x509 -key ../ca.key -out ../ca.crt -days 365 -subj "/CN=PropDevelopment-CA/O=PropDevelopment"
fi

echo "=== Создание пользователей по доменам ==="

# 1. Администраторы безопасности (критично для управления безопасностью)
echo "--- Администраторы безопасности ---"
create_user "admin.security" "admin.security@propdevelopment.com" "PropDevelopment-Security"

# 2. DevOps инженеры по доменам
echo "--- DevOps инженеры ---"
create_user "devops.sales" "devops.sales@propdevelopment.com" "PropDevelopment-Sales"
create_user "devops.housing" "devops.housing@propdevelopment.com" "PropDevelopment-Housing"
create_user "devops.finance" "devops.finance@propdevelopment.com" "PropDevelopment-Finance"
create_user "devops.data" "devops.data@propdevelopment.com" "PropDevelopment-Data"

# 3. Разработчики по доменам
echo "--- Разработчики домена 'Продажи' ---"
create_user "dev.sales.1" "dev.sales.1@propdevelopment.com" "PropDevelopment-Sales"
create_user "dev.sales.2" "dev.sales.2@propdevelopment.com" "PropDevelopment-Sales"
create_user "dev.sales.3" "dev.sales.3@propdevelopment.com" "PropDevelopment-Sales"
create_user "dev.sales.4" "dev.sales.4@propdevelopment.com" "PropDevelopment-Sales"
create_user "dev.sales.5" "dev.sales.5@propdevelopment.com" "PropDevelopment-Sales"

echo "--- Разработчики домена 'ЖКУ' ---"
create_user "dev.housing.1" "dev.housing.1@propdevelopment.com" "PropDevelopment-Housing"
create_user "dev.housing.2" "dev.housing.2@propdevelopment.com" "PropDevelopment-Housing"
create_user "dev.housing.3" "dev.housing.3@propdevelopment.com" "PropDevelopment-Housing"

echo "--- Разработчики домена 'Финансы' ---"
create_user "dev.finance.1" "dev.finance.1@propdevelopment.com" "PropDevelopment-Finance"
create_user "dev.finance.2" "dev.finance.2@propdevelopment.com" "PropDevelopment-Finance"

echo "--- Разработчики домена 'Данные' ---"
create_user "dev.data.1" "dev.data.1@propdevelopment.com" "PropDevelopment-Data"
create_user "dev.data.2" "dev.data.2@propdevelopment.com" "PropDevelopment-Data"
create_user "dev.data.3" "dev.data.3@propdevelopment.com" "PropDevelopment-Data"
create_user "dev.data.4" "dev.data.4@propdevelopment.com" "PropDevelopment-Data"

# 4. Операционные менеджеры
echo "--- Операционные менеджеры ---"
create_user "manager.sales" "manager.sales@propdevelopment.com" "PropDevelopment-Sales"
create_user "manager.housing.1" "manager.housing.1@propdevelopment.com" "PropDevelopment-Housing"
create_user "manager.housing.2" "manager.housing.2@propdevelopment.com" "PropDevelopment-Housing"
create_user "manager.finance" "manager.finance@propdevelopment.com" "PropDevelopment-Finance"
create_user "manager.data" "manager.data@propdevelopment.com" "PropDevelopment-Data"

# 5. Аудиторы безопасности
echo "--- Аудиторы безопасности ---"
create_user "auditor.security" "auditor.security@propdevelopment.com" "PropDevelopment-Security"

echo ""
echo "=== Создание групп пользователей ==="

# Создание групп на основе организационной структуры
cat << EOF > ../user-groups.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: user-groups
  namespace: kube-system
data:
  # Группы по доменам (соответствуют организационной структуре)
  sales-group: "dev.sales.1,dev.sales.2,dev.sales.3,dev.sales.4,dev.sales.5,devops.sales,manager.sales"
  housing-group: "dev.housing.1,dev.housing.2,dev.housing.3,devops.housing,manager.housing.1,manager.housing.2"
  finance-group: "dev.finance.1,dev.finance.2,devops.finance,manager.finance"
  data-group: "dev.data.1,dev.data.2,dev.data.3,dev.data.4,devops.data,manager.data"
  
  # Группы по ролям
  security-admin-group: "admin.security,auditor.security"
  devops-group: "devops.sales,devops.housing,devops.finance,devops.data"
  developers-group: "dev.sales.1,dev.sales.2,dev.sales.3,dev.sales.4,dev.sales.5,dev.housing.1,dev.housing.2,dev.housing.3,dev.finance.1,dev.finance.2,dev.data.1,dev.data.2,dev.data.3,dev.data.4"
  managers-group: "manager.sales,manager.housing.1,manager.housing.2,manager.finance,manager.data"
EOF

kubectl apply -f ../user-groups.yaml

echo ""
echo "=== Сводка созданных пользователей ==="
echo "Всего создано пользователей: $(ls *.crt | wc -l)"
echo ""
echo "Группы пользователей:"
echo "- Администраторы безопасности: 2"
echo "- DevOps инженеры: 4"
echo "- Разработчики: 14"
echo "- Операционные менеджеры: 5"
echo ""
echo "Домены:"
echo "- Продажи: 8 пользователей"
echo "- ЖКУ: 6 пользователей" 
echo "- Финансы: 4 пользователя"
echo "- Данные: 7 пользователей"
echo ""
echo "Все пользователи созданы успешно!"
echo "Сертификаты сохранены в директории: ./certs/"
echo "Группы пользователей созданы в кластере" 