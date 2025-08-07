@echo off
REM Скрипт очистки RBAC системы PropDevelopment
REM Удаляет все созданные ресурсы

echo === Очистка RBAC системы PropDevelopment ===
echo.

echo 1. Удаление NetworkPolicies:
echo ----------------------------------------
kubectl delete networkpolicies --all-namespaces -l app=propdevelopment
echo.

echo 2. Удаление RoleBinding'ов:
echo ----------------------------------------
kubectl delete rolebindings --all-namespaces -l app=propdevelopment
echo.

echo 3. Удаление ClusterRoleBinding'ов:
echo ----------------------------------------
kubectl delete clusterrolebindings -l app=propdevelopment
echo.

echo 4. Удаление Role'ов по доменам:
echo ----------------------------------------
kubectl delete roles --all-namespaces -l app=propdevelopment
echo.

echo 5. Удаление ClusterRole'ов:
echo ----------------------------------------
kubectl delete clusterroles -l app=propdevelopment
echo.

echo 6. Удаление ServiceAccount'ов:
echo ----------------------------------------
kubectl delete serviceaccounts -l app=propdevelopment
echo.

echo 7. Удаление namespace'ов:
echo ----------------------------------------
kubectl delete namespace sales housing finance data
echo.

echo 8. Удаление ConfigMap'ов:
echo ----------------------------------------
kubectl delete configmap user-groups -n kube-system
echo.

echo 9. Очистка локальных файлов:
echo ----------------------------------------
if exist "configs" rmdir /s configs
if exist "user-groups.yaml" del user-groups.yaml
echo.

echo === Очистка завершена ===
echo.
echo Все ресурсы RBAC системы PropDevelopment удалены.
echo Kubernetes кластер возвращен в исходное состояние. 