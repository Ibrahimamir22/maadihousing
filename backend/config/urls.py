"""
URL configuration for maadihousing project.
"""

from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse


def health_check(request):
    """Health check endpoint for Docker/Nginx"""
    return JsonResponse({'status': 'healthy'})


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('subscribers.urls')),
    path('health/', health_check, name='health_check'),
]

