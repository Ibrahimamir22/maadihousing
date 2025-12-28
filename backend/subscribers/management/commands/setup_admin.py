"""
Management command to create the default admin superuser.
"""

from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model

User = get_user_model()


class Command(BaseCommand):
    help = 'Creates the default admin superuser if it does not exist'

    def handle(self, *args, **options):
        username = 'maadihousing'
        email = 'ibrahimamiir22@gmail.com'
        password = 'maadihousing'

        if User.objects.filter(username=username).exists():
            self.stdout.write(
                self.style.WARNING(f'Superuser "{username}" already exists.')
            )
            return

        User.objects.create_superuser(
            username=username,
            email=email,
            password=password
        )

        self.stdout.write(
            self.style.SUCCESS(f'Superuser "{username}" created successfully!')
        )
        self.stdout.write(
            self.style.SUCCESS(f'Email: {email}')
        )
        self.stdout.write(
            self.style.WARNING('Remember to change the password in production!')
        )

