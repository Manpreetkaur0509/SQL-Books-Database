DROP TABLE Authors Cascade Constraints;
CREATE TABLE Authors  (
  Au_id    	char(3)     ,
  Fname 	varchar2(15),
  Lname 	varchar2(15),
  Phone    	varchar2(12),
  Street        varchar2(20),
  City     	varchar2(15),
  State    	char(2)     ,
  Zip      	char(5)     ,
  CONSTRAINT Authors_pk PRIMARY KEY (au_id)
  );


DROP TABLE Publishers Cascade Constraints;
CREATE TABLE Publishers
  (
  Pub_id   	char(3)     ,
  Pub_name 	varchar2(20),
  City     	varchar2(15),
  State    	char(2)     ,
  Country  	varchar2(15),
  CONSTRAINT Publishers_pk PRIMARY KEY (pub_id)
  );


DROP TABLE Titles Cascade Constraints;
CREATE TABLE Titles
  (
  Title_id      char(3)     ,
  Title         varchar2(40),
  Genre     	varchar2(10),
  Pages     	number      ,
  Price     	number(5,2) ,
  Sales     	number      ,
  Pub_id        char(3)     ,
  Pubdate    	date        ,
  Advance      	number(9,2) ,
  Royalty_rate 	number(5,2) ,
  CONSTRAINT Titles_pk PRIMARY KEY (title_id),
  CONSTRAINT Titles_Publishers_fk FOREIGN KEY (Pub_id)
				REFERENCES Publishers (pub_id)
  );


DROP TABLE Author_Titles Cascade Constraints;
CREATE TABLE Author_Titles
  (
  Title_id      char(3)     ,
  Au_id         char(3)     ,
  Au_order      number      ,
  Royalty_share number(5,2) ,
  CONSTRAINT Author_Titles_pk PRIMARY KEY (title_id, au_id),
  CONSTRAINT Author_Titles__Authors_fk FOREIGN KEY (au_id) 
						REFERENCES Authors(au_id),
  CONSTRAINT Author_Titles__Titles_fk FOREIGN KEY (title_id) 
						REFERENCES Titles(title_id)
  );
