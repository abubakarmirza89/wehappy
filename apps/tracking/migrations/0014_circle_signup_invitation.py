import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('tracking', '0013_circle_invite_codes'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='CircleSignupInvitation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.EmailField(max_length=254)),
                ('relationship', models.CharField(default='Friend', max_length=40)),
                ('expires_at', models.DateTimeField()),
                ('last_sent_at', models.DateTimeField(blank=True, null=True)),
                ('claimed_at', models.DateTimeField(blank=True, null=True)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('owner', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='hearteli_circle_signup_invitations', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'constraints': [
                    models.UniqueConstraint(fields=('owner', 'email'), name='hearteli_unique_circle_signup_invite'),
                ],
            },
        ),
    ]
