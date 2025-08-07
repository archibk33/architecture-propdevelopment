# Таблица ролей и полномочий Kubernetes для PropDevelopment

## Обоснование выбора ролей

Роли созданы на основе:
1. **Организационной структуры** - 4 домена компании (Продажи, ЖКУ, Финансы, Данные)
2. **Проблем безопасности** из Task1-Task3 - множественные точки доступа, отсутствие централизации
3. **Принципа наименьших привилегий** - каждый пользователь получает только необходимые права
4. **Требований аудита** - все действия с критичными ресурсами логируются

## Таблица ролей

| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **propdevelopment-cluster-admin** | Полный доступ ко всем ресурсам кластера (`*` на все ресурсы) | Администраторы безопасности (admin.security@propdevelopment.com) |
| **propdevelopment-namespace-admin** | Полный доступ к namespace (create, read, update, delete на все ресурсы в namespace) | DevOps инженеры по доменам (devops.sales, devops.housing, devops.finance, devops.data) |
| **propdevelopment-developer-read-write** | Чтение и запись в namespace (create, read, update на Deployments, Services, ConfigMaps, без доступа к Secrets) | Разработчики по доменам (dev.sales.1-5, dev.housing.1-3, dev.finance.1-2, dev.data.1-4) |
| **propdevelopment-developer-read-only** | Только чтение в namespace (read на все ресурсы кроме Secrets) | Разработчики по доменам (для мониторинга и отладки) |
| **propdevelopment-operator-read-only** | Ограниченное чтение (read на Pods, Services, Events, Deployments) | Операционные менеджеры (manager.sales, manager.housing.1-2, manager.finance, manager.data) |
| **propdevelopment-security-auditor** | Чтение логов и событий (read на Events, Logs, Audit trails, RBAC ресурсы) | Администраторы безопасности (admin.security, auditor.security) |
| **propdevelopment-secrets-manager** | Управление секретами (create, read, update, delete на Secrets, ServiceAccounts) | DevOps инженеры по доменам |

## Детализация ролей по доменам

### Домен "Продажи" (namespace: sales)
| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **propdevelopment-sales-admin** | Полный доступ к namespace sales | DevOps инженер продаж (devops.sales@propdevelopment.com) |
| **propdevelopment-sales-developer-rw** | Чтение и запись в namespace sales | Разработчики продаж (dev.sales.1, dev.sales.2, dev.sales.3) |
| **propdevelopment-sales-developer-ro** | Только чтение в namespace sales | Разработчики продаж (dev.sales.4, dev.sales.5) |
| **propdevelopment-sales-operator-ro** | Ограниченное чтение в namespace sales | Менеджер продаж (manager.sales@propdevelopment.com) |
| **propdevelopment-sales-secrets-manager** | Управление секретами в namespace sales | DevOps инженер продаж (devops.sales@propdevelopment.com) |

### Домен "ЖКУ" (namespace: housing)
| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **propdevelopment-housing-admin** | Полный доступ к namespace housing | DevOps инженер ЖКУ (devops.housing@propdevelopment.com) |
| **propdevelopment-housing-developer-rw** | Чтение и запись в namespace housing | Разработчики ЖКУ (dev.housing.1, dev.housing.2) |
| **propdevelopment-housing-developer-ro** | Только чтение в namespace housing | Разработчик ЖКУ (dev.housing.3) |
| **propdevelopment-housing-operator-ro** | Ограниченное чтение в namespace housing | Менеджеры ЖКУ (manager.housing.1, manager.housing.2) |
| **propdevelopment-housing-secrets-manager** | Управление секретами в namespace housing | DevOps инженер ЖКУ (devops.housing@propdevelopment.com) |

### Домен "Финансы" (namespace: finance)
| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **propdevelopment-finance-admin** | Полный доступ к namespace finance | DevOps инженер финансов (devops.finance@propdevelopment.com) |
| **propdevelopment-finance-developer-rw** | Чтение и запись в namespace finance | Разработчик финансов (dev.finance.1) |
| **propdevelopment-finance-developer-ro** | Только чтение в namespace finance | Разработчик финансов (dev.finance.2) |
| **propdevelopment-finance-operator-ro** | Ограниченное чтение в namespace finance | Менеджер финансов (manager.finance@propdevelopment.com) |
| **propdevelopment-finance-secrets-manager** | Управление секретами в namespace finance | DevOps инженер финансов (devops.finance@propdevelopment.com) |

### Домен "Данные" (namespace: data)
| Роль | Права роли | Группы пользователей |
|------|------------|---------------------|
| **propdevelopment-data-admin** | Полный доступ к namespace data | DevOps инженеры данных (devops.data@propdevelopment.com) |
| **propdevelopment-data-developer-rw** | Чтение и запись в namespace data | Разработчики данных (dev.data.1, dev.data.2) |
| **propdevelopment-data-developer-ro** | Только чтение в namespace data | Разработчики данных (dev.data.3, dev.data.4) |
| **propdevelopment-data-operator-ro** | Ограниченное чтение в namespace data | Менеджер данных (manager.data@propdevelopment.com) |
| **propdevelopment-data-secrets-manager** | Управление секретами в namespace data | DevOps инженеры данных (devops.data@propdevelopment.com) |

## Обоснование выбора прав

### Критичные права (только для администраторов безопасности):
- **Полный доступ к кластеру** - необходимо для управления безопасностью и реагирования на инциденты
- **Доступ к секретам** - защита критичных данных (пароли, API ключи, персональные данные)

### Права DevOps инженеров:
- **Управление namespace** - развертывание и настройка сервисов
- **Управление секретами** - защита критичных данных в рамках своего домена

### Права разработчиков:
- **Чтение и запись** - разработка и отладка приложений
- **Ограниченный доступ к секретам** - только чтение для работы с приложениями

### Права операционных менеджеров:
- **Только чтение** - контроль работы систем без возможности изменений
- **Доступ к событиям** - мониторинг состояния систем

## Соответствие требованиям безопасности

 **Принцип наименьших привилегий** - каждая роль имеет минимально необходимые права
 **Разграничение по доменам** - изоляция данных между бизнес-доменами
 **Аудит действий** - все критические операции логируются
 **Защита секретов** - ограниченный доступ к критичным данным
 **Централизация управления** - единая система ролей и прав 