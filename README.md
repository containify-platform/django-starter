# Django starter

A small [Django](https://www.djangoproject.com/) project with Postgres, Gunicorn and
WhiteNoise, ready to deploy on [Containify](https://containify.net).

- `/`: a page that counts its visits in Postgres
- `/admin/`: the Django admin, its static files served by WhiteNoise
- `/health`: the health check, answered before `ALLOWED_HOSTS` is checked

Dependencies are managed with [uv](https://docs.astral.sh/uv/) (`pyproject.toml` and `uv.lock`).

## Run it locally

```bash
docker run -d --name pg -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=app -p 5432:5432 postgres:17
export DATABASE_URL=postgresql://postgres:postgres@localhost:5432/app DJANGO_DEBUG=1
uv sync
uv run python manage.py migrate
uv run python manage.py runserver
```

Then open http://localhost:8000.

## Deploy on Containify

Deploy the **Django starter** template from the Containify catalogue. It adds this app and a
private Postgres database, generates `DJANGO_SECRET_KEY`, and runs
`python manage.py migrate --noinput` as the pre-deploy command on every deploy.

### Settings

| Variable | What it does |
| --- | --- |
| `DATABASE_URL` | The Postgres connection string, read by `dj-database-url` |
| `DJANGO_SECRET_KEY` | Django's secret key |
| `DJANGO_DEBUG` | `1` turns on debug mode; leave it unset in production |
| `DJANGO_ALLOWED_HOSTS` | Comma-separated hosts; defaults to `CONTAINIFY_PUBLIC_DOMAIN` |
| `DJANGO_CSRF_TRUSTED_ORIGINS` | Comma-separated origins; defaults to `https://` + the public domain |

Create an admin user in the app's Console with `python manage.py createsuperuser`.

## License

MIT
