/*==============================================================*/
/* DBMS name:      Sybase SQL Anywhere 12                       */
/* Created on:     2020-02-04 00:16:08                          */
/*==============================================================*/


if exists(select 1 from sys.sysforeignkey where role='FK_BOOKS_HI_BELONGS3_BOOK') then
    alter table Books_history
       delete foreign key FK_BOOKS_HI_BELONGS3_BOOK
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LENT_BOO_BELONGS_BOOK') then
    alter table Lent_book
       delete foreign key FK_LENT_BOO_BELONGS_BOOK
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LENT_BOO_BELONGS2_OVERDUE_') then
    alter table Lent_book
       delete foreign key FK_LENT_BOO_BELONGS2_OVERDUE_
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LENT_BOO_BORROWS_READER') then
    alter table Lent_book
       delete foreign key FK_LENT_BOO_BORROWS_READER
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_LENT_BOO_LENDS_EMPLOYEE') then
    alter table Lent_book
       delete foreign key FK_LENT_BOO_LENDS_EMPLOYEE
end if;

if exists(select 1 from sys.sysforeignkey where role='FK_OVERDUE__REVIEWS_EMPLOYEE') then
    alter table Overdue_return
       delete foreign key FK_OVERDUE__REVIEWS_EMPLOYEE
end if;

drop index if exists Book.Book_PK;

drop table if exists Book;

drop index if exists Books_history.Belongs3_FK;

drop index if exists Books_history.Books_history_PK;

drop table if exists Books_history;

drop index if exists Employee.Employee_PK;

drop table if exists Employee;

drop index if exists Lent_book.Borrows_FK;

drop index if exists Lent_book.Lends_FK;

drop index if exists Lent_book.Belongs_FK;

drop index if exists Lent_book.Lent_book_PK;

drop table if exists Lent_book;

drop index if exists Overdue_return.Reviews_FK;

drop index if exists Overdue_return.Overdue_return_PK;

drop table if exists Overdue_return;

drop index if exists Reader.Reader_PK;

drop table if exists Reader;

/*==============================================================*/
/* Table: Book                                                  */
/*==============================================================*/
create table Book 
(
   ISBN                 numeric(13)                    not null,
   Title                varchar(50)                    not null,
   Author               varchar(50)                    not null,
   constraint PK_BOOK primary key (ISBN)
);

/*==============================================================*/
/* Index: Book_PK                                               */
/*==============================================================*/
create unique index Book_PK on Book (
ISBN ASC
);

/*==============================================================*/
/* Table: Books_history                                         */
/*==============================================================*/
create table Books_history 
(
   RecordID             integer                        not null,
   ISBN                 numeric(13)                    not null,
   Lending_date         date                           not null,
   Returning_date       date                           not null,
   constraint PK_BOOKS_HISTORY primary key (RecordID)
);

/*==============================================================*/
/* Index: Books_history_PK                                      */
/*==============================================================*/
create unique index Books_history_PK on Books_history (
RecordID ASC
);

/*==============================================================*/
/* Index: Belongs3_FK                                           */
/*==============================================================*/
create index Belongs3_FK on Books_history (
ISBN ASC
);

/*==============================================================*/
/* Table: Employee                                              */
/*==============================================================*/
create table Employee 
(
   Employee_ID          integer                        not null,
   Name                 varchar(30)                    not null,
   Surname              varchar(30)                    not null,
   constraint PK_EMPLOYEE primary key (Employee_ID)
);

/*==============================================================*/
/* Index: Employee_PK                                           */
/*==============================================================*/
create unique index Employee_PK on Employee (
Employee_ID ASC
);

/*==============================================================*/
/* Table: Lent_book                                             */
/*==============================================================*/
create table Lent_book 
(
   LendingID            integer                        not null,
   ISBN                 numeric(13)                    not null,
   Employee_ID          integer                        not null,
   Reader_ID            integer                        not null,
   constraint PK_LENT_BOOK primary key (LendingID)
);

/*==============================================================*/
/* Index: Lent_book_PK                                          */
/*==============================================================*/
create unique index Lent_book_PK on Lent_book (
LendingID ASC
);

/*==============================================================*/
/* Index: Belongs_FK                                            */
/*==============================================================*/
create index Belongs_FK on Lent_book (
ISBN ASC
);

/*==============================================================*/
/* Index: Lends_FK                                              */
/*==============================================================*/
create index Lends_FK on Lent_book (
Employee_ID ASC
);

/*==============================================================*/
/* Index: Borrows_FK                                            */
/*==============================================================*/
create index Borrows_FK on Lent_book (
Reader_ID ASC
);

/*==============================================================*/
/* Table: Overdue_return                                        */
/*==============================================================*/
create table Overdue_return 
(
   LendingID            integer                        not null,
   Employee_ID          integer                        not null,
   Overdue_time         time                           not null,
   Fine                 numeric(8)                     not null,
   EmployeeID           integer                        not null,
   RegisterDate         date                           not null,
   constraint PK_OVERDUE_RETURN primary key (LendingID)
);

/*==============================================================*/
/* Index: Overdue_return_PK                                     */
/*==============================================================*/
create unique index Overdue_return_PK on Overdue_return (
LendingID ASC
);

/*==============================================================*/
/* Index: Reviews_FK                                            */
/*==============================================================*/
create index Reviews_FK on Overdue_return (
Employee_ID ASC
);

/*==============================================================*/
/* Table: Reader                                                */
/*==============================================================*/
create table Reader 
(
   Reader_ID            integer                        not null,
   Name                 varchar(30)                    not null,
   Surname              varchar(30)                    not null,
   constraint PK_READER primary key (Reader_ID)
);

/*==============================================================*/
/* Index: Reader_PK                                             */
/*==============================================================*/
create unique index Reader_PK on Reader (
Reader_ID ASC
);

alter table Books_history
   add constraint FK_BOOKS_HI_BELONGS3_BOOK foreign key (ISBN)
      references Book (ISBN)
      on update restrict
      on delete restrict;

alter table Lent_book
   add constraint FK_LENT_BOO_BELONGS_BOOK foreign key (ISBN)
      references Book (ISBN)
      on update restrict
      on delete restrict;

alter table Lent_book
   add constraint FK_LENT_BOO_BELONGS2_OVERDUE_ foreign key (LendingID)
      references Overdue_return (LendingID)
      on update restrict
      on delete restrict;

alter table Lent_book
   add constraint FK_LENT_BOO_BORROWS_READER foreign key (Reader_ID)
      references Reader (Reader_ID)
      on update restrict
      on delete restrict;

alter table Lent_book
   add constraint FK_LENT_BOO_LENDS_EMPLOYEE foreign key (Employee_ID)
      references Employee (Employee_ID)
      on update restrict
      on delete restrict;

alter table Overdue_return
   add constraint FK_OVERDUE__REVIEWS_EMPLOYEE foreign key (Employee_ID)
      references Employee (Employee_ID)
      on update restrict
      on delete restrict;

