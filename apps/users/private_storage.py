from django.core.files.storage import FileSystemStorage
from django.conf import settings
from django.core import signing
from django.urls import reverse
from django.utils.deconstruct import deconstructible

@deconstructible
class CredentialStorage(FileSystemStorage):
    def __init__(self):super().__init__(location=settings.BASE_DIR/'private_credentials')
    def url(self,name):return reverse('private-credential',args=[signing.dumps(name,salt='credential-download')])

@deconstructible
class SponsorCreativeStorage(FileSystemStorage):
    def __init__(self):super().__init__(location=settings.BASE_DIR/'private_sponsor_assets')
    def url(self,name):return reverse('private-sponsor-asset',args=[signing.dumps(name,salt='sponsor-asset-download')])
