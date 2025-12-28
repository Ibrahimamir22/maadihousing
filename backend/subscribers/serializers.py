from rest_framework import serializers
from .models import Subscriber


class SubscriberSerializer(serializers.ModelSerializer):
    """Serializer for the Subscriber model"""
    
    class Meta:
        model = Subscriber
        fields = ['email']
    
    def validate_email(self, value):
        """Normalize email to lowercase"""
        return value.lower().strip()

