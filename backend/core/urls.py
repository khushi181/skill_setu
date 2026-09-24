from django.urls import include, path
from rest_framework.routers import DefaultRouter

from .views import (
    register,
    profile,
    SkillViewSet,
    UserSkillViewSet,
    OpportunityViewSet,
    ApplicationViewSet,
)


router = DefaultRouter()

router.register(
    r"skills",
    SkillViewSet,
    basename="skill",
)

router.register(
    r"user-skills",
    UserSkillViewSet,
    basename="user-skill",
)

router.register(
    r"opportunities",
    OpportunityViewSet,
    basename="opportunity",
)

router.register(
    r"applications",
    ApplicationViewSet,
    basename="application",
)


urlpatterns = [

    path(
        "auth/register/",
        register,
        name="register",
    ),

    path(
        "profile/",
        profile,
        name="profile",
    ),

    path(
        "",
        include(router.urls),
    ),
]