--1

--Declare scalar variable for storing FirstName values
  --Assign value ‘Antonio’ to the FirstName variable
  DECLARE @FirstName nvarchar(100)
  SET @FirstName='Antonio'

  --Find all Students having FirstName same as the variable
  SELECT *
  FROM Student
  WHERE FirstName=@FirstName

--Declare table variable that will contain StudentId, StudentName and DateOfBirth
DECLARE @StudentList TABLE
(StudentId int , StudentName nvarchar(100) ,DataOfBirth date)

--Fill the table variable with all Female students
INSERT INTO @StudentList 
SELECT Id,FirstName,DateOfBirth
FROM Student
WHERE Gender='F'

SELECT * FROM @StudentList

--Declare temp table that will contain LastName and EnrolledDate columns
 --Fill the temp table with all Male students having First Name starting with ‘A’
 --Retrieve the students from the table which last name is with 7 characters

 CREATE TABLE #StudentList
 (LastName nvarchar(100) , EnrolledDate Date)

 
 INSERT INTO #StudentList
 SELECT LastName,EnrolledDate
 FROM Student
 WHERE Gender='M' and FirstName LIKE 'A%' and LEN(LastName)=7

 select * from #StudentList
 --WHERE LEN(LastName)=7

 --Find all teachers whose FirstName length is less than 5 and
--the first 3 characters of their FirstName and LastName are the same
SELECT *
FROM Teacher
WHERE LEN(FirstName)<5 and SUBSTRING(FirstName,1,3)=LEFT(LastName,3)

--2
--Declare scalar function (fn_FormatStudentName) for retrieving the Student description for specific StudentId in the following format:
--StudentCardNumber without “sc-”
--“ – “
--First character of student FirstName
--“.”
--Student LastName

CREATE FUNCTION fn_FormatStudentName(@StudentId int)
RETURNS nvarchar(100)
AS
BEGIN
DECLARE @Result nvarchar(100)
SELECT @Result=SUBSTRING(StudentCardNumber,4,(Len(StudentCardNumber)))+N'-'+ SUBSTRING(FirstName,1,1)+ N'.' + LastName
FROM Student
WHERE Id=@StudentId
RETURN @Result
END

-- test execution
select *, fn_FormatStudentName(ID)
from Student



--3

--Create multi-statement table value function that for specific Teacher and Course will return list of students (FirstName, LastName) 
--who passed the exam, together with Grade and CreatedDate


--Declare @TeacherId INT=1
--DECLARE @COURSE INT =1
CREATE FUNCTION fn_GradePerStudent (@TeacherId int,@Course int)
RETURNS @output TABLE (FirstName nvarchar(100),LastName nvarchar(100),Grade int, CreatedDate date)
AS
BEGIN


INSERT INTO @output

SELECT s.FirstName,s.LastName,g.Grade ,g.CreatedDate
FROM Grade g
INNER JOIN Student s ON g.StudentID=s.ID
WHERE g.TeacherID=@TeacherId and g.CourseID=@COURSE

RETURN
END
GO

Declare @TeacherId INT=1
DECLARE @COURSE INT =1

select * from dbo.fn_GradePerStudent (@TeacherId,@COURSE)



