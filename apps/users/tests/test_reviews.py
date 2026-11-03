from django.test import TestCase
from rest_framework.test import APIClient
from apps.users.models import User,Appointment,Feedback

class SessionReviewTests(TestCase):
    def setUp(self):
        self.client_user=User.objects.create_user(name='Reviewer',email='reviewer@example.com',password='StrongPass123',phone_number='1')
        self.therapist=User.objects.create_user(name='Reviewed therapist',email='reviewed@example.com',password='StrongPass123',phone_number='2',is_therapist=True)
        self.other=User.objects.create_user(name='Other reviewer',email='other-review@example.com',password='StrongPass123',phone_number='3')
        self.a=Appointment.objects.create(user=self.client_user,therapist=self.therapist,date='2026-11-01',time='10:00',location='Online',reason='Private',status='COMPLETED')
        self.api=APIClient();self.api.force_authenticate(self.client_user)
        self.url=f'/api/users/feedback/{self.therapist.pk}/'
    def post(self,rating=5): return self.api.post(self.url,{'appointment_id':self.a.pk,'rating':rating,'comment':'Helpful session'})
    def test_completed_client_can_review_once(self):
        self.assertEqual(self.post().status_code,201)
        self.assertEqual(self.post().status_code,400)
        self.assertEqual(Feedback.objects.count(),1)
        profile=self.api.get(f'/api/users/therapists/{self.therapist.pk}/').data
        self.assertEqual(profile['average_rating'],5);self.assertEqual(profile['review_count'],1)
    def test_other_client_and_provider_cannot_review(self):
        for user in [self.other,self.therapist]:
            self.api.force_authenticate(user);self.assertEqual(self.post().status_code,403)
    def test_uncompleted_or_cancelled_cannot_review(self):
        for status in ['BOOKED','IN_PROGRESS','CANCELED']:
            self.a.status=status;self.a.save();self.assertEqual(self.post().status_code,400)
    def test_rating_range_and_wrong_provider(self):
        for rating in [0,6]:self.assertEqual(self.post(rating).status_code,400)
        self.url=f'/api/users/feedback/{self.other.pk}/';self.assertEqual(self.post().status_code,403)
    def test_public_review_omits_client_and_session_private_data(self):
        self.post();data=self.api.get(f'/api/users/therapists/{self.therapist.pk}/reviews/').data
        self.assertEqual(set(data[0]),{'id','rating','comment'})
        self.assertNotIn('Private',str(data));self.assertNotIn(self.client_user.email,str(data))
