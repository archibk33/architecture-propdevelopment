@echo off
REM Скрипт очистки для Task5
REM Удаляет все созданные ресурсы

echo === Очистка Task5 ===
echo.

echo 1. Удаление сетевых политик:
echo ----------------------------------------
kubectl delete networkpolicies --all
echo.

echo 2. Удаление сервисов:
echo ----------------------------------------
kubectl delete service front-end-app back-end-api-app admin-front-end-app admin-back-end-api-app
echo.

echo 3. Удаление подов:
echo ----------------------------------------
kubectl delete pod front-end-app back-end-api-app admin-front-end-app admin-back-end-api-app
echo.

echo 4. Удаление тестовых подов (если есть):
echo ----------------------------------------
kubectl delete pod test-pod test-frontend test-admin --ignore-not-found=true
echo.

echo === Очистка завершена ===
echo.
echo Все ресурсы Task5 удалены.
echo Kubernetes кластер возвращен в исходное состояние. 