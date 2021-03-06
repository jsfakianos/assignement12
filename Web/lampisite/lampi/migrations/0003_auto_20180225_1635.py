# Generated by Django 2.0.2 on 2018-02-25 16:35

from django.conf import settings
from django.db import migrations, models
import lampi.models


class Migration(migrations.Migration):

    dependencies = [
        ('lampi', '0002_lampi_association_code'),
    ]

    operations = [
        migrations.AlterField(
            model_name='lampi',
            name='association_code',
            field=models.CharField(default=lampi.models.generate_association_code, max_length=32, unique=True),  # nopep8
        ),
        migrations.AlterField(
            model_name='lampi',
            name='user',
            field=models.ForeignKey(on_delete=models.SET(lampi.models.get_parked_user), to=settings.AUTH_USER_MODEL),  # nopep8
        ),
    ]
