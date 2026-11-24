from django.shortcuts import render

from home.models import Visit


def index(request):
    Visit.objects.create()
    return render(request, "home/index.html", {"visits": Visit.objects.count()})
