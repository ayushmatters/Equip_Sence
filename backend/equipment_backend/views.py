"""
Health check and utility views for production deployment
"""

from django.http import JsonResponse
from django.views.decorators.http import require_http_methods
from django.views.decorators.csrf import csrf_exempt
import sys


@csrf_exempt
@require_http_methods(["GET"])
def health_check(request):
    """
    Health check endpoint for deployment platforms (Render, Railway, etc.)
    Returns server status and basic system information
    """
    return JsonResponse({
        'status': 'healthy',
        'message': 'EquipSense Backend is running',
        'python_version': sys.version.split()[0],
        'debug_mode': False  # Never expose actual DEBUG setting
    })
