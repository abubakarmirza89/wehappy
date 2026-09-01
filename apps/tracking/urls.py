from apps.tracking.views import (
    RelativeList,
    MoodListView,
    SuggestionByMoodView,
    RelativeViewSet,
    MoodCheckInViewSet,
    ChatConversationViewSet,
    ChatMessageListView,
    MoodNotificationViewSet,
    NotificationTemplateListView,
    GratitudeEntryViewSet
)

from django.urls import path, include
from rest_framework.routers import DefaultRouter


app_name = "tracking"
router = DefaultRouter()
router.register(r'relatives', RelativeViewSet)
router.register(r'mood-check-ins', MoodCheckInViewSet, basename='mood-checkin')
router.register(r'chat-conversations', ChatConversationViewSet, basename='chat-conversation')
router.register(r'mood-notifications', MoodNotificationViewSet, basename='mood-notification')
router.register(r'gratitude-entries', GratitudeEntryViewSet, basename='gratitude-entry')

urlpatterns = [
    path('', include(router.urls)),

    path('relatives/', RelativeList.as_view({'get': 'list', 'post': 'create'}), name='relatives-list'),
    path('relatives/<int:pk>/', RelativeList.as_view({'get': 'retrieve', 'put': 'update', 'patch': 'partial_update', 'delete': 'destroy'}), name='relatives-detail'),
    path('moods/', MoodListView.as_view(), name='mood-list'),
    path('suggestions/by-mood/', SuggestionByMoodView.as_view(), name='suggestion-by-mood'),
    path('check_user/', RelativeList.as_view({'post': 'check_user'}), name='check_user'),
    
    # Chat Messages
    path('chat/<int:conversation_id>/messages/', ChatMessageListView.as_view(), name='chat-messages'),
    
    # Notification Templates
    path('notification-templates/', NotificationTemplateListView.as_view(), name='notification-templates'),
]


