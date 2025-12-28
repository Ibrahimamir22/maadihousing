from django.contrib import admin
from .models import Subscriber


@admin.register(Subscriber)
class SubscriberAdmin(admin.ModelAdmin):
    """Admin interface for managing subscribers"""
    
    list_display = ['email', 'subscribed_at', 'is_active', 'ip_address']
    list_filter = ['is_active', 'subscribed_at']
    search_fields = ['email']
    readonly_fields = ['subscribed_at', 'ip_address']
    ordering = ['-subscribed_at']
    
    actions = ['export_emails', 'deactivate_subscribers']
    
    def export_emails(self, request, queryset):
        """Export selected emails (placeholder for CSV export)"""
        count = queryset.count()
        self.message_user(request, f'{count} subscribers selected for export.')
    export_emails.short_description = 'Export selected emails'
    
    def deactivate_subscribers(self, request, queryset):
        """Deactivate selected subscribers"""
        count = queryset.update(is_active=False)
        self.message_user(request, f'{count} subscribers deactivated.')
    deactivate_subscribers.short_description = 'Deactivate selected subscribers'

