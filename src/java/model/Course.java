package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class Course {

    public Integer courseId;
    public String courseCode;
    public String courseName;

    public Integer categoryId;

    public String description;
    public String shortDescription;

    public BigDecimal price;
    public BigDecimal originalPrice;
    public Integer discountPercentage;

    public Integer durationHours;
    public Integer durationWeeks;
    public Integer totalLessons;

    public String level;
    public String language;

    public String instructorName;
    public String instructorBio;
    public String instructorAvatarUrl;

    public Integer maxStudents;
    public Integer currentStudents;
    public Integer totalEnrolled;

    public BigDecimal ratingAvg;
    public Integer ratingCount;

    public String thumbnailUrl;
    public String previewVideoUrl;

    public String tags;
    public String learningOutcomes;

    public Boolean certificateAvailable;

    public String status;

    public LocalDateTime createdAt;
    public LocalDateTime updatedAt;
    public Integer createdBy;

    public Course() {
    }

    public Course(Integer courseId, String courseCode, String courseName, Integer categoryId, String description, String shortDescription, BigDecimal price, BigDecimal originalPrice, Integer discountPercentage, Integer durationHours, Integer durationWeeks, Integer totalLessons, String level, String language, String instructorName, String instructorBio, String instructorAvatarUrl, Integer maxStudents, Integer currentStudents, Integer totalEnrolled, BigDecimal ratingAvg, Integer ratingCount, String thumbnailUrl, String previewVideoUrl, String tags, String learningOutcomes, Boolean certificateAvailable, String status, LocalDateTime createdAt, LocalDateTime updatedAt, Integer createdBy) {
        this.courseId = courseId;
        this.courseCode = courseCode;
        this.courseName = courseName;
        this.categoryId = categoryId;
        this.description = description;
        this.shortDescription = shortDescription;
        this.price = price;
        this.originalPrice = originalPrice;
        this.discountPercentage = discountPercentage;
        this.durationHours = durationHours;
        this.durationWeeks = durationWeeks;
        this.totalLessons = totalLessons;
        this.level = level;
        this.language = language;
        this.instructorName = instructorName;
        this.instructorBio = instructorBio;
        this.instructorAvatarUrl = instructorAvatarUrl;
        this.maxStudents = maxStudents;
        this.currentStudents = currentStudents;
        this.totalEnrolled = totalEnrolled;
        this.ratingAvg = ratingAvg;
        this.ratingCount = ratingCount;
        this.thumbnailUrl = thumbnailUrl;
        this.previewVideoUrl = previewVideoUrl;
        this.tags = tags;
        this.learningOutcomes = learningOutcomes;
        this.certificateAvailable = certificateAvailable;
        this.status = status;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.createdBy = createdBy;
    }

    public Integer getCourseId() {
        return courseId;
    }

    public void setCourseId(Integer courseId) {
        this.courseId = courseId;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getCourseName() {
        return courseName;
    }

    public void setCourseName(String courseName) {
        this.courseName = courseName;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public Integer getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(Integer discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public Integer getDurationHours() {
        return durationHours;
    }

    public void setDurationHours(Integer durationHours) {
        this.durationHours = durationHours;
    }

    public Integer getDurationWeeks() {
        return durationWeeks;
    }

    public void setDurationWeeks(Integer durationWeeks) {
        this.durationWeeks = durationWeeks;
    }

    public Integer getTotalLessons() {
        return totalLessons;
    }

    public void setTotalLessons(Integer totalLessons) {
        this.totalLessons = totalLessons;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getLanguage() {
        return language;
    }

    public void setLanguage(String language) {
        this.language = language;
    }

    public String getInstructorName() {
        return instructorName;
    }

    public void setInstructorName(String instructorName) {
        this.instructorName = instructorName;
    }

    public String getInstructorBio() {
        return instructorBio;
    }

    public void setInstructorBio(String instructorBio) {
        this.instructorBio = instructorBio;
    }

    public String getInstructorAvatarUrl() {
        return instructorAvatarUrl;
    }

    public void setInstructorAvatarUrl(String instructorAvatarUrl) {
        this.instructorAvatarUrl = instructorAvatarUrl;
    }

    public Integer getMaxStudents() {
        return maxStudents;
    }

    public void setMaxStudents(Integer maxStudents) {
        this.maxStudents = maxStudents;
    }

    public Integer getCurrentStudents() {
        return currentStudents;
    }

    public void setCurrentStudents(Integer currentStudents) {
        this.currentStudents = currentStudents;
    }

    public Integer getTotalEnrolled() {
        return totalEnrolled;
    }

    public void setTotalEnrolled(Integer totalEnrolled) {
        this.totalEnrolled = totalEnrolled;
    }

    public BigDecimal getRatingAvg() {
        return ratingAvg;
    }

    public void setRatingAvg(BigDecimal ratingAvg) {
        this.ratingAvg = ratingAvg;
    }

    public Integer getRatingCount() {
        return ratingCount;
    }

    public void setRatingCount(Integer ratingCount) {
        this.ratingCount = ratingCount;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public String getPreviewVideoUrl() {
        return previewVideoUrl;
    }

    public void setPreviewVideoUrl(String previewVideoUrl) {
        this.previewVideoUrl = previewVideoUrl;
    }

    public String getTags() {
        return tags;
    }

    public void setTags(String tags) {
        this.tags = tags;
    }

    public String getLearningOutcomes() {
        return learningOutcomes;
    }

    public void setLearningOutcomes(String learningOutcomes) {
        this.learningOutcomes = learningOutcomes;
    }

    public Boolean getCertificateAvailable() {
        return certificateAvailable;
    }

    public void setCertificateAvailable(Boolean certificateAvailable) {
        this.certificateAvailable = certificateAvailable;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        this.createdBy = createdBy;
    }

}
