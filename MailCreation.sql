USE master;
GO

DROP DATABASE IF EXISTS MailDB;
GO

CREATE DATABASE MailDB;
GO

USE MailDB;
GO

CREATE TABLE Sender (
    SenderID INT IDENTITY NOT NULL,
    SenderName NVARCHAR(100) NOT NULL,
    SenderAddress NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Sender PRIMARY KEY (SenderID),
    CONSTRAINT UQ_SenderAddress UNIQUE (SenderAddress)
) AS NODE;
GO

CREATE TABLE Department (
    DepartmentID INT IDENTITY NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    Location NVARCHAR(100) NOT NULL,
    CONSTRAINT PK_Department PRIMARY KEY (DepartmentID),
    CONSTRAINT UQ_DepartmentName UNIQUE (DepartmentName)
) AS NODE;
GO

CREATE TABLE Mail (
    MailID INT IDENTITY(1,1) NOT NULL,
    Subject NVARCHAR(100) NOT NULL,
    Body NVARCHAR(MAX) NOT NULL,
    SentDate DATETIME NOT NULL,
    SenderID INT NOT NULL,
    RecipientID INT NOT NULL,
    CONSTRAINT PK_Mail PRIMARY KEY (MailID)
) AS NODE;
GO

-- 2. Создание таблиц ребер

CREATE TABLE Knows AS EDGE;
GO
ALTER TABLE Knows ADD CONSTRAINT EC_Knows CONNECTION (Sender to Sender);

CREATE TABLE SenderDepartment AS EDGE;
GO
ALTER TABLE SenderDepartment ADD CONSTRAINT EC_SenderDepartment CONNECTION (Sender to Department);

CREATE TABLE SenderMail AS EDGE;
GO
ALTER TABLE SenderMail ADD CONSTRAINT EC_SenderMail CONNECTION (Sender to Mail);

-- 3. Заполнение таблиц узлов

INSERT INTO Sender (SenderName, SenderAddress)
VALUES
  ('John Smith', 'john@example.com'), --1
  ('Jane Doe', 'jane@example.com'), --2
  ('Michael Johnson', 'michael@example.com'), --3
  ('Emily Davis', 'emily@example.com'), --4
  ('David Wilson', 'david@example.com'), --5
  ('Sarah Thompson', 'sarah@example.com'), --6
  ('Daniel Brown', 'daniel@example.com'), --7
  ('Jennifer Lee', 'jennifer@example.com'), --8
  ('Andrew Miller', 'andrew@example.com'), --9
  ('Olivia Anderson', 'olivia@example.com') --10
;
GO

INSERT INTO Department (DepartmentName, Location)
VALUES
  ('Mailroom', 'New York'), --1
  ('Post Office', 'London'), --2
  ('Mailing Services', 'Paris'), --3
  ('IT Support', 'San Francisco'), --4
  ('Delivery', 'Tokyo'), --5
  ('Sorting Center', 'Berlin'), --6
  ('Research and Development', 'Sydney'), --7
  ('Legal Affairs', 'Toronto'), --8
  ('Product Management', 'Singapore'), --9
  ('Customer Care', 'Dubai'), --10
  ('Innovation Lab', 'Los Angeles'), --11
  ('Business Development', 'Mumbai'), --12
  ('Quality Control', 'Seoul') --13
;
GO

