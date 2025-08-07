@echo off
REM Упрощенный скрипт создания пользователей Kubernetes для PropDevelopment
REM Версия для Windows без OpenSSL
REM Использует встроенные возможности kubectl

echo === Создание пользователей Kubernetes для PropDevelopment ===
echo Упрощенная версия без OpenSSL
echo Платформа: Windows
echo.

REM Создание директории для конфигураций
if not exist "configs" mkdir configs
cd configs

echo === Создание пользователей по доменам ===

REM 1. Администраторы безопасности
echo --- Администраторы безопасности ---
call :create_simple_user "admin.security" "admin.security@propdevelopment.com" "PropDevelopment-Security"

REM 2. DevOps инженеры по доменам
echo --- DevOps инженеры ---
call :create_simple_user "devops.sales" "devops.sales@propdevelopment.com" "PropDevelopment-Sales"
call :create_simple_user "devops.housing" "devops.housing@propdevelopment.com" "PropDevelopment-Housing"
call :create_simple_user "devops.finance" "devops.finance@propdevelopment.com" "PropDevelopment-Finance"
call :create_simple_user "devops.data" "devops.data@propdevelopment.com" "PropDevelopment-Data"

REM 3. Разработчики по доменам
echo --- Разработчики домена 'Продажи' ---
call :create_simple_user "dev.sales.1" "dev.sales.1@propdevelopment.com" "PropDevelopment-Sales"
call :create_simple_user "dev.sales.2" "dev.sales.2@propdevelopment.com" "PropDevelopment-Sales"
call :create_simple_user "dev.sales.3" "dev.sales.3@propdevelopment.com" "PropDevelopment-Sales"
call :create_simple_user "dev.sales.4" "dev.sales.4@propdevelopment.com" "PropDevelopment-Sales"
call :create_simple_user "dev.sales.5" "dev.sales.5@propdevelopment.com" "PropDevelopment-Sales"

echo --- Разработчики домена 'ЖКУ' ---
call :create_simple_user "dev.housing.1" "dev.housing.1@propdevelopment.com" "PropDevelopment-Housing"
call :create_simple_user "dev.housing.2" "dev.housing.2@propdevelopment.com" "PropDevelopment-Housing"
call :create_simple_user "dev.housing.3" "dev.housing.3@propdevelopment.com" "PropDevelopment-Housing"

echo --- Разработчики домена 'Финансы' ---
call :create_simple_user "dev.finance.1" "dev.finance.1@propdevelopment.com" "PropDevelopment-Finance"
call :create_simple_user "dev.finance.2" "dev.finance.2@propdevelopment.com" "PropDevelopment-Finance"

echo --- Разработчики домена 'Данные' ---
call :create_simple_user "dev.data.1" "dev.data.1@propdevelopment.com" "PropDevelopment-Data"
call :create_simple_user "dev.data.2" "dev.data.2@propdevelopment.com" "PropDevelopment-Data"
call :create_simple_user "dev.data.3" "dev.data.3@propdevelopment.com" "PropDevelopment-Data"
call :create_simple_user "dev.data.4" "dev.data.4@propdevelopment.com" "PropDevelopment-Data"

REM 4. Операционные менеджеры
echo --- Операционные менеджеры ---
call :create_simple_user "manager.sales" "manager.sales@propdevelopment.com" "PropDevelopment-Sales"
call :create_simple_user "manager.housing.1" "manager.housing.1@propdevelopment.com" "PropDevelopment-Housing"
call :create_simple_user "manager.housing.2" "manager.housing.2@propdevelopment.com" "PropDevelopment-Housing"
call :create_simple_user "manager.finance" "manager.finance@propdevelopment.com" "PropDevelopment-Finance"
call :create_simple_user "manager.data" "manager.data@propdevelopment.com" "PropDevelopment-Data"

REM 5. Аудиторы безопасности
echo --- Аудиторы безопасности ---
call :create_simple_user "auditor.security" "auditor.security@propdevelopment.com" "PropDevelopment-Security"

echo.
echo === Создание групп пользователей ===

REM Создание групп на основе организационной структуры
(
echo apiVersion: v1
echo kind: ConfigMap
echo metadata:
echo   name: user-groups
echo   namespace: kube-system
echo   labels:
echo     app: propdevelopment
echo data:
echo   # Группы по доменам (соответствуют организационной структуре)
echo   sales-group: "dev.sales.1,dev.sales.2,dev.sales.3,dev.sales.4,dev.sales.5,devops.sales,manager.sales"
echo   housing-group: "dev.housing.1,dev.housing.2,dev.housing.3,devops.housing,manager.housing.1,manager.housing.2"
echo   finance-group: "dev.finance.1,dev.finance.2,devops.finance,manager.finance"
echo   data-group: "dev.data.1,dev.data.2,dev.data.3,dev.data.4,devops.data,manager.data"
echo   
echo   # Группы по ролям
echo   security-admin-group: "admin.security,auditor.security"
echo   devops-group: "devops.sales,devops.housing,devops.finance,devops.data"
echo   developers-group: "dev.sales.1,dev.sales.2,dev.sales.3,dev.sales.4,dev.sales.5,dev.housing.1,dev.housing.2,dev.housing.3,dev.finance.1,dev.finance.2,dev.data.1,dev.data.2,dev.data.3,dev.data.4"
echo   managers-group: "manager.sales,manager.housing.1,manager.housing.2,manager.finance,manager.data"
) > ..\user-groups.yaml

kubectl apply -f ..\user-groups.yaml

echo.
echo === Сводка созданных пользователей ===
echo Всего создано пользователей: 25
echo.
echo Группы пользователей:
echo - Администраторы безопасности: 2
echo - DevOps инженеры: 4
echo - Разработчики: 14
echo - Операционные менеджеры: 5
echo.
echo Домены:
echo - Продажи: 8 пользователей
echo - ЖКУ: 6 пользователей
echo - Финансы: 4 пользователя
echo - Данные: 7 пользователей
echo.
echo Все пользователи созданы успешно!
echo Конфигурации сохранены в директории: .\configs\
echo Группы пользователей созданы в кластере
cd ..
goto :eof

:create_simple_user
echo Создание пользователя: %1 (%2)
REM Создаем конфигурационный файл для пользователя
(
echo apiVersion: v1
echo kind: ServiceAccount
echo metadata:
echo   name: %1
echo   namespace: default
echo   labels:
echo     app: propdevelopment
echo     user: %1
echo     domain: %3
echo ---
echo apiVersion: v1
echo kind: Secret
echo metadata:
echo   name: %1-token
echo   namespace: default
echo   labels:
echo     app: propdevelopment
echo     user: %1
echo   annotations:
echo     kubernetes.io/service-account.name: %1
echo type: kubernetes.io/service-account-token
) > %1-config.yaml

kubectl apply -f %1-config.yaml
echo Пользователь %1 создан успешно
echo.
goto :eof 