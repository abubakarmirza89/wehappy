import uuid
from decimal import Decimal
from django.db import migrations,models

def forwards(apps,schema_editor):
    Therapist=apps.get_model('users','Therapist')
    for t in Therapist.objects.all().iterator():
        t.referral_code=uuid.uuid4();t.save(update_fields=['referral_code'])
    Appointment=apps.get_model('users','Appointment')
    for a in Appointment.objects.exclude(payment_status='pending').filter(fee__gt=0).iterator():
        a.commission_percent=(a.commission/a.fee*100).quantize(Decimal('.01'));a.save(update_fields=['commission_percent'])

class Migration(migrations.Migration):
    dependencies=[('users','0007_marketplacepolicy_appointment_acquisition_source_and_more')]
    operations=[migrations.RunPython(forwards,migrations.RunPython.noop),migrations.AlterField(model_name='therapist',name='referral_code',field=models.UUIDField(default=uuid.uuid4,unique=True,editable=False))]
