from django.http import JsonResponse


class HealthCheckMiddleware:
    """Answers /health before Django checks the Host header.

    Health checks are made straight to the container, so their Host isn't the
    public domain and ALLOWED_HOSTS would reject them with a 400.
    """

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        if request.path == "/health":
            return JsonResponse({"ok": True})
        return self.get_response(request)
