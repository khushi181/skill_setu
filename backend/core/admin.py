from django.contrib import admin

from .models import (
    Profile,
    Skill,
    UserSkill,
    Opportunity,
    Application,
)


@admin.register(Profile)
class ProfileAdmin(admin.ModelAdmin):

    list_display = (
        "user",
        "role",
        "subject",
        "phone",
    )

    search_fields = (
        "user__username",
        "user__email",
        "subject",
    )

    list_filter = (
        "role",
    )


@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):

    list_display = (
        "name",
        "domain",
    )

    search_fields = (
        "name",
        "domain",
    )


@admin.register(UserSkill)
class UserSkillAdmin(admin.ModelAdmin):

    list_display = (
        "profile",
        "skill",
        "level",
    )

    list_filter = (
        "level",
    )


@admin.register(Opportunity)
class OpportunityAdmin(admin.ModelAdmin):

    list_display = (
        "title",
        "company",
        "type",
        "location",
        "domain",
        "created_at",
    )

    search_fields = (
        "title",
        "company",
        "domain",
    )

    list_filter = (
        "type",
        "domain",
    )


@admin.register(Application)
class ApplicationAdmin(admin.ModelAdmin):

    list_display = (
        "student",
        "opportunity",
        "status",
        "applied_at",
    )

    list_filter = (
        "status",
    )