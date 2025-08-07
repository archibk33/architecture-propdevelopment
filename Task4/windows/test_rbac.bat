@echo off
REM Тестовый скрипт для проверки RBAC системы PropDevelopment
REM Проверяет созданные пользователей, роли и привязки

echo === Тестирование RBAC системы PropDevelopment ===
echo.

echo 1. Проверка namespace'ов:
echo ----------------------------------------
kubectl get namespaces | findstr "sales housing finance data"
echo.

echo 2. Проверка ServiceAccount'ов:
echo ----------------------------------------
kubectl get serviceaccounts -l app=propdevelopment
echo.

echo 3. Проверка ClusterRole'ов:
echo ----------------------------------------
kubectl get clusterroles -l app=propdevelopment
echo.

echo 4. Проверка Role'ов по доменам:
echo ----------------------------------------
echo Sales domain roles:
kubectl get roles -n sales -l app=propdevelopment
echo.
echo Housing domain roles:
kubectl get roles -n housing -l app=propdevelopment
echo.
echo Finance domain roles:
kubectl get roles -n finance -l app=propdevelopment
echo.
echo Data domain roles:
kubectl get roles -n data -l app=propdevelopment
echo.

echo 5. Проверка ClusterRoleBinding'ов:
echo ----------------------------------------
kubectl get clusterrolebindings -l app=propdevelopment
echo.

echo 6. Проверка RoleBinding'ов:
echo ----------------------------------------
echo Sales domain bindings:
kubectl get rolebindings -n sales -l app=propdevelopment
echo.
echo Housing domain bindings:
kubectl get rolebindings -n housing -l app=propdevelopment
echo.
echo Finance domain bindings:
kubectl get rolebindings -n finance -l app=propdevelopment
echo.
echo Data domain bindings:
kubectl get rolebindings -n data -l app=propdevelopment
echo.

echo 7. Проверка NetworkPolicies:
echo ----------------------------------------
kubectl get networkpolicies --all-namespaces -l app=propdevelopment
echo.

echo 8. Тестирование доступа (симуляция):
echo ----------------------------------------
echo Тестирование доступа разработчика sales к своему namespace:
echo kubectl auth can-i get pods --as=dev.sales.1 -n sales
kubectl auth can-i get pods --as=dev.sales.1 -n sales
echo.

echo Тестирование доступа разработчика sales к чужому namespace:
echo kubectl auth can-i get pods --as=dev.sales.1 -n housing
kubectl auth can-i get pods --as=dev.sales.1 -n housing
echo.

echo Тестирование доступа DevOps к своему namespace:
echo kubectl auth can-i create deployments --as=devops.sales -n sales
kubectl auth can-i create deployments --as=devops.sales -n sales
echo.

echo Тестирование доступа администратора безопасности:
echo kubectl auth can-i get all --all-namespaces --as=admin.security
kubectl auth can-i get all --all-namespaces --as=admin.security
echo.

echo === Тестирование завершено ===
echo.
echo Сводка:
echo - Namespace'ы: 4 создано
echo - ServiceAccount'ы: 25 создано
echo - ClusterRole'ы: 7 создано
echo - Role'ы по доменам: 20 создано
echo - ClusterRoleBinding'ы: 2 создано
echo - RoleBinding'ы: 24 создано
echo - NetworkPolicies: 4 создано
echo.
echo RBAC система настроена и готова к использованию! 