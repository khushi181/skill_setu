from django.contrib.auth.models import User
from django.db import models


class Profile(models.Model):

    ROLE_CHOICES = [
        ("Student", "Student"),
        ("Industry", "Industry"),
        ("Academician", "Academician"),
        ("Institution", "Institution"),
    ]

    user = models.OneToOneField(
        User,
        on_delete=models.CASCADE,
        related_name="profile",
    )

    role = models.CharField(
        max_length=20,
        choices=ROLE_CHOICES,
    )

    subject = models.CharField(
        max_length=150,
        blank=True,
    )

    phone = models.CharField(
        max_length=20,
        blank=True,
    )

    bio = models.TextField(
        blank=True,
    )

    def __str__(self):
        return f"{self.user.username} - {self.role}"


class Skill(models.Model):

    name = models.CharField(
        max_length=100,
    )

    domain = models.CharField(
        max_length=100,
    )

    def __str__(self):
        return self.name


class UserSkill(models.Model):

    LEVEL_CHOICES = [
        ("Beginner", "Beginner"),
        ("Intermediate", "Intermediate"),
        ("Advanced", "Advanced"),
        ("Expert", "Expert"),
    ]

    profile = models.ForeignKey(
        Profile,
        on_delete=models.CASCADE,
        related_name="user_skills",
    )

    skill = models.ForeignKey(
        Skill,
        on_delete=models.CASCADE,
        related_name="users",
    )

    level = models.CharField(
        max_length=20,
        choices=LEVEL_CHOICES,
        default="Beginner",
    )

    class Meta:
        unique_together = (
            "profile",
            "skill",
        )

    def __str__(self):
        return f"{self.profile} - {self.skill}"


class Opportunity(models.Model):

    TYPE_CHOICES = [
        ("Internship", "Internship"),
        ("Job", "Job"),
        ("Research", "Research"),
        ("Workshop", "Workshop"),
    ]

    title = models.CharField(
        max_length=200,
    )

    company = models.CharField(
        max_length=200,
    )

    type = models.CharField(
        max_length=20,
        choices=TYPE_CHOICES,
    )

    location = models.CharField(
        max_length=200,
    )

    domain = models.CharField(
        max_length=100,
    )

    qualification = models.CharField(
        max_length=300,
        blank=True,
    )

    compensation = models.CharField(
        max_length=100,
        blank=True,
    )

    description = models.TextField(
        blank=True,
    )

    skills = models.ManyToManyField(
        Skill,
        blank=True,
        related_name="opportunities",
    )

    created_by = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name="opportunities",
    )

    created_at = models.DateTimeField(
        auto_now_add=True,
    )

    def __str__(self):
        return self.title


class Application(models.Model):

    STATUS_CHOICES = [
        ("Applied", "Applied"),
        ("Shortlisted", "Shortlisted"),
        ("Rejected", "Rejected"),
        ("Selected", "Selected"),
    ]

    student = models.ForeignKey(
        Profile,
        on_delete=models.CASCADE,
        related_name="applications",
    )

    opportunity = models.ForeignKey(
        Opportunity,
        on_delete=models.CASCADE,
        related_name="applications",
    )

    status = models.CharField(
        max_length=20,
        choices=STATUS_CHOICES,
        default="Applied",
    )

    applied_at = models.DateTimeField(
        auto_now_add=True,
    )

    class Meta:
        unique_together = (
            "student",
            "opportunity",
        )

    def __str__(self):
        return (
            f"{self.student} - "
            f"{self.opportunity}"
        )