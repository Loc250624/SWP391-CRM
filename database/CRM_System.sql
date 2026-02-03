CREATE DATABASE CRM_System_Full;
GO
USE CRM_System_Full;
GO
CREATE TABLE users (
  id int PRIMARY KEY IDENTITY(1,1),
  name nvarchar(255),
  email varchar(255) UNIQUE,
  role varchar(50), 
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE lead_status (
  id int PRIMARY KEY,
  code varchar(50),
  name nvarchar(100)
);

CREATE TABLE opportunity_stage (
  id int PRIMARY KEY,
  code varchar(50),
  name nvarchar(100)
);

CREATE TABLE task_status (
  id int PRIMARY KEY,
  code varchar(50),
  name nvarchar(100)
);

CREATE TABLE ticket_status (
  id int PRIMARY KEY,
  code varchar(50),
  name nvarchar(100)
);

CREATE TABLE activity_types (
  id int PRIMARY KEY,
  code varchar(50),
  name nvarchar(100)
);

CREATE TABLE courses (
  id int PRIMARY KEY,
  name nvarchar(255),
  price decimal(18, 2)
);

CREATE TABLE scoring_criteria (
  id int PRIMARY KEY IDENTITY(1,1),
  code varchar(50),
  name nvarchar(255),
  description nvarchar(max),
  default_score int,
  is_active bit DEFAULT 1,
  created_at datetime DEFAULT GETDATE()
);
CREATE TABLE campaigns (
  id int PRIMARY KEY IDENTITY(1,1),
  name nvarchar(255),
  type varchar(50),
  start_date date,
  end_date date
);

CREATE TABLE leads (
  id int PRIMARY KEY IDENTITY(1,1),
  full_name nvarchar(255),
  email varchar(255),
  phone varchar(20),
  age int,
  financial_level nvarchar(100),
  total_score int,
  lead_status_id int FOREIGN KEY REFERENCES lead_status(id),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE lead_scoring (
  id int PRIMARY KEY IDENTITY(1,1),
  lead_id int FOREIGN KEY REFERENCES leads(id),
  scoring_criteria_id int FOREIGN KEY REFERENCES scoring_criteria(id),
  score int,
  note nvarchar(255),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE lead_campaigns (
  lead_id int FOREIGN KEY REFERENCES leads(id),
  campaign_id int FOREIGN KEY REFERENCES campaigns(id),
  PRIMARY KEY (lead_id, campaign_id)
);
CREATE TABLE opportunities (
  id int PRIMARY KEY IDENTITY(1,1),
  lead_id int FOREIGN KEY REFERENCES leads(id),
  stage_id int FOREIGN KEY REFERENCES opportunity_stage(id),
  expected_value decimal(18, 2),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE quotations (
  id int PRIMARY KEY IDENTITY(1,1),
  opportunity_id int FOREIGN KEY REFERENCES opportunities(id),
  total_amount decimal(18, 2),
  status varchar(50),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE customers (
  id int PRIMARY KEY IDENTITY(1,1),
  lead_id int FOREIGN KEY REFERENCES leads(id),
  full_name nvarchar(255),
  email varchar(255),
  phone varchar(20),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE customer_assignments (
  id int PRIMARY KEY IDENTITY(1,1),
  customer_id int FOREIGN KEY REFERENCES customers(id),
  user_id int FOREIGN KEY REFERENCES users(id),
  role varchar(50),
  assigned_at datetime DEFAULT GETDATE()
);

CREATE TABLE customer_notes (
  id int PRIMARY KEY IDENTITY(1,1),
  customer_id int FOREIGN KEY REFERENCES customers(id),
  user_id int FOREIGN KEY REFERENCES users(id),
  content nvarchar(max),
  created_at datetime DEFAULT GETDATE()
);
CREATE TABLE activities (
  id int PRIMARY KEY IDENTITY(1,1),
  user_id int FOREIGN KEY REFERENCES users(id),
  lead_id int NULL FOREIGN KEY REFERENCES leads(id),
  customer_id int NULL FOREIGN KEY REFERENCES customers(id),
  activity_type_id int FOREIGN KEY REFERENCES activity_types(id),
  description nvarchar(max),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE tasks (
  id int PRIMARY KEY IDENTITY(1,1),
  title nvarchar(255),
  description nvarchar(max),
  assigned_to int FOREIGN KEY REFERENCES users(id),
  created_by int FOREIGN KEY REFERENCES users(id),
  customer_id int NULL FOREIGN KEY REFERENCES customers(id),
  lead_id int NULL FOREIGN KEY REFERENCES leads(id),
  status_id int FOREIGN KEY REFERENCES task_status(id),
  priority varchar(20),
  due_date datetime,
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE task_comments (
  id int PRIMARY KEY IDENTITY(1,1),
  task_id int FOREIGN KEY REFERENCES tasks(id),
  user_id int FOREIGN KEY REFERENCES users(id),
  content nvarchar(max),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE task_history (
  id int PRIMARY KEY IDENTITY(1,1),
  task_id int FOREIGN KEY REFERENCES tasks(id),
  user_id int FOREIGN KEY REFERENCES users(id),
  action nvarchar(50), -- CREATED, UPDATED, DONE
  note nvarchar(max),
  created_at datetime DEFAULT GETDATE()
);
CREATE TABLE tickets (
  id int PRIMARY KEY IDENTITY(1,1),
  customer_id int FOREIGN KEY REFERENCES customers(id),
  created_by int FOREIGN KEY REFERENCES users(id),
  title nvarchar(255),
  description nvarchar(max),
  status_id int FOREIGN KEY REFERENCES ticket_status(id),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE ticket_responses (
  id int PRIMARY KEY IDENTITY(1,1),
  ticket_id int FOREIGN KEY REFERENCES tickets(id),
  sender_id int FOREIGN KEY REFERENCES users(id),
  content nvarchar(max),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE ticket_logs (
  id int PRIMARY KEY IDENTITY(1,1),
  ticket_id int FOREIGN KEY REFERENCES tickets(id),
  user_id int FOREIGN KEY REFERENCES users(id),
  action nvarchar(50), -- CREATED, UPDATED, CLOSED
  note nvarchar(max),
  created_at datetime DEFAULT GETDATE()
);
CREATE TABLE promotions (
  id int PRIMARY KEY IDENTITY(1,1),
  title nvarchar(255),
  description nvarchar(max),
  start_time datetime,
  end_time datetime,
  created_by int FOREIGN KEY REFERENCES users(id),
  status varchar(50),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE promotion_courses (
  id int PRIMARY KEY IDENTITY(1,1),
  promotion_id int FOREIGN KEY REFERENCES promotions(id),
  course_id int FOREIGN KEY REFERENCES courses(id),
  discount_percent int,
  discount_price decimal(18, 2)
);

CREATE TABLE customer_courses (
  id int PRIMARY KEY IDENTITY(1,1),
  customer_id int FOREIGN KEY REFERENCES customers(id),
  course_id int FOREIGN KEY REFERENCES courses(id),
  enrolled_at datetime DEFAULT GETDATE(),
  status varchar(50) -- LEARNING, COMPLETED
);

CREATE TABLE orders (
  id int PRIMARY KEY IDENTITY(1,1),
  customer_id int FOREIGN KEY REFERENCES customers(id),
  total_amount decimal(18, 2),
  created_at datetime DEFAULT GETDATE()
);

CREATE TABLE order_items (
  order_id int FOREIGN KEY REFERENCES orders(id),
  course_id int FOREIGN KEY REFERENCES courses(id),
  price decimal(18, 2),
  PRIMARY KEY (order_id, course_id)
);

CREATE TABLE payments (
  id int PRIMARY KEY IDENTITY(1,1),
  order_id int FOREIGN KEY REFERENCES orders(id),
  payment_method varchar(100),
  transaction_code varchar(100),
  amount decimal(18, 2),
  status varchar(50), -- PENDING, SUCCESS, FAILED
  paid_at datetime
);

INSERT INTO lead_status (id, code, name)
VALUES 
(1, 'NEW', 'New Lead'),
(2, 'CONTACTED', 'Contacted'),
(3, 'QUALIFIED', 'Qualified'),
(4, 'UNQUALIFIED', 'Unqualified'),
(5, 'CONVERTED', 'Converted');
SELECT * FROM lead_status;

USE CRM_System_Full;
GO

-- Insert lead mẫu (không cần id, không cần created_at)
INSERT INTO leads (
    full_name, email, phone, age, financial_level, total_score, lead_status_id
)
VALUES
(N'Nguyễn Văn A', 'nguyenvana@gmail.com', '0909123456', 22, N'High', 70, 1),
(N'Trần Thị B', 'tranb@gmail.com', '0909000001', 24, N'Medium', 55, 2),
(N'Lê Văn C', 'lec@gmail.com', '0909000002', 28, N'Low', 40, 3),
(N'Phạm Văn D', 'phamd@gmail.com', '0909000003', 21, N'Medium', 60, 1);


SELECT TOP 10 * FROM leads ORDER BY id DESC;

SELECT id, full_name, lead_status_id
FROM leads
WHERE id = 1;
