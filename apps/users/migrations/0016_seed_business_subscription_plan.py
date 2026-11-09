from django.db import migrations


def create_default_plan(apps, schema_editor):
    BillingPlan = apps.get_model('users', 'BillingPlan')
    if not BillingPlan.objects.using(schema_editor.connection.alias).filter(active=True).exists():
        BillingPlan.objects.using(schema_editor.connection.alias).create(
            name='Hearteli for Work (20 seats)',
            monthly_price=20,
            currency='usd',
            member_limit=20,
            active=True,
        )


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0015_businesssubscription_organisation_status'),
    ]

    operations = [
        migrations.RunPython(create_default_plan, migrations.RunPython.noop),
    ]