INSERT INTO Mail (Subject, Body, SentDate, SenderID, RecipientID)
VALUES
  ('Meeting Reminder', 'Dear team, Just a reminder that we have a meeting tomorrow at 10 AM in the conference room. Please come prepared with your updates and any agenda items you would like to discuss. Thank you.', '2024-05-21 09:00:00', 1, 3),
  ('Mail Update', 'Hi John Smith, I wanted to provide you with an update on the Mail. We have successfully completed the development phase and are now moving into the testing phase. I will keep you posted on our progress. Best regards, Jane', '2024-05-20 14:30:00', 2, 1),
  ('Job Opportunity', 'Dear Michael, We are pleased to inform you that you have been selected for the analyst position at our company. Congratulations! We would like to schedule an interview with you next week. Please let us know your availability. Regards, HR Department', '2024-05-19 11:15:00', 3, 6),
  ('Design Approval', 'Hi Emily, Your design proposal for the new website has been approved. Great job! We will now proceed with the implementation phase. Let me know if you have any questions. Thanks, David', '2024-05-18 16:45:00', 5, 4),
  ('Meeting Request', 'Dear Sarah, I would like to schedule a meeting with you to discuss the upcoming Mail. Please let me know your availability for next week. Thanks, Daniel', '2024-05-17 10:30:00', 7, 6),
  ('Holiday Party Invitation', 'Dear team, We are excited to announce our annual holiday party, which will be held on December 15th at 7 PM in the company cafeteria. Join us for an evening of celebration and fun. Please RSVP by December 5th. Best regards, HR Department', '2024-12-01 09:00:00', 4, 9),
  ('Important Announcement', 'Attention all employees, We would like to inform you that the company will be closed for the upcoming public holiday on May 25th. Please plan your work accordingly and enjoy the long weekend. Regards, Management', '2024-05-19 15:30:00', 6, 2),
  ('Training Workshop Registration', 'Hi Susan, We are pleased to invite you to attend our upcoming training workshop on effective communication skills. The workshop will be held on June 10th from 9 AM to 12 PM in the training room. Please confirm your participation by May 31st. Thank you, Training Department', '2024-05-11 11:45:00', 8, 5),
  ('New Product Launch', 'Dear Valued Customers, We are excited to announce the launch of our new product line. Visit our website to explore the latest offerings and take advantage of special promotional offers. Thank you for your continued support. Best regards, Sales Team', '2024-04-30 14:15:00', 10, 7),
  ('Performance Review Reminder', 'Dear Employees, This is a friendly reminder that performance reviews for this quarter are due by the end of the week. Please complete the review form and submit it to your respective managers. Thank you, HR Department', '2024-03-28 10:30:00', 11, 3)
;
GO

-- 4. Заполнение таблиц ребер

INSERT INTO Knows ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 6), -- Sarah
		(SELECT $node_id FROM Sender WHERE SenderID = 1) -- John Smith
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 6), -- Sarah
		(SELECT $node_id FROM Sender WHERE SenderID = 2) -- Jane
	),	
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 6), -- Sarah
		(SELECT $node_id FROM Sender WHERE SenderID = 5) -- David
	),	
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 6), -- Sarah
		(SELECT $node_id FROM Sender WHERE SenderID = 9) -- Andrew
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 2), -- Jane
		(SELECT $node_id FROM Sender WHERE SenderID = 6) -- Sarah
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 2), -- Jane
		(SELECT $node_id FROM Sender WHERE SenderID = 3) -- Micheal
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 2), -- Jane
		(SELECT $node_id FROM Sender WHERE SenderID = 7) -- Daniel
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 3), -- Micheal
		(SELECT $node_id FROM Sender WHERE SenderID = 4) -- Emily
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 3), -- Micheal
		(SELECT $node_id FROM Sender WHERE SenderID = 8) -- Jennifer
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 8), -- Daniel
		(SELECT $node_id FROM Sender WHERE SenderID = 10) -- Olivia
	)
;
GO

INSERT INTO SenderDepartment ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 1), -- John Smith Smith
		(SELECT $node_id FROM Department WHERE DepartmentID = 1) -- работает в отделе HR
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 2), -- Jane Doe
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 3), -- Michael Johnson
		(SELECT $node_id FROM Department WHERE DepartmentID = 7) -- работает в отделе Research
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 4), -- Emily Davis
		(SELECT $node_id FROM Department WHERE DepartmentID = 3) -- работает в отделе Marketing
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 5), -- David Wilson
		(SELECT $node_id FROM Department WHERE DepartmentID = 6) -- работает в отделе Operations
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 6), -- Sarah Thompson
		(SELECT $node_id FROM Department WHERE DepartmentID = 2) -- работает в отделе Finance
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 7), -- Daniel Brown
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 8), -- Jennifer Lee
		(SELECT $node_id FROM Department WHERE DepartmentID = 1) -- работает в отделе HR
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 9), -- Andrew Miller
		(SELECT $node_id FROM Department WHERE DepartmentID = 5) -- работает в отделе Sales
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 10), -- Olivia Anderson
		(SELECT $node_id FROM Department WHERE DepartmentID = 4) -- работает в отделе IT
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 1), -- John Smith Smith
		(SELECT $node_id FROM Department WHERE DepartmentID = 11) -- работает в отделе Finance
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 2), -- Jane Doe
		(SELECT $node_id FROM Department WHERE DepartmentID = 12) -- работает в отделе Marketing
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 3), -- Micheal Johnson
		(SELECT $node_id FROM Department WHERE DepartmentID = 13) -- работает в отделе Marketing
	)
	;
