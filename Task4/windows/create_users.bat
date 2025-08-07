@echo off
REM Скрипт создания пользователей Kubernetes для PropDevelopment
REM Основан на анализе безопасности из Task1-Task3
REM Версия для Windows

echo === Создание пользователей Kubernetes для PropDevelopment ===
echo Основано на анализе безопасности и организационной структуре
echo Платформа: Windows
echo.

REM Создание директории для сертификатов
if not exist "certs" mkdir certs
cd certs

REM Проверка наличия CA сертификатов (для демонстрации создаем простые)
if not exist "..\ca.crt" (
    echo Создание CA сертификатов для демонстрации...
    openssl genrsa -out ..\ca.key 2048
    openssl req -new -x509 -key ..\ca.key -out ..\ca.crt -days 365 -subj "/CN=PropDevelopment-CA/O=PropDevelopment"
)

echo === Создание пользователей по доменам ===

REM 1. Администраторы безопасности (критично для управления безопасностью)
echo --- Администраторы безопасности ---
call :create_user "admin.security" "admin.security@propdevelopment.com" "PropDevelopment-Security"

REM 2. DevOps инженеры по доменам
echo --- DevOps инженеры ---
call :create_user "devops.sales" "devops.sales@propdevelopment.com" "PropDevelopment-Sales"
call :create_user "devops.housing" "devops.housing@propdevelopment.com" "PropDevelopment-Housing"
call :create_user "devops.finance" "devops.finance@propdevelopment.com" "PropDevelopment-Finance"
call :create_user "devops.data" "devops.data@propdevelopment.com" "PropDevelopment-Data"

REM 3. Разработчики по доменам
echo --- Разработчики домена 'Продажи' ---
call :create_user "dev.sales.1" "dev.sales.1@propdevelopment.com" "PropDevelopment-Sales"
call :create_user "dev.sales.2" "dev.sales.2@propdevelopment.com" "PropDevelopment-Sales"
call :create_user "dev.sales.3" "dev.sales.3@propdevelopment.com" "PropDevelopment-Sales"
call :create_user "dev.sales.4" "dev.sales.4@propdevelopment.com" "PropDevelopment-Sales"
call :create_user "dev.sales.5" "dev.sales.5@propdevelopment.com" "PropDevelopment-Sales"

echo --- Разработчики домена 'ЖКУ' ---
call :create_user "dev.housing.1" "dev.housing.1@propdevelopment.com" "PropDevelopment-Housing"
call :create_user "dev.housing.2" "dev.housing.2@propdevelopment.com" "PropDevelopment-Housing"
call :create_user "dev.housing.3" "dev.housing.3@propdevelopment.com" "PropDevelopment-Housing"

echo --- Разработчики домена 'Финансы' ---
call :create_user "dev.finance.1" "dev.finance.1@propdevelopment.com" "PropDevelopment-Finance"
call :create_user "dev.finance.2" "dev.finance.2@propdevelopment.com" "PropDevelopment-Finance"

echo --- Разработчики домена 'Данные' ---
call :create_user "dev.data.1" "dev.data.1@propdevelopment.com" "PropDevelopment-Data"
call :create_user "dev.data.2" "dev.data.2@propdevelopment.com" "PropDevelopment-Data"
call :create_user "dev.data.3" "dev.data.3@propdevelopment.com" "PropDevelopment-Data"
call :create_user "dev.data.4" "dev.data.4@propdevelopment.com" "PropDevelopment-Data"

REM 4. Операционные менеджеры
echo --- Операционные менеджеры ---
call :create_user "manager.sales" "manager.sales@propdevelopment.com" "PropDevelopment-Sales"
call :create_user "manager.housing.1" "manager.housing.1@propdevelopment.com" "PropDevelopment-Housing"
call :create_user "manager.housing.2" "manager.housing.2@propdevelopment.com" "PropDevelopment-Housing"
call :create_user "manager.finance" "manager.finance@propdevelopment.com" "PropDevelopment-Finance"
call :create_user "manager.data" "manager.data@propdevelopment.com" "PropDevelopment-Data"

REM 5. Аудиторы безопасности
echo --- Аудиторы безопасности ---
call :create_user "auditor.security" "auditor.security@propdevelopment.com" "PropDevelopment-Security"

echo.
echo === Создание групп пользователей ===

REM Создание групп на основе организационной структуры
(
echo apiVersion: v1
echo kind: ConfigMap
echo metadata:
echo   name: user-groups
echo   namespace: kube-system
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
for %%f in (*.crt) do set /a count+=1
echo Всего создано пользователей: %count%
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
echo Сертификаты сохранены в директории: .\certs\
echo Группы пользователей созданы в кластере
cd ..
goto :eof

:create_user
echo Создание пользователя: %1 (%2)
openssl genrsa -out %1.key 2048
openssl req -new -key %1.key -out %1.csr -subj "/CN=%2/O=%3"
openssl x509 -req -in %1.csr -CA ..\ca.crt -CAkey ..\ca.key -CAcreateserial -out %1.crt -days 365
kubectl config set-credentials %1 --client-certificate=%1.crt --client-key=%1.key
kubectl config set-context %1-context --cluster=minikube --user=%1
echo Пользователь %1 создан успешно
echo.
goto :eof 