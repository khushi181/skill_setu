from django.contrib.auth.models import User
from rest_framework import status, viewsets
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response

from .models import (
    Profile,
    Skill,
    UserSkill,
    Opportunity,
    Application,
)

from .serializers import (
    RegisterSerializer,
    ProfileSerializer,
    SkillSerializer,
    UserSkillSerializer,
    OpportunitySerializer,
    ApplicationSerializer,
)


@api_view(["POST"])
@permission_classes([AllowAny])
def register(request):
    serializer = RegisterSerializer(data=request.data)

    if serializer.is_valid():
        serializer.save()

        return Response(
            {
                "message": "Registration successful",
                "user": serializer.data,
            },
            status=status.HTTP_201_CREATED,
        )

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST,
    )


@api_view(["GET", "PUT"])
@permission_classes([IsAuthenticated])
def profile(request):

    profile = Profile.objects.get(user=request.user)

    if request.method == "GET":
        serializer = ProfileSerializer(profile)
        return Response(serializer.data)

    serializer = ProfileSerializer(
        profile,
        data=request.data,
        partial=True,
    )

    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)

    return Response(
        serializer.errors,
        status=status.HTTP_400_BAD_REQUEST,
    )


class SkillViewSet(viewsets.ModelViewSet):

    queryset = Skill.objects.all().order_by("name")
    serializer_class = SkillSerializer


class UserSkillViewSet(viewsets.ModelViewSet):

    serializer_class = UserSkillSerializer

    def get_queryset(self):
        return UserSkill.objects.filter(
            profile__user=self.request.user
        )

    def perform_create(self, serializer):
        profile = Profile.objects.get(
            user=self.request.user
        )

        serializer.save(profile=profile)


class OpportunityViewSet(viewsets.ModelViewSet):

    queryset = Opportunity.objects.all().order_by("-created_at")
    serializer_class = OpportunitySerializer

    def get_permissions(self):
        if self.action in ["list", "retrieve"]:
            return [AllowAny()]

        return [IsAuthenticated()]

    def perform_create(self, serializer):
        serializer.save(
            created_by=self.request.user
        )

    @action(
        detail=True,
        methods=["post"],
        permission_classes=[IsAuthenticated],
    )
    def apply(self, request, pk=None):

        opportunity = self.get_object()

        profile = Profile.objects.get(
            user=request.user
        )

        if profile.role != "Student":
            return Response(
                {
                    "error": "Only students can apply."
                },
                status=status.HTTP_403_FORBIDDEN,
            )

        application, created = Application.objects.get_or_create(
            student=profile,
            opportunity=opportunity,
        )

        if not created:
            return Response(
                {
                    "message": "You have already applied."
                },
                status=status.HTTP_400_BAD_REQUEST,
            )

        return Response(
            {
                "message": "Application submitted successfully."
            },
            status=status.HTTP_201_CREATED,
        )


class ApplicationViewSet(viewsets.ModelViewSet):

    serializer_class = ApplicationSerializer

    def get_queryset(self):

        profile = Profile.objects.get(
            user=self.request.user
        )

        if profile.role == "Student":
            return Application.objects.filter(
                student=profile
            )

        if profile.role == "Industry":
            return Application.objects.filter(
                opportunity__created_by=self.request.user
            )

        return Application.objects.none()