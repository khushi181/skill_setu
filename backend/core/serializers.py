from django.contrib.auth.models import User
from rest_framework import serializers

from .models import (
    Profile,
    Skill,
    UserSkill,
    Opportunity,
    Application,
)


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    role = serializers.ChoiceField(
        choices=Profile.ROLE_CHOICES,
        write_only=True
    )
    subject = serializers.CharField(
        required=False,
        allow_blank=True,
        write_only=True
    )

    class Meta:
        model = User
        fields = [
            "username",
            "email",
            "password",
            "first_name",
            "last_name",
            "role",
            "subject",
        ]

    def create(self, validated_data):
        role = validated_data.pop("role")
        subject = validated_data.pop("subject", "")

        password = validated_data.pop("password")

        user = User.objects.create_user(
            password=password,
            **validated_data
        )

        Profile.objects.create(
            user=user,
            role=role,
            subject=subject,
        )

        return user


class SkillSerializer(serializers.ModelSerializer):
    class Meta:
        model = Skill
        fields = "__all__"


class UserSkillSerializer(serializers.ModelSerializer):
    skill_name = serializers.CharField(
        source="skill.name",
        read_only=True
    )

    class Meta:
        model = UserSkill
        fields = [
            "id",
            "profile",
            "skill",
            "skill_name",
            "level",
        ]


class ProfileSerializer(serializers.ModelSerializer):
    username = serializers.CharField(
        source="user.username",
        read_only=True
    )

    email = serializers.EmailField(
        source="user.email",
        read_only=True
    )

    first_name = serializers.CharField(
        source="user.first_name",
        read_only=True
    )

    last_name = serializers.CharField(
        source="user.last_name",
        read_only=True
    )

    class Meta:
        model = Profile
        fields = [
            "id",
            "username",
            "email",
            "first_name",
            "last_name",
            "role",
            "subject",
            "phone",
            "bio",
        ]


class OpportunitySerializer(serializers.ModelSerializer):
    skills = SkillSerializer(many=True, read_only=True)

    skill_ids = serializers.PrimaryKeyRelatedField(
        many=True,
        queryset=Skill.objects.all(),
        source="skills",
        write_only=True,
        required=False,
    )

    class Meta:
        model = Opportunity
        fields = [
            "id",
            "title",
            "company",
            "type",
            "location",
            "domain",
            "qualification",
            "compensation",
            "description",
            "skills",
            "skill_ids",
            "created_by",
            "created_at",
        ]

        read_only_fields = [
            "created_by",
            "created_at",
        ]


class ApplicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Application
        fields = "__all__"
        read_only_fields = [
            "student",
            "applied_at",
        ]