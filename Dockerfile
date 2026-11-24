# Build: install the locked dependencies into a virtualenv with uv, and collect static files.
FROM python:3.14-slim AS build
COPY --from=ghcr.io/astral-sh/uv:0.13 /uv /bin/uv
ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy UV_PYTHON_DOWNLOADS=never
WORKDIR /app
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-dev --no-install-project
COPY . .
# collectstatic needs settings to load, not a real secret.
RUN DJANGO_SECRET_KEY=build-only .venv/bin/python manage.py collectstatic --noinput

# Run: the virtualenv, the code and the static files, as a non-root user.
FROM python:3.14-slim
ENV PYTHONUNBUFFERED=1 PATH="/app/.venv/bin:$PATH"
WORKDIR /app
RUN useradd --create-home --uid 1000 app
COPY --from=build /app /app
USER app
EXPOSE 8000
# [::]:8000 listens on IPv6 and IPv4.
CMD ["gunicorn", "config.wsgi:application", "--bind", "[::]:8000", "--workers", "2", "--access-logfile", "-"]
