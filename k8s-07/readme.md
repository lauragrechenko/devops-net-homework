# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

- Результаты тестирования

    ![alt text](screenshots/02.png)

- Обновления с учетом добавления Secret.

    ![alt text](screenshots/03.png)
    
    ![alt text](screenshots/01.png)

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

- Результаты тестирования
    ![alt text](screenshots/04.png)

    ![alt text](screenshots/05.png)

    Образы разных приложений были запушены в docker hub.

    ![alt text](screenshots/06.png)

- Ссылки на манифесты

  [values.yaml](https://github.com/lauragrechenko/devops-net-homework/blob/master/k8s-07/shared/demo-app-chart/values.yaml)

  [deployment.yaml](https://github.com/lauragrechenko/devops-net-homework/blob/master/k8s-07/shared/demo-app-chart/templates/deployment.yaml)

  [service.yaml](https://github.com/lauragrechenko/devops-net-homework/blob/master/k8s-07/shared/demo-app-chart/templates/service.yaml)
  
  [postgres-statefulset.yaml](https://github.com/lauragrechenko/devops-net-homework/blob/master/k8s-07/shared/demo-app-chart/templates/postgres-statefulset.yaml)
  
  [postgres-service.yaml](https://github.com/lauragrechenko/devops-net-homework/blob/master/k8s-07/shared/demo-app-chart/templates/postgres-service.yaml)
  
  [app-secret.yaml](https://github.com/lauragrechenko/devops-net-homework/blob/master/k8s-07/shared/demo-app-chart/templates/app-secret.yaml)
  

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.