GO

INSERT INTO SenderMail ($from_id, $to_id)
VALUES
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 1), -- John Smith Smith
		(SELECT $node_id FROM Mail WHERE MailID = 1) -- работает над проектом "Website Redesign"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 2), -- Jane Doe
		(SELECT $node_id FROM Mail WHERE MailID = 4) -- работает над проектом "Software Development"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 3), -- Michael Johnson
		(SELECT $node_id FROM Mail WHERE MailID = 3) -- работает над проектом "Marketing Campaign"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 4), -- Emily Davis
		(SELECT $node_id FROM Mail WHERE MailID = 2) -- работает над проектом "Product Launch"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 5), -- David Wilson
		(SELECT $node_id FROM Mail WHERE MailID = 5) -- работает над проектом "International Expansion"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 6), -- Sarah Thompson
		(SELECT $node_id FROM Mail WHERE MailID = 7) -- работает над проектом "Supply Chain Optimization"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 7), -- Daniel Brown
		(SELECT $node_id FROM Mail WHERE MailID = 4) -- работает над проектом "Software Development"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 8), -- Jennifer Lee
		(SELECT $node_id FROM Mail WHERE MailID = 1) -- работает над проектом "Website Redesign"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 9), -- Andrew Miller
		(SELECT $node_id FROM Mail WHERE MailID = 5) -- работает над проектом "International Expansion"
	),
	(
		(SELECT $node_id FROM Sender WHERE SenderID = 10), -- Olivia Anderson
		(SELECT $node_id FROM Mail WHERE MailID = 3) -- работает над проектом "Marketing Campaign"
	)
;
GO

-- 5. Запросы с функцией MATCH

-- Клиенты, отправившие письмо Meeting Reminder:

SELECT S.SenderName as [Name]
FROM 
	Sender as S, 
	SenderMail as SM, 
	Mail as M
where 
	MATCH (S-(SM)->M) and M.Subject = 'Meeting Reminder'
;

-- Отделы, куда ходит John Smith:

SELECT D.DepartmentName
FROM Department as D, SenderDepartment as SD, Sender as S
WHERE MATCH (S-(SD)->D) and S.SenderName = 'John Smith';

-- Письма, которые отправил John Smith:

select M.Subject
from Sender as S,
	 SenderMail as SM, 
	 Mail as M
where S.SenderName = 'John Smith'
	  and MATCH (S-(SM)->M)

-- Отделы, которые отправляли письма, написанные John Smith:

select distinct D.DepartmentName, D.Location
FROM Department as D, 
	 SenderDepartment as SD,
	 Sender as S,
	 SenderMail as SM, 
	 Mail as M
WHERE S.SenderName = 'John Smith'
	  and MATCH (S-(SD)->D)
	  and MATCH (S-(SM)->M)
;

-- Клиенты и письма, которые отправлялись в отделе Mailing Services:

select distinct S.SenderName as [Name], M.Subject as [Mail]
FROM Department as D, 
	 SenderDepartment as SD,
	 Sender as S,
	 SenderMail as SM, 
	 Mail as M
WHERE D.DepartmentName = 'Mailing Services'
	  and MATCH (S-(SD)->D)
	  and MATCH (S-(SM)->M)
;

-- 6. Запросы с функцией SHORTEST_PATH

SELECT 
    E1.SenderName AS Employee1Name,
    STRING_AGG(E2.SenderName, '->') WITHIN GROUP (GRAPH PATH) AS EmployeePath
FROM 
    Sender AS E1,
	Sender FOR PATH AS E2, 
	Knows FOR PATH AS Knows
WHERE MATCH(SHORTEST_PATH(E1(-(Knows)->E2)+))
	and E1.SenderName = 'Jane Doe';

SELECT 
    E1.SenderName AS Employee1Name,
    STRING_AGG(E2.SenderName, '->') WITHIN GROUP (GRAPH PATH) AS EmployeePath
FROM 
    Sender AS E1,
	Sender FOR PATH AS E2, 
	Knows FOR PATH AS Knows
WHERE MATCH(SHORTEST_PATH(E1(-(Knows)->E2){1,2}))
	and E1.SenderName = 'Jane Doe';