from rest_framework import status
from rest_framework.decorators import api_view, throttle_classes
from rest_framework.response import Response
from rest_framework.throttling import AnonRateThrottle

from .models import Subscriber
from .serializers import SubscriberSerializer


def get_client_ip(request):
    """Extract client IP address from request"""
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        return x_forwarded_for.split(',')[0].strip()
    return request.META.get('REMOTE_ADDR')


@api_view(['POST'])
@throttle_classes([AnonRateThrottle])
def subscribe(request):
    """
    Handle email subscription requests.
    
    POST /api/subscribe/
    Body: { "email": "user@example.com" }
    """
    serializer = SubscriberSerializer(data=request.data)
    
    if not serializer.is_valid():
        return Response(
            {'error': 'Please enter a valid email address'},
            status=status.HTTP_400_BAD_REQUEST
        )
    
    email = serializer.validated_data['email']
    
    # Check if already subscribed
    if Subscriber.objects.filter(email=email).exists():
        return Response(
            {'message': 'You are already subscribed!'},
            status=status.HTTP_200_OK
        )
    
    # Create new subscriber
    Subscriber.objects.create(
        email=email,
        ip_address=get_client_ip(request)
    )
    
    return Response(
        {'message': 'Successfully subscribed!'},
        status=status.HTTP_201_CREATED
    )

