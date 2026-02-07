-- Thêm các cột vào bảng Tasks để liên kết với các thực thể khác
ALTER TABLE Tasks
ADD RelatedToEntityType NVARCHAR(50),
    RelatedToEntityId INT;
GO
