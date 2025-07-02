Library Management System SQL Project
Overview
This is a simple SQL-based Library Management System that demonstrates various SQL concepts including table creation, constraints, joins, views, stored procedures, triggers, and queries. The project manages books, members, and loans in a library setting.
Features

Database schema with three main tables: Books, Members, and Loans
Primary and foreign key constraints
Indexes for query optimization
View for active loans
Stored procedure for borrowing books
Trigger for automatic inventory updates
Sample queries demonstrating various SQL operations

Prerequisites

Any SQL database management system (e.g., MySQL, PostgreSQL, SQLite)
Basic SQL knowledge

Setup Instructions

Clone this repository to your local machine:git clone https://github.com/your-username/library-management-sql.git


Connect to your SQL database management system
Run the library_management.sql script to create the database, tables, and sample data
Use the provided queries or create new ones to interact with the database

Database Schema
The database consists of three tables with the following relationships:
Books (book_id, title, author, publication_year, isbn, available_copies)
   |
   | 1:N
   |
Loans (loan_id, book_id, member_id, loan_date, due_date, return_date)
   |
   | N:1
   |
Members (member_id, first_name, last_name, email, join_date, status)

Usage

Run the SQL file to set up the database
Use the BorrowBook stored procedure to create new loans
Query the ActiveLoans view to see current loans
Explore the sample queries for various operations
The trigger automatically updates book availability when loans are returned

Sample Queries

List books published after 1950
Count loans per book
Find currently borrowed books
Get statistics on book collection

Contributing
Feel free to fork this repository and submit pull requests with improvements or additional features.
License
This project is licensed under the MIT License.
