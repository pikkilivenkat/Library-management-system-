-- LIBRARY MANAGEMENT SYSTEM
-- Complete MySQL SQL Script

-- ===== PART 1: DDL =====
CREATE DATABASE IF NOT EXISTS library_db;
USE library_db;

CREATE TABLE publishers (
  publisher_id   INT AUTO_INCREMENT PRIMARY KEY,
  publisher_name VARCHAR(100) NOT NULL,
  city           VARCHAR(50)
);

CREATE TABLE categories (
  category_id   INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE authors (
  author_id   INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(100) NOT NULL
);

CREATE TABLE books (
  book_id          INT AUTO_INCREMENT PRIMARY KEY,
  title            VARCHAR(150) NOT NULL,
  isbn             VARCHAR(20)  NOT NULL UNIQUE,
  price            DECIMAL(8,2) NOT NULL,
  total_copies     INT NOT NULL DEFAULT 1,
  available_copies INT NOT NULL DEFAULT 1,
  publisher_id     INT NOT NULL,
  category_id      INT NOT NULL,
  CONSTRAINT chk_books_price  CHECK (price > 0),
  CONSTRAINT chk_books_copies CHECK (total_copies >= 0
      AND available_copies >= 0 AND available_copies <= total_copies),
  CONSTRAINT fk_books_publisher FOREIGN KEY (publisher_id)
      REFERENCES publishers(publisher_id),
  CONSTRAINT fk_books_category  FOREIGN KEY (category_id)
      REFERENCES categories(category_id)
);

CREATE TABLE book_authors (
  book_id   INT NOT NULL,
  author_id INT NOT NULL,
  PRIMARY KEY (book_id, author_id),
  CONSTRAINT fk_ba_book   FOREIGN KEY (book_id)
      REFERENCES books(book_id) ON DELETE CASCADE,
  CONSTRAINT fk_ba_author FOREIGN KEY (author_id)
      REFERENCES authors(author_id)
);

CREATE TABLE members (
  member_id   INT AUTO_INCREMENT PRIMARY KEY,
  member_name VARCHAR(100) NOT NULL,
  email       VARCHAR(100) NOT NULL UNIQUE,
  phone       VARCHAR(15),
  join_date   DATE NOT NULL,
  status      VARCHAR(10) NOT NULL DEFAULT 'Active',
  CONSTRAINT chk_members_status CHECK (status IN ('Active','Inactive'))
);

CREATE TABLE librarians (
  librarian_id   INT AUTO_INCREMENT PRIMARY KEY,
  librarian_name VARCHAR(100) NOT NULL,
  shift          VARCHAR(10)  NOT NULL,
  CONSTRAINT chk_librarians_shift CHECK (shift IN ('Morning','Evening'))
);

CREATE TABLE issues (
  issue_id     INT AUTO_INCREMENT PRIMARY KEY,
  member_id    INT  NOT NULL,
  book_id      INT  NOT NULL,
  librarian_id INT  NOT NULL,
  issue_date   DATE NOT NULL,
  due_date     DATE NOT NULL,
  return_date  DATE NULL,
  CONSTRAINT chk_issues_dates CHECK (due_date > issue_date),
  CONSTRAINT fk_issues_member    FOREIGN KEY (member_id)
      REFERENCES members(member_id),
  CONSTRAINT fk_issues_book      FOREIGN KEY (book_id)
      REFERENCES books(book_id),
  CONSTRAINT fk_issues_librarian FOREIGN KEY (librarian_id)
      REFERENCES librarians(librarian_id)
);

CREATE TABLE fines (
  fine_id     INT AUTO_INCREMENT PRIMARY KEY,
  issue_id    INT NOT NULL UNIQUE,
  fine_amount DECIMAL(8,2) NOT NULL,
  paid_status VARCHAR(10) NOT NULL DEFAULT 'Unpaid',
  CONSTRAINT chk_fines_amount CHECK (fine_amount >= 0),
  CONSTRAINT chk_fines_status CHECK (paid_status IN ('Paid','Unpaid')),
  CONSTRAINT fk_fines_issue FOREIGN KEY (issue_id)
      REFERENCES issues(issue_id)
);

ALTER TABLE members
  ADD CONSTRAINT chk_members_phone CHECK (CHAR_LENGTH(phone) = 10);

-- ===== PART 2: DML (sample data) =====
INSERT INTO publishers (publisher_name, city) VALUES
 ('McGraw-Hill Education','New York'),
 ('Pearson','London'),
 ('Oxford University Press','Oxford'),
 ('O''Reilly Media','Sebastopol'),
 ('Wiley India','New Delhi');

INSERT INTO categories (category_name) VALUES
 ('Computer Science'),('Mathematics'),('Literature'),('Physics'),('History');

INSERT INTO authors (author_name) VALUES
 ('Abraham Silberschatz'),('Henry F. Korth'),('S. Sudarshan'),
 ('Ramez Elmasri'),('Shamkant B. Navathe'),('Thomas H. Cormen'),
 ('R. K. Narayan'),('Erwin Kreyszig'),('H. C. Verma'),
 ('Bipin Chandra'),('Alan Beaulieu'),('Gilbert Strang');

INSERT INTO books (title, isbn, price, total_copies, available_copies,
                   publisher_id, category_id) VALUES
 ('Database System Concepts','978-1-0000-0001-1',899.00,5,3,1,1),
 ('Fundamentals of Database Systems','978-1-0000-0002-2',849.00,4,3,2,1),
 ('Introduction to Algorithms','978-1-0000-0003-3',1199.00,3,1,1,1),
 ('Advanced Engineering Mathematics','978-1-0000-0004-4',699.00,6,6,5,2),
 ('Malgudi Days','978-1-0000-0005-5',250.00,4,4,3,3),
 ('Concepts of Physics','978-1-0000-0006-6',550.00,3,2,5,4),
 ('A History of Modern India','978-1-0000-0007-7',420.00,2,2,3,5),
 ('Learning SQL','978-1-0000-0008-8',650.00,3,3,4,1),
 ('The Guide','978-1-0000-0009-9',300.00,3,3,3,3),
 ('Linear Algebra and Its Applications','978-1-0000-0010-0',480.00,2,2,2,2);

INSERT INTO book_authors (book_id, author_id) VALUES
 (1,1),(1,2),(1,3),(2,4),(2,5),(3,6),(4,8),
 (5,7),(6,9),(7,10),(8,11),(9,7),(10,12);

INSERT INTO members (member_name, email, phone, join_date) VALUES
 ('Anil Kumar','anil.kumar@example.com','9876543210','2026-01-10'),
 ('Sneha Rao','sneha.rao@example.com','9876543211','2026-01-15'),
 ('Rahul Verma','rahul.v@example.com','9876543212','2026-02-03'),
 ('Priya Sharma','priya.s@example.com','9876543213','2026-02-20'),
 ('Manoj Babu','manoj.b@example.com','9876543214','2025-11-05'),
 ('Divya Lakshmi','divya.l@example.com','9876543215','2026-03-12'),
 ('Suresh Naidu','suresh.n@example.com','9876543216','2025-12-18'),
 ('Harika Devi','harika.d@example.com','9876543217','2026-04-01');

INSERT INTO librarians (librarian_name, shift) VALUES
 ('Ravi Teja','Morning'),('Lakshmi Prasanna','Evening'),('Srinivas Rao','Morning');

INSERT INTO issues (member_id, book_id, librarian_id,
                    issue_date, due_date, return_date) VALUES
 (1,1,1,'2026-08-01','2026-08-15','2026-08-14'),
 (1,3,1,'2026-08-20','2026-09-03',NULL),
 (2,2,2,'2026-08-05','2026-08-19','2026-08-25'),
 (3,4,1,'2026-08-10','2026-08-24','2026-08-23'),
 (4,3,3,'2026-09-01','2026-09-15',NULL),
 (5,6,2,'2026-09-05','2026-09-19','2026-09-30'),
 (2,1,2,'2026-09-10','2026-09-24',NULL),
 (3,2,3,'2026-09-15','2026-09-29',NULL),
 (6,4,1,'2026-09-18','2026-10-02','2026-10-01'),
 (7,1,3,'2026-09-20','2026-10-04',NULL),
 (7,6,1,'2026-09-22','2026-10-06',NULL),
 (4,4,2,'2026-09-25','2026-10-09','2026-09-30');

INSERT INTO fines (issue_id, fine_amount, paid_status) VALUES
 (3,12.00,'Paid'),(6,22.00,'Unpaid'),(2,62.00,'Unpaid'),(5,38.00,'Unpaid');

-- UPDATE and DELETE examples
UPDATE members SET phone = '9876500000' WHERE member_id = 2;
UPDATE books   SET price = 920.00       WHERE book_id = 1;
INSERT INTO members (member_name, email, phone, join_date)
  VALUES ('Test User','test.user@example.com','9000000000','2026-10-01');
DELETE FROM members WHERE email = 'test.user@example.com';

-- ===== PART 3: QUERIES Q1-Q32 =====
-- 5.1 Basic retrieval
-- Q1: Display all books in the catalogue
SELECT * FROM books;
-- Q2: Books priced above Rs. 500, costliest first
SELECT title, price FROM books
WHERE price > 500 ORDER BY price DESC;
-- Q3: Members who joined in 2026
SELECT member_name, email FROM members
WHERE join_date >= '2026-01-01';
-- Q4: Books whose title contains 'Database'
SELECT book_id, title FROM books
WHERE title LIKE '%Database%';
-- Q5: Books issued but not yet returned
SELECT issue_id, member_id, book_id, due_date
FROM issues WHERE return_date IS NULL;

-- 5.2 Joins
-- Q6: Natural join
SELECT title, category_name
FROM books NATURAL JOIN categories;
-- Q7: Equi join
SELECT b.title, p.publisher_name
FROM books b, publishers p
WHERE b.publisher_id = p.publisher_id;
-- Q8: Inner join (3 tables)
SELECT m.member_name, b.title, i.issue_date
FROM issues i
INNER JOIN members m ON i.member_id = m.member_id
INNER JOIN books b   ON i.book_id = b.book_id;
-- Q9: Left outer join
SELECT m.member_name, i.issue_id
FROM members m
LEFT JOIN issues i ON m.member_id = i.member_id;
-- Q10: Right outer join
SELECT i.issue_id, b.title
FROM issues i
RIGHT JOIN books b ON i.book_id = b.book_id;
-- Q11: Full outer join (LEFT UNION RIGHT)
SELECT b.title, i.issue_id
FROM books b LEFT JOIN issues i ON b.book_id = i.book_id
UNION
SELECT b.title, i.issue_id
FROM books b RIGHT JOIN issues i ON b.book_id = i.book_id;

-- 5.3 Aggregates
-- Q12: COUNT
SELECT COUNT(*) AS total_titles FROM books;
-- Q13: SUM, AVG
SELECT SUM(total_copies) AS copies, AVG(price) AS avg_price
FROM books;
-- Q14: COUNT with GROUP BY
SELECT c.category_name, COUNT(*) AS titles
FROM books b JOIN categories c
  ON b.category_id = c.category_id
GROUP BY c.category_name;
-- Q15: COUNT, GROUP BY, HAVING
SELECT member_id, COUNT(*) AS books_issued
FROM issues GROUP BY member_id
HAVING COUNT(*) > 1;
-- Q16: MAX, MIN
SELECT MAX(price) AS costliest, MIN(price) AS cheapest
FROM books;

-- 5.4 Subqueries
-- Q17: Nested (scalar subquery)
SELECT title, price FROM books
WHERE price > (SELECT AVG(price) FROM books);
-- Q18: Nested (IN)
SELECT member_name FROM members
WHERE member_id IN (SELECT member_id FROM issues);
-- Q19: Nested (NOT IN)
SELECT title FROM books
WHERE book_id NOT IN (SELECT book_id FROM issues);
-- Q20: Correlated
SELECT b.title, b.price FROM books b
WHERE b.price > (SELECT AVG(b2.price) FROM books b2
                 WHERE b2.category_id = b.category_id);
-- Q21: Correlated (EXISTS)
SELECT m.member_name FROM members m
WHERE EXISTS (SELECT 1 FROM issues i
  JOIN fines f ON f.issue_id = i.issue_id
  WHERE i.member_id = m.member_id
    AND f.paid_status = 'Unpaid');

-- 5.5 Views and set operations
-- Q22: Updatable view (simple, single table)
CREATE VIEW available_books AS
SELECT book_id, title, available_copies
FROM books WHERE available_copies > 0;
-- Q23: Non-updatable view (GROUP BY)
CREATE VIEW member_issue_count AS
SELECT m.member_id, m.member_name,
       COUNT(i.issue_id) AS total_issues
FROM members m LEFT JOIN issues i
  ON m.member_id = i.member_id
GROUP BY m.member_id, m.member_name;
-- Q24: UNION
SELECT member_name AS person_name FROM members
UNION
SELECT librarian_name FROM librarians;
-- Q25: INTERSECT (requires MySQL 8.0.31+)
SELECT issue_id FROM issues
INTERSECT
SELECT issue_id FROM fines;
-- Q26: EXCEPT / MINUS (requires MySQL 8.0.31+)
SELECT book_id FROM books
EXCEPT
SELECT book_id FROM issues;

-- 5.6 DCL and TCL
-- Q27: GRANT - Give a staff user limited access
CREATE USER 'lib_staff'@'localhost'
  IDENTIFIED BY 'Staff@2026';
GRANT SELECT, INSERT, UPDATE
  ON library_db.issues TO 'lib_staff'@'localhost';
-- Q28: REVOKE - Withdraw the update privilege
REVOKE UPDATE ON library_db.issues
  FROM 'lib_staff'@'localhost';
-- Q29: COMMIT - Make a change permanent
START TRANSACTION;
UPDATE members SET status = 'Inactive'
  WHERE member_id = 8;
COMMIT;
-- Q30: SAVEPOINT - Mark a point inside a transaction
START TRANSACTION;
UPDATE books SET price = price + 50
  WHERE book_id = 5;
SAVEPOINT after_price_update;
-- Q31: ROLLBACK TO - Undo work after the savepoint only
DELETE FROM fines WHERE fine_id = 4;
ROLLBACK TO after_price_update;
-- Q32: ROLLBACK - Undo the whole transaction
ROLLBACK;
