from django.shortcuts import render
from django.views.decorators.cache import never_cache
from django.views.decorators.http import require_safe

from .models import PrivacyPolicy


def render_policy(source):
    import bleach
    import markdown

    return bleach.clean(
        markdown.markdown(source),
        tags={'h1', 'h2', 'h3', 'h4', 'p', 'ul', 'ol', 'li', 'strong', 'em', 'blockquote', 'a', 'br', 'hr'},
        attributes={'a': ['href', 'title']},
        protocols={'http', 'https', 'mailto'},
        strip=True,
    )


@require_safe
@never_cache
def privacy_policy(request):
    policy = PrivacyPolicy.objects.filter(key='privacy', published_at__isnull=False).first()
    return render(request, 'privacy_policy.html', {'policy': policy}, status=200 if policy else 503)
