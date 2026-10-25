# Alexey Elizarov

[Сайт](https://shredeliline.duckdns.org/) — CV, проекты и контакты.

Статический HTML, CSS и JavaScript. Без сборки и npm-зависимостей.

## Что редактировать

| Файл | Содержимое |
| --- | --- |
| `public/index.html` | Текст, ссылки, метаданные |
| `public/assets/ice.css` | Цвета, сетка, адаптивность |
| `public/assets/main.js` | Копирование email |
| `public/assets/Alexey-Elizarov-CV.pdf` | Английское CV |
| `deploy/` | Docker Compose и Caddy для действующего сервера |

## Локальный просмотр

```sh
python -m http.server 8873 --bind 127.0.0.1 --directory public
```

Открыть http://127.0.0.1:8873/. Правки видны после обновления страницы.

## Обновление сайта

Сначала закоммитить изменения и отправить их в `main`.
На сервере исходники находятся в `/srv/alexey-cloud/apps/personal-site/source`.

```sh
cd /srv/alexey-cloud/apps/personal-site/source
git pull --ff-only origin main
./scripts/deploy.sh /srv/alexey-cloud/apps/personal-site
```

Скрипт создаёт отдельный релиз, сохраняет предыдущую конфигурацию и проверяет
состояние контейнера. При ошибке запуска возвращает предыдущую конфигурацию.
После обновления проверить сайт и ссылку на CV.

Пуш в GitHub сам по себе не запускает публикацию.

## Сервер

Сайт обслуживает Caddy в Docker. HTTPS выдаёт и продлевает Let's Encrypt.
`deploy/compose.yaml` настроен на текущий публичный IP и UID владельца сервера.
Скрипт публикации рассчитан на уже настроенный сервер, не на новую установку.

Рабочий `.env`, сертификаты в `caddy-data/`, настройки в `caddy-config/`
и SSH-ключи хранятся вне репозитория. При обновлении сохранять эти каталоги.
Пример переменных — `deploy/.env.example`.
